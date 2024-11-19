//
//  BluetoothVC.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-19.
//

import UIKit
import CoreBluetooth

class BluetoothVC: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate{
    

    
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals: [CBPeripheral] = []
    
    
    private let tableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView

     }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bluetooth Devices"
        view.backgroundColor = .white
        setupTableView()
        centralManager = CBCentralManager(delegate: self, queue: nil)
       
    }
    
    
    private func setupTableView() {
           view.addSubview(tableView)
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(BlutoothTableViewCell.self, forCellReuseIdentifier: BlutoothTableViewCell.identifier)
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

           ])

       }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            if central.state == .poweredOn {
                centralManager.scanForPeripherals(withServices: nil, options: nil)

            } else {

                print("Bluetooth is not available.")

            }

        }

        

        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

            if !discoveredPeripherals.contains(peripheral) {

                discoveredPeripherals.append(peripheral)

                DispatchQueue.main.async {

                    self.tableView.reloadData()

                }

            }

        }

        

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return discoveredPeripherals.count

        }

        

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: BlutoothTableViewCell.identifier, for: indexPath) as! BlutoothTableViewCell

            let peripheral = discoveredPeripherals[indexPath.row]

            cell.configure(with: peripheral.name ?? "Unknown Device")

            return cell

        }

        

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let selectedPeripheral = discoveredPeripherals[indexPath.row]

            centralManager.connect(selectedPeripheral, options: nil)

        }

        

        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("Connected to \(peripheral.name ?? "Unknown Device")")

        }

        

        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            print("Disconnected from \(peripheral.name ?? "Unknown Device")")


        }


}
