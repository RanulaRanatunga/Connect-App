//
//  BlutoothTableViewCell.swift
//  ConnectApp
//
//  Created by Ranula Ranatunga on 2024-11-19.
//

import UIKit

class BlutoothTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bTdeviceName: UILabel!

    static let identifier = "BlutoothTableViewCell"

    private let deviceNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label}()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           contentView.addSubview(deviceNameLabel)
           setupConstraints()

       }

       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")

       }


       func configure(with deviceName: String) {
           deviceNameLabel.text = deviceName

       }
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                deviceNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                deviceNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                deviceNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)

            ])

        }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
