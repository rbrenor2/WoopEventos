//
//  EventDetail.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit
import SDWebImage

class EventDetailView: UIView {
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            configureUI(event: self.event!)
        }
    }
    
    var handleShareTapped: Selector
    var handleCheckinTapped: Selector
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGreen
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var shareButton: UIButton = Utilities().actionIconButton(withIconNamed: K.EventDetail.shareButtonIconName, handleTap: handleShareTapped)

    private lazy var checkinButton: UIButton = Utilities().actionButton(withTitle: K.EventDetail.checkinButtonTitle, handleTap: handleCheckinTapped)
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var detailInfoView: EventDetailInfoView = {
        let frame = CGRect(origin: center, size: CGSize(width: frame.width, height: 300))
        let detailView = EventDetailInfoView(frame: frame)
        return detailView
    }()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, handleCheckin: Selector, handleShare: Selector) {
        self.handleShareTapped = handleShare
        self.handleCheckinTapped = handleCheckin
        
        super.init(frame: frame)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    func configureUI(event: Event) {
        backgroundColor = .white
        
        setupImageView(withURL: event.image!)
        setupActionButtons()
        
        setupPriceLabel(withPrice: event.price)
                
        addSubview(detailInfoView)
        detailInfoView.event = event
        detailInfoView.anchor(top: checkinButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
    }
    
    func setupImageView(withURL url: URL) {
        addSubview(imageView)
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        imageView.sd_setImage(with: url, placeholderImage: Utilities().getPlaceholderImage())
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, width: frame.width, height: 200)
    }
    
    func setupActionButtons() {
        addSubview(checkinButton)
        checkinButton.anchor(top: imageView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        addSubview(shareButton)
        shareButton.anchor(top: imageView.bottomAnchor, right: checkinButton.leftAnchor, paddingTop: 18, paddingRight: 24)
    }
    
    func setupPriceLabel(withPrice price: Double) {
        addSubview(priceLabel)
        priceLabel.text = Utilities().formatPrice(withPrice: price)
        priceLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
    }
    
    // MARK: - Helpers
    
    func getTextToShare() -> String {
        guard let price = priceLabel.text else {return "N/I"}
        let info = detailInfoView.getTextToShare()
        let text = "\(info) \n Preço: \(price)"
        return text
    }
    
    
}
