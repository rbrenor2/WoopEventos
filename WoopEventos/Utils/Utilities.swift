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
    func infoStack(withTitle titleLabel: UILabel, views: [UIView], direction: NSLayoutConstraint.Axis) -> UIStackView {
        let stackedViews = [titleLabel] + views
        let stack = UIStackView(arrangedSubviews: stackedViews)
        stack.axis = direction
        stack.spacing = 6
        
        return stack
    }
    
    func loadingAnimationView() -> AnimationView {
        let av = AnimationView.init(name: "traveler")
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.animationSpeed = 0.5
        
        return av
    }
    
    func showLoadingIndicator(inView view: UIView, loadingView: AnimationView, isLoading: Bool) {
        
        loadingView.frame = view.bounds
        
        if isLoading {
            view.addSubview(loadingView)
            loadingView.anchor(width: view.frame.width, height: view.frame.height)
            loadingView.center(inView: view)
            loadingView.backgroundColor = .white
            loadingView.play(completion: nil)
        } else {
            loadingView.stop()
            loadingView.removeFromSuperview()
        }
    }
    
    func formatPrice(withPrice price: Double) -> String {
        let locale = Locale(identifier: "pt_BR")
        let priceFormatter = NumberFormatter()
        priceFormatter.locale = locale
        priceFormatter.numberStyle = .currency
        
        guard let price = priceFormatter.string(from: NSNumber(value: price)) else {return "N/I"}
        
        return price
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
    
    func setupMapAnnotation(withTitle title: String, location: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = title
        return pin
    }
    
}
