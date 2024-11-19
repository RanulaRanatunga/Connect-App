//
//  TCPNetworkVC.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-19.
//

import UIKit
import Network

class TCPNetworkVC: UIViewController {
    
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var sendDataTextField: UITextField!
    @IBOutlet weak var receivedDataTextView: UITextView!
    
    private var tcpClient: TCPClient?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialConfiguration()
      
    }
    

    private func setupInitialConfiguration() {
            hostTextField.text = "localhost\n"
            portTextField.text = "8080"
        }
        
        @IBAction func connectButtonTapped(_ sender: UIButton) {
            guard let host = hostTextField.text,
                  let portString = portTextField.text,
                  let port = Int(portString) else {
                showAlert(message: "Invalid host or port")
                return
            }
            
            tcpClient = TCPClient(host: host, port: port)
            tcpClient?.connect()
        }
        
        @IBAction func sendButtonTapped(_ sender: UIButton) {
            guard let dataText = sendDataTextField.text else { return }
            
            // Convert string to binary data
            let binaryData = dataText.data(using: .utf8) ?? Data()
            tcpClient?.writeBinaryData(binaryData)
        }
        
        @IBAction func readButtonTapped(_ sender: UIButton) {
            tcpClient?.readBinaryData { [weak self] data, error in
                DispatchQueue.main.async {
                    if let receivedData = data {
                        let dataString = receivedData.map { String(format: "0x%02x", $0) }.joined(separator: " ")
                        self?.receivedDataTextView.text = "Received: \(dataString)"
                    } else if let error = error {
                        self?.showAlert(message: "Read Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        @IBAction func disconnectButtonTapped(_ sender: UIButton) {
            tcpClient?.disconnect()
            tcpClient = nil
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Network", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }


    class TCPClient {
        private var connection: NWConnection?
        private let host: String
        private let port: Int
        
        init(host: String, port: Int) {
            self.host = host
            self.port = port
        }
        
        func connect() {
            let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: NWEndpoint.Port(integerLiteral: UInt16(port)))
            connection = NWConnection(to: endpoint, using: .tcp)
            
            connection?.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    print("Connected to server")
                case .failed(let error):
                    print("Connection failed: \(error)")
                default:
                    break
                }
            }
            
            connection?.start(queue: .global())
        }
        
        func writeBinaryData(_ data: Data) {
            connection?.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    print("Error sending data: \(error)")
                }
            })
        }
        
        func readBinaryData(completion: @escaping (Data?, Error?) -> Void) {
            connection?.receive(minimumIncompleteLength: 1, maximumLength: 65536) { content, _, isComplete, error in
                if let data = content {
                    completion(data, nil)
                } else if let error = error {
                    completion(nil, error)
                }
                
                if isComplete {
                    self.connection?.cancel()
                }
            }
        }
        
        func disconnect() {
            connection?.cancel()
            connection = nil
        }
   
}
