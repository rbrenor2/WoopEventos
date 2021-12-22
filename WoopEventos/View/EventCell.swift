//
//  EventCell.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit
import SDWebImage
import SwiftIcons

class EventCell: UITableViewCell {
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .mainPurple
//        iv.sd_setImage(with: URL(string: "https://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"))
        
        return iv
    }()
    
    
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Feira de adoção de animais na Redenção"
        
        return label
    }()
    
    private let eventDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "10/07/2022"
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "R$ 22,90"
        
        return label
    }()
    
//    private let seeMoreButton: UIButton = {
//        let button = UIButton()
//        button.setIcon(icon: .fontAwesomeSolid(.plusCircle), iconSize: 20, color: .mainPurple, forState: .normal)
//
//        return button
//    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 8)
        
        let nameDateStack = UIStackView(arrangedSubviews: [eventDateLabel, eventNameLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 4
        addSubview(nameDateStack)
        nameDateStack.centerY(inView: self)
        nameDateStack.anchor(left: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(priceLabel)
        priceLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        
//        addSubview(seeMoreButton)
//        seeMoreButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 12, paddingRight: 12)
        
    }
    
    
}
