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
    var viewModel: EventCellViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 68, height: 68)
        iv.layer.cornerRadius = 68/2
        iv.backgroundColor = .mainPurple

        return iv
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 2
        
        return label
    }()
    
    private let eventDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        guard let viewModel = viewModel else {return}
            
        addSubview(profileImageView)
        profileImageView.sd_setImage(with: viewModel.event.image)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 8)

        let nameDateStack = UIStackView(arrangedSubviews: [eventDateLabel, eventNameLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 4
        addSubview(nameDateStack)
        eventDateLabel.text = viewModel.event.date.formatted(date: .numeric, time: .omitted)
        eventNameLabel.text = viewModel.event.title
        nameDateStack.centerY(inView: self)
        nameDateStack.anchor(left: profileImageView.rightAnchor, paddingLeft: 12)

        addSubview(priceLabel)
        priceLabel.text = "R$ \(viewModel.event.price)"
        priceLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
    }
}
