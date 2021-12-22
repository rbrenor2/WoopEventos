//
//  EventDetailController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit

class EventDetailController: UIViewController {
    // MARK: - Properties
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGreen
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        //        iv.sd_setImage(with: URL(string: "https://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"))
        return iv
    }()
    
    let titleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Descrição"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let titleLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Onde?"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let mapView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainPurple
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        //        iv.sd_setImage(with: URL(string: "https://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"))
        return iv
    }()
    
    let shareButton: UIButton = Utilities().actionButton(withIcon: .fontAwesomeSolid(.share), size: 42, color: .mainPurple)
    
    let checkinButton: UIButton = Utilities().actionButton(withIcon: .fontAwesomeSolid(.checkCircle), size: 42, color: .mainPurple)
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 200)
        
        let actionStack = UIStackView(arrangedSubviews: [shareButton, checkinButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 4
        view.addSubview(actionStack)
        actionStack.anchor(top: imageView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingRight: 12, height: view.frame.height - imageView.frame.height - 18)
        
        let descriptionStack = Utilities().infoStack(withTitle: titleDescriptionLabel, views: [descriptionLabel], direction: .vertical)
        scrollView.addSubview(descriptionStack)
        descriptionStack.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingRight: 12)
        
        let locationStack = Utilities().infoStack(withTitle: titleLocationLabel, views: [mapView], direction: .vertical)
        mapView.setDimensions(width: view.frame.width, height: 200)
        scrollView.addSubview(locationStack)
        locationStack.anchor(top: descriptionStack.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingRight: 12)
        
       
        
    }
    
    // MARK: - API
}
