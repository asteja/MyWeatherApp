//
//  MasterViewController.swift
//  WeatherApp
//
//  Created by Saiteja Alle on 8/17/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewController: UITableViewController {

    var weatherDataArray = [NSManagedObject]()
    private let weatherModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather"
        let addButton = UIBarButtonItem(title: "Add zipcode", style: .done, target: self, action: #selector(addZipCode(_:)))
        navigationItem.rightBarButtonItem = addButton

        weatherModel.weatherData.bind { [weak self] weatherData in
            DispatchQueue.main.async {
                guard let weatherData = weatherData, let weakSelf = self else {
                    return
                }
                weakSelf.weatherDataArray = weatherData
                weakSelf.tableView.reloadData()
            }
        }
        
        weatherModel.error.bind { [weak self] error in
            guard let error = error else {
                return
            }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert", message: error.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        weatherModel.fetchData()
    }

    @objc func addZipCode(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Zipcode", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] (action) in
            guard let weakSelf = self, let zipCode = alert.textFields?.first?.text else {
                return
            }
            weakSelf.weatherModel.getBriefWeatherDetails(for: zipCode)
        })
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter text"
            textField.keyboardType = .numberPad
            textField.delegate = self
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension WeatherViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let weatherData = weatherDataArray[indexPath.row]
        if let city = weatherData.value(forKey: "city") as? String, let temp = weatherData.value(forKey: "temp") as? Double {
            let cityLabel = cell.viewWithTag(1) as? UILabel
            cityLabel?.text = city
            cityLabel?.numberOfLines = 0
            cityLabel?.adjustsFontSizeToFitWidth = true
            let measurement = Measurement(value: temp, unit: UnitTemperature.fahrenheit)
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.unitStyle = .medium
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
            measurementFormatter.unitOptions = .naturalScale
            let tempLabel = cell.viewWithTag(2) as? UILabel
            tempLabel?.text = measurementFormatter.string(from: measurement)
        }
        return cell
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, text.count < 5 {
            return true
        }
        return false
    }
    
}
