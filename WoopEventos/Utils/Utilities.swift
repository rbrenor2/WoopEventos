//
//  Utilities.swift
//  WoopEventos
//
//  Created by Breno Ramos on 22/12/21.
//

import UIKit
import Lottie
import MapKit

class Utilities {
    let locale = Locale(identifier: "pt_BR")
    
    func infoStack(withViews views: [UIView], direction: NSLayoutConstraint.Axis) -> UIStackView {
        let stackedViews = views
        let stack = UIStackView(arrangedSubviews: stackedViews)
        stack.axis = direction
        stack.spacing = 10
        
        return stack
    }
    
    func loadingAnimationView() -> AnimationView {
        let images = ["banana", "pets", "singing", "traveler"]
        let av = AnimationView.init(name: images.randomElement()!)
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.animationSpeed = 0.5
        
        return av
    }
        
    func showLoadingIndicator(inView view: UIView, loadingView: AnimationView, isLoading: Bool) {
        
        loadingView.frame = view.bounds
        
        if isLoading {
            view.addSubview(loadingView)
            loadingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, width: view.frame.width, height: view.frame.height)
            loadingView.center(inView: view)
            loadingView.backgroundColor = .white
            loadingView.play(completion: nil)
        } else {
            loadingView.stop()
            loadingView.removeFromSuperview()
        }
    }
    
    func formatPrice(withPrice price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        
        guard let price = formatter.string(from: NSNumber(value: price)) else {return "N/I"}
        
        return price
    }
    
    func formatDate(withDate date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateStyle = .long
        formatter.timeZone = .current
        let dateStr = formatter.string(from: date)
        
        return dateStr
    }
    
    func setupMapView(location: CLLocationCoordinate2D, annotation: MKPointAnnotation, mapWidth: CGFloat, mapHeight: CGFloat) -> MKMapView {
        
        let mapView = MKMapView()
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        mapView.setRegion(region, animated: true)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false

        mapView.addAnnotation(annotation)
        
        return mapView
    }
    
    func showAlertView(withTarget target: UIViewController, title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .cancel)
        alert.addAction(action)
        target.present(alert, animated: true, completion: nil)
    }
    
    func getErrorMessage(withError error: String) -> String {
        return "Razão: \(error)"
    }
    
    func setupMapAnnotation(withTitle title: String, location: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = title
        return pin
    }
    
    func getMapUrl(from latitude: Double, longitude: Double) -> String {
        let url = "http://maps.apple.com/maps?saddr=\(latitude),\(longitude)"
        return url
    }
    
    func showErrorView(forTarget target: UIViewController, withTitle title: String, withMessage message: String) {
        let errorView = EventErrorViewController(title: title, message: message)
        target.present(errorView, animated: true, completion: nil)
    }
    
    func getTextToShare(title: String, date: Date, description: String, price: Double, latitutde: Double, longitude: Double) -> String {
        let formattedDate = self.formatDate(withDate: date)
        let formattedPrice = self.formatPrice(withPrice: price)
        let formattedLocation = self.getMapUrl(from: latitutde, longitude: longitude)
        
        let text = "\(title)\n\(formattedDate) \n \n\(description) \n \n Preço: \(formattedPrice) \n \n Local: \(formattedLocation)"
        
        return text
    }
    
    func actionButton(withTitle title: String, handleTap: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightPurple
        button.setTitle(title, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: handleTap, for: .touchUpInside)

        return button
    }
    
    func actionIconButton(withIconNamed iconName: String, handleTap: Selector) -> UIButton  {
        
        let favoriteButtonConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        
        let button = UIButton()
        button.tintColor = .mainPurple
        button.addTarget(self, action:handleTap, for: .touchUpInside)
        
        let image = UIImage.init(systemName: iconName, withConfiguration: favoriteButtonConfiguration)
          button.setImage(image, for: .normal)
        
        return button
    }
    
    func getPlaceholderImage() -> UIImage {
        return UIImage(named: K.General.placeholderimage)!
    }
}
