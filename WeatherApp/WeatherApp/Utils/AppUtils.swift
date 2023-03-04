//
//  AppUtils.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import Foundation
import SwiftMessages
import UIKit

struct AppUtils {
    static let shared = AppUtils()
    private init() {}
    let hud: LottieHUD = LottieHUD("weather-icon")
    
    func showHUD(){
        DispatchQueue.main.async {
            hud.showHUD()
        }
    }
    
    func hideHUD(){
        DispatchQueue.main.async {
            hud.stopHUD()
        }
    }
    
    internal static func showErrorSnackbar(withTitle: String? = "", message: String) {
        DispatchQueue.main.async {
            let error = MessageView.viewFromNib(layout: .messageView)
            error.configureTheme(.error)
            error.configureContent(title: withTitle!, body: message)
            error.button?.isHidden = true
            error.configureDropShadow()
            SwiftMessages.show(view: error)
        }
    }
    
    internal static func showSuccessSnackbar(withTitle: String? = "", message: String) {
        DispatchQueue.main.async {
            let navigationController = AppUtils.shared.getTopVC() as? UINavigationController
            let success = MessageView.viewFromNib(layout: .messageView)
            success.configureTheme(.success)
            success.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.5803921569, blue: 0.2666666667, alpha: 1)
            success.configureContent(title: withTitle!, body: message)
            success.configureDropShadow()
            success.button?.isHidden = true
            SwiftMessages.show(view: success)
        }
    }
    
    func getTopVC() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
            // topController should now be your topmost view controller
        }
        return nil
    }
    
    func getWeatherIconUrlFromWeatherIconCode(code: String) -> String {
        return "https://openweathermap.org/img/wn/\(code)@2x.png"
    }
}
