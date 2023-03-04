//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit

extension UIViewController {
    
    func pushViewControllerWithXib(_ viewController: UIViewController.Type) {
        let vc = viewController.init(nibName: String(describing: viewController), bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
