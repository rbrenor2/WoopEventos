//
//  Utilities.swift
//  WoopEventos
//
//  Created by Breno Ramos on 22/12/21.
//

import UIKit
import Lottie

class Utilities {
    func infoStack(withTitle titleLabel: UILabel, views: [UIView], direction: NSLayoutConstraint.Axis) -> UIStackView {
        let stackedViews = [titleLabel] + views
        let stack = UIStackView(arrangedSubviews: stackedViews)
        stack.axis = direction
        stack.spacing = 4
        
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
            loadingView.anchor(width: view.frame.width - 100, height: view.frame.height/3)
            loadingView.center(inView: view)
            loadingView.backgroundColor = .white
            loadingView.play(completion: nil)
        } else {
            loadingView.stop()
            loadingView.removeFromSuperview()
        }
    }
}
