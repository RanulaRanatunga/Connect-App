//
//  WiFiNetworkVC.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-19.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class WiFiNetworkVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var networkTableView: UITableView!
    
    var availableNetworks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkTableView.delegate = self
        networkTableView.dataSource = self
    }
    
    @IBAction func scanNetworksPressed(_ sender: UIButton) {
           scanWiFiNetworks()
       }
       
    func scanWiFiNetworks() {
        availableNetworks.removeAll()
        
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return }
        
        for interface in interfaces {
            guard let networkInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any],
                  let ssid = networkInfo[kCNNetworkInfoKeySSID as String] as? String else {
                continue
            }
            
            availableNetworks.append(ssid)
        }
        
        networkTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return availableNetworks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkCell", for: indexPath)
            cell.textLabel?.text = availableNetworks[indexPath.row]
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedNetwork = availableNetworks[indexPath.row]
            showPasswordPrompt(for: selectedNetwork)
        }
        
        func showPasswordPrompt(for network: String) {
            let alertController = UIAlertController(title: "Connect to Network", message: network, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            
            let connectAction = UIAlertAction(title: "Connect", style: .default) { [weak self] _ in
                guard let password = alertController.textFields?.first?.text else { return }
                self?.connectToNetwork(ssid: network, password: password)
            }
            
            alertController.addAction(connectAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alertController, animated: true)
        }
        
        func connectToNetwork(ssid: String, password: String) {
            let configuration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
            
            NEHotspotConfigurationManager.shared.apply(configuration) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert(title: "Connection Failed", message: error.localizedDescription)
                    } else {
                        self.showAlert(title: "Success", message: "Connected to \(ssid)")
                    }
                }
            }
        }
        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
  
}
