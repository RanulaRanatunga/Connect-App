//
//  NetworkCell.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-19.
//

import UIKit


class NetworkCell: UITableViewCell {
    
    @IBOutlet weak var networkNameLabel: UILabel!
    @IBOutlet weak var signalStrengthImageView: UIImageView!
    @IBOutlet weak var securityTypeLabel: UILabel!
    
    enum SecurityType {
        case open
        case wep
        case wpa
        case wpa2
        case wpa3
    }
    
    func configure(
        networkName: String,
        signalStrength: Int,
        securityType: SecurityType
    ) {
        networkNameLabel.text = networkName
        configureSignalStrengthIndicator(strength: signalStrength)
        configureSecurity(type: securityType)
    }
    
    
    private func configureSignalStrengthIndicator(strength: Int) {
        switch strength {
        case 0...25:
            signalStrengthImageView.image = UIImage(systemName: "wifi.slash")
        case 26...50:
            signalStrengthImageView.image = UIImage(systemName: "wifi.circle")
        case 51...75:
            signalStrengthImageView.image = UIImage(systemName: "wifi")
        default:
            signalStrengthImageView.image = UIImage(systemName: "wifi.exclamationmark")
        }
    }
    
    private func configureSecurity(type: SecurityType) {
        switch type {
        case .open:
            securityTypeLabel.text = "Open"
            securityTypeLabel.textColor = .systemGreen
        case .wep:
            securityTypeLabel.text = "WEP"
            securityTypeLabel.textColor = .systemOrange
        case .wpa:
            securityTypeLabel.text = "WPA"
            securityTypeLabel.textColor = .systemBlue
        case .wpa2:
            securityTypeLabel.text = "WPA2"
            securityTypeLabel.textColor = .systemIndigo
        case .wpa3:
            securityTypeLabel.text = "WPA3"
            securityTypeLabel.textColor = .systemPurple
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        networkNameLabel.text = nil
        signalStrengthImageView.image = nil
        securityTypeLabel.text = nil
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
    
    
    struct WiFiNetwork {
        let ssid: String
        var signalStrength: Int = 0
        var securityType: NetworkCell.SecurityType = .open
    }


