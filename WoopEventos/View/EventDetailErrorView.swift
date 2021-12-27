//
//  EventDetailErrorView.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit

class EventDetailErrorView: UIView {
    
    // MARK: - Properties
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, title: String) {        
        super.init(frame: frame)
        configureUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    func configureUI(title: String) {
        backgroundColor = .white
        
        addSubview(messageLabel)
        messageLabel.text = title
        messageLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 100, paddingLeft: 30, paddingRight: 30, width: frame.width, height: 500)

    }
}
