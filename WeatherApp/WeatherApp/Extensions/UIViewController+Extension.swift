//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit

extension UIViewController {
    
    func getViewControllerWithXib<T:UIViewController>(_ viewController: T.Type) -> T{
        let vc = viewController.init(nibName: String(describing: T.self), bundle: nil)
        return vc
    }
}
