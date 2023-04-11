//
//  EventDetailErrorView.swift
//  WoopEventos
//
//  Created by Breno Ramos on 26/12/21.
//

import UIKit

class EventErrorViewController: UIViewController {
    
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
    
//    private let closeButton: UIButton = Utilities().actionButton(withTitle: K.EventError.closeButtonTitle, handleTap: #selector(handleClose))
    private let closeButton: UIButton = Utilities().actionIconButton(withIconNamed: K.General.closeButtonIconName, handleTap: #selector(handleClose))
    
    // MARK: - Lifecycle
    
    init(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
        
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    // MARK: - UI setup
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top:  view.topAnchor, left:  view.leftAnchor, right:  view.rightAnchor,
                          paddingTop: 70, paddingLeft: 30, paddingRight: 30, width:  view.frame.width, height: 400)
        
        view.addSubview(messageLabel)
        messageLabel.anchor(top: titleLabel.bottomAnchor, left:  view.leftAnchor, right:  view.rightAnchor,
                            paddingTop: 30, paddingLeft: 30, paddingRight: 30, width: view.frame.width, height: 300)
        
        view.addSubview(closeButton)
        closeButton.anchor(top:  view.topAnchor, right:  view.rightAnchor, paddingTop: 12, paddingRight: 12)
    }
    
    // MARK: - Selectors
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
