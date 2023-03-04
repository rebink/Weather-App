//
//  StepOneViewController.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit

class StepOneViewController: UIViewController {
  
    var viewModel = StepOneViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.searchBar.delegate = self
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        self.searchBar.placeholder = "Please enter cities name (comma Separated)"
        self.searchBar.searchTextField.font = .systemFont(ofSize: 15)
        
        // Register the custom cell XIB file
        let nib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        weatherTableView.register(nib, forCellReuseIdentifier: "WeatherTableViewCell")
    }
}

extension StepOneViewController: UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getWeatherDetailsForCities(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension StepOneViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let data = viewModel.weatherData[indexPath.row]
        cell.weatherIcon.loadImage(with: AppUtils.shared.getWeatherIconUrlFromWeatherIconCode(code: data.weather?.first?.icon ?? ""))
        cell.temperature.attributedText = cell.getAttributedStringFor(title: "Temperature: ", value: "\(data.main?.temp_min ?? 0)°C - \(data.main?.temp_max ?? 0)°C")
        cell.weatherDescription.attributedText = cell.getAttributedStringFor(title: "Weather: ", value: "\(data.weather?.first?.description ?? "")")
        cell.windSpeed.attributedText = cell.getAttributedStringFor(title: "Wind Speed: ", value: "\(data.wind?.speed ?? 0)m/s")
        cell.city.text = data.name ?? ""
        cell.selectionStyle = .none
        return cell
    }
}

extension StepOneViewController: StepOneViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
}
