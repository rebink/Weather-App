//
//  LottieHUD.swift
//  LottieHUD
//
//  Created by Ahmed Raad on 12/17/17.
//  Copyright © 2017 Ahmed Raad. All rights reserved.
//

import Foundation
import Lottie
import UIKit

public enum LottieHUDMaskType {
    case solid
}

public final class LottieHUD {
    
    public struct LottieHUDConfig {
        
        static var shadow: CGFloat = 0.7
        static var animationDuration: TimeInterval = 0.3
    }
    
    private var maskView: UIView!
    
    
    // Not implemeted yet :)
    //    public var blurMaskType: UIBlurEffect = UIBlurEffect(style: .dark)
    
    private var _lottie: LottieAnimationView!
    
    public var contentMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            self._lottie.contentMode = contentMode
        }
    }
    
    public var maskType: LottieHUDMaskType = .solid

    public var size: CGSize = CGSize(width: 200, height: 200)
    
    
    init(_ name: String, loop: Bool = true) {
        DispatchQueue.main.async {
            self._lottie = LottieAnimationView(name: name)
            self._lottie.loopMode = LottieLoopMode.loop
            let bg = UIView()
            bg.translatesAutoresizingMaskIntoConstraints = false
            bg.isUserInteractionEnabled = false
            bg.alpha = 0.0
            self.maskView = bg
        }
    }
    
    init(_ lottie: LottieAnimationView) {
        DispatchQueue.main.async {
                self._lottie = lottie
                let bg = UIView()
                bg.translatesAutoresizingMaskIntoConstraints = false
                bg.isUserInteractionEnabled = false
                bg.alpha = 0.0
                self.maskView = bg
            }
    }
    
    public func showHUD(with delay: TimeInterval = 0.0, loop: Bool = true) {
        _lottie.loopMode = LottieLoopMode.loop
        createHUD(delay: delay)
    }
    
    public func stopHUD() {
        clearHUD()
    }
    
    private func createHUD(delay: TimeInterval = 0.0) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.isUserInteractionEnabled = false
            self.configureMask()
            self.configureConstraints()
            UIView.animate(withDuration: LottieHUDConfig.animationDuration, delay: delay, options: .curveEaseIn, animations: {
                
                self.maskView.alpha = 1.0
            }, completion: nil)
            
            self._lottie.play(completion: { _ in
                self.clearHUD()
            })
        }
    }
    
    private func configureMask() {
        if maskType == .solid {
            maskView.backgroundColor = UIColor.black.withAlphaComponent(LottieHUDConfig.shadow)
        } else {
            // Not implemented yet
        }
    }
    
    private func configureConstraints() {
        // Configure Backround View Constraints
        self.keyWindow.view.addSubview(self.maskView)
        
        guard let keyWindowMargins = keyWindow.view else {return}
        
        maskView.leadingAnchor.constraint(equalTo: keyWindowMargins.leadingAnchor, constant: 0).isActive = true
        maskView.trailingAnchor.constraint(equalTo: keyWindowMargins.trailingAnchor, constant: 0).isActive = true
        maskView.topAnchor.constraint(equalTo: keyWindowMargins.topAnchor).isActive = true
        maskView.bottomAnchor.constraint(equalTo: keyWindowMargins.bottomAnchor).isActive = true
        
        maskView.addSubview(_lottie)

        // Configure Lottie Constraints
        _lottie.translatesAutoresizingMaskIntoConstraints = false
        _lottie.centerXAnchor.constraint(equalTo: maskView.centerXAnchor, constant: 0).isActive = true
        _lottie.centerYAnchor.constraint(equalTo: maskView.centerYAnchor, constant: 0).isActive = true
        _lottie.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        _lottie.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    private func clearHUD() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: LottieHUDConfig.animationDuration, delay: 0, options: .curveEaseIn, animations: {
                self.maskView.alpha = 0.0
            }) { finished in
                UIApplication.shared.keyWindow!.isUserInteractionEnabled = true
                self.maskView.removeFromSuperview()
                self._lottie.stop()
            }
        }
    }
    
    private var keyWindow: UIViewController {
        return AppUtils.shared.getTopVC()!
    }
    
}

