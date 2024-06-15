//
//  EventCell.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit
import SDWebImage

class EventCell: UITableViewCell {
    
    // MARK: - Properties
    var event: Event? {
        didSet {
            guard let event = event else {return}
            configureUI(event: event)
        }
    }
    
    private let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 88, height: 88)
        iv.layer.cornerRadius = 44/2
        iv.backgroundColor = .lightGreen

        return iv
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
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
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .mainPurple
        button.addTarget(EventCell.self, action: #selector(handleFavoriteTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let favoriteButtonConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
    
    var isFavorite: Bool = false
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureFavoriteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureFavoriteButton() {
        let image = UIImage.init(systemName: K.EventList.favoriteUnselectedIcon, withConfiguration: favoriteButtonConfiguration)
        favoriteButton.setImage(image, for: .normal)
    }
    
    func configureUI(event: Event) {
        backgroundColor = .white
                    
        addSubview(eventImageView)
        
        eventImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        eventImageView.sd_setImage(with: event.image, placeholderImage: Utilities().getPlaceholderImage())
        
        eventImageView.centerY(inView: self)
        eventImageView.anchor(left: leftAnchor, paddingLeft: 8)

        let nameDateStack = UIStackView(arrangedSubviews: [eventDateLabel, eventNameLabel, priceLabel])
        nameDateStack.axis = .vertical
        nameDateStack.spacing = 4
        addSubview(nameDateStack)
        
        eventDateLabel.text = Utilities().formatDate(withDate: event.date)
        
        eventNameLabel.text = event.title
        nameDateStack.centerY(inView: self)
        nameDateStack.anchor(left: eventImageView.rightAnchor, paddingLeft: 12, width: 200)

        priceLabel.text = Utilities().formatPrice(withPrice: event.price)
        
        addSubview(favoriteButton)
        favoriteButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
    }
    
    // MARK: - Selectors
    @objc func handleFavoriteTapped() {
        isFavorite = isFavorite ? false : true
        let image = UIImage.init(systemName: isFavorite ? K.EventList.favoriteSelectedIcon:K.EventList.favoriteUnselectedIcon, withConfiguration: favoriteButtonConfiguration)
        favoriteButton.setImage(image, for: .normal)
    }
}
