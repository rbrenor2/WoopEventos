//
//  EventDetailController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import UIKit
import SDWebImage
import MapKit

class EventDetailController: UIViewController {
    // MARK: - Properties
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGreen
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
                iv.sd_setImage(with: URL(string: "https://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"))
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
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        
        return mapView
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "square.and.arrow.up"), for: .normal)
        return button
    }()

    let checkinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightPurple
        button.setDimensions(width: 84, height: 32)
        button.layer.cornerRadius = 32/2
        button.setTitle("Check-in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        scroll.contentSize = CGSize(width: 100, height: scroll.frame.height + 900)
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        return scroll
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 200)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: imageView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        view.addSubview(checkinButton)
        checkinButton.anchor(top: imageView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        view.addSubview(scrollView)
        scrollView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 20, paddingRight: 20, width: view.frame.width, height: view.frame.height)
        
        let descriptionStack = Utilities().infoStack(withTitle: titleDescriptionLabel, views: [descriptionLabel], direction: .vertical)
        scrollView.addSubview(descriptionStack)
        descriptionStack.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 18, width: scrollView.frame.width - 500)
        
        let locationStack = Utilities().infoStack(withTitle: titleLocationLabel, views: [mapView], direction: .vertical)
        mapView.setDimensions(width: scrollView.frame.width, height: 200)
        scrollView.addSubview(locationStack)
        locationStack.anchor(top: descriptionStack.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 18, width: scrollView.frame.width - 500)
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center

    }
    
    // MARK: - API
}
