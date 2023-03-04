//
//  StepTwoViewController.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit

class StepTwoViewController: UIViewController {

    let viewModel = StepTwoViewModel()
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.viewModel.getCurrentLocation()
        self.forecastTableView.delegate = self
        self.forecastTableView.dataSource = self
        self.forecastTableView.tableHeaderView = nil
        
        // Register the custom cell XIB file
        let nib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        self.forecastTableView.register(nib, forCellReuseIdentifier: "WeatherTableViewCell")

    }
}


extension StepTwoViewController: StepTwoViewModelDelegate {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.forecastTableView.reloadData()
            self.title = self.viewModel.cityName
        }
    }
}

extension StepTwoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.weatherData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weatherData[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.layer.cornerRadius = 5
        headerView.layer.masksToBounds = true
        headerView.backgroundColor = UIColor.darkGray
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width - 30, height: headerView.frame.height))
        headerLabel.textAlignment = .center
        headerLabel.textColor = .white
        headerLabel.font = .systemFont(ofSize: 15, weight: .bold)
        let date = viewModel.weatherData[section].first?.date ?? Date() // The current date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd- MM -yyyy" // Set the date formatter to display the time in "hour:minute AM/PM" format
        let timeString = dateFormatter.string(from: date)
        headerLabel.text = timeString
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let data = viewModel.weatherData[indexPath.section][indexPath.row]
        cell.weatherIcon.loadImage(with: AppUtils.shared.getWeatherIconUrlFromWeatherIconCode(code: data.weather?.first?.icon ?? ""))
        cell.temperature.attributedText = cell.getAttributedStringFor(title: "Temperature: ", value: "\(data.main?.temp_min ?? 0)°C - \(data.main?.temp_max ?? 0)°C")
        cell.weatherDescription.attributedText = cell.getAttributedStringFor(title: "Weather: ", value: "\(data.weather?.first?.description ?? "")")
        cell.windSpeed.attributedText = cell.getAttributedStringFor(title: "Wind Speed: ", value: "\(data.wind?.speed ?? 0)m/s")
        let date = data.date // The current date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // Set the date formatter to display the time in "hour:minute AM/PM" format
        let timeString = dateFormatter.string(from: date) // Convert the date to a string in the specified format
        cell.city.text = timeString
        cell.selectionStyle = .none
        return cell
    }
}
