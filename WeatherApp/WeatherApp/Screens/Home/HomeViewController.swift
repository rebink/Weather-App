//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func onTapStep1Button(_ sender: Any) {
        let vc = getViewControllerWithXib(StepOneViewController.self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTapStep2Button(_ sender: Any) {
        let vc = getViewControllerWithXib(StepTwoViewController.self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
