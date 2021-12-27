//
//  EventDetail.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit
import SDWebImage
import MapKit

class EventDetailView: UIScrollView {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            configureUI(event: event!)
        }
    }
    
    var handleShareTapped: Selector?
    var handleCheckinTapped: Selector?
    var handleCloseTapped: Selector?

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGreen
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var shareButton: UIButton = Utilities().actionIconButton(withIconNamed: K.EventDetail.shareButtonIconName, handleTap: handleShareTapped!)

    private lazy var checkinButton: UIButton = Utilities().actionButton(withTitle: K.EventDetail.checkinButtonTitle, handleTap: handleCheckinTapped!)
    
    private lazy var closeButton: UIButton = Utilities().actionIconButton(withIconNamed: K.EventDetail.closeButtonIconName, handleTap: handleCloseTapped!)
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private let peopleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center

        return label
    }()
    
    
    private lazy var detailInfoView: EventDetailInfoView = {
        let frame = CGRect(origin: center, size: CGSize(width: frame.width, height: 1000))
        let detailView = EventDetailInfoView(frame: frame, event: self.event!)
        return detailView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = K.EventDetail.descriptionTitle
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let titleLocationLabel: UILabel = {
        let label = UILabel()
        label.text = K.EventDetail.locationTitle
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let infoStack: UIStackView = UIStackView()
    
    let scrollView: UIScrollView = UIScrollView()
    
    // MARK: - Lifecycle

    init(frame: CGRect, handleCheckin: Selector, handleShare: Selector, handleClose: Selector) {
        self.handleShareTapped = handleShare
        self.handleCheckinTapped = handleCheckin
        self.handleCloseTapped = handleClose

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    func configureUI(event: Event) {
        bounces = false
        backgroundColor = .white
        
        setupImageView(withURL: event.image!)
        setupActionPriceView(withEvent: event)
        setupCloseButton()
    }
    
    func setupImageView(withURL url: URL) {
        addSubview(imageView)
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        imageView.sd_setImage(with: url, placeholderImage: Utilities().getPlaceholderImage())
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, width: frame.width, height: 200)
    }
    
    func setupActionPriceView(withEvent event: Event) {
        let actionStack = UIStackView(arrangedSubviews: [shareButton, checkinButton])
        actionStack.distribution = .fill
        actionStack.spacing = 8
                
        let mainStack = UIStackView(arrangedSubviews: [priceLabel, actionStack])
        mainStack.backgroundColor = .white
        mainStack.distribution = .fill
        mainStack.axis = .horizontal
//        mainStack.spacing = 8
        
        addSubview(mainStack)
        mainStack.anchor(top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 14, paddingRight: 14)
        actionStack.anchor(top: mainStack.topAnchor, right: mainStack.rightAnchor, paddingTop: 14, paddingBottom: 10, paddingRight: 14)
        
        priceLabel.text = Utilities().formatPrice(withPrice: event.price)
        priceLabel.anchor(top: mainStack.topAnchor, left: mainStack.leftAnchor, paddingTop: 14, paddingLeft: 0, paddingBottom: 10)
        
        peopleLabel.text = "\(event.people.count) pessoas confirmadas"
        addSubview(peopleLabel)
        peopleLabel.anchor(top: mainStack.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 12)

        addSubview(detailInfoView)
        detailInfoView.anchor(top: peopleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingBottom: 30, paddingRight: 20, width: frame.width)
    }
    
    func setupCloseButton() {
        addSubview(closeButton)
        closeButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
    }
}
