//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 10
        baseView.layer.masksToBounds = true
        baseView.layer.borderColor = UIColor.lightGray.cgColor
        baseView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getAttributedStringFor(title: String, value: String) -> NSMutableAttributedString{
        let titleAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)]
        let titleString = NSMutableAttributedString(string: title, attributes: titleAttribute)
        
        let valueAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let valueString = NSAttributedString(string: value, attributes: valueAttribute)
        titleString.append(valueString)
        return titleString
    }
}
