//
//  EventDetailErrorView.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit

class EventErrorView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let closeButton: UIButton = Utilities().actionButton(withTitle: K.EventError.closeButtonTitle, handleTap: #selector(handleClose))
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, title: String, message: String) {
        super.init(frame: frame)
        configureUI(title: title, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    
    func configureUI(title: String, message: String) {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 70, paddingLeft: 30, paddingRight: 30, width: frame.width, height: 400)
        
        addSubview(messageLabel)
        messageLabel.text = message
        messageLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 30, paddingLeft: 30, paddingRight: 30, width: frame.width, height: 300)
        
        addSubview(closeButton)
        closeButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
    }
    
    // MARK: - Selectors
    
    @objc func handleClose() {
        self.removeFromSuperview()
    }
}
