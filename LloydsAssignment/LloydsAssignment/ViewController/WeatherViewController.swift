//
//  ViewController.swift
//  LloydsAssignment
//
//  Created by Amit Aman on 22/05/22.
//

import UIKit



class WeatherViewController: UIViewController {
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet private var placeLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var conditionLabel: UILabel!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let errorColor = UIColor(red: 0.96, green: 0.667, blue: 0.690, alpha: 1)
    let weatherViewModel = WeatherViewModel()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.weatherInfoDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating()
    }
    
    // MARK: - Methods
    
    private func updateUI(with weatherInfo: WeatherInfo) {
        self.tempLabel.text = weatherViewModel.convertTemperatureFormate(weatherInfo: weatherInfo)
        self.placeLabel.text = weatherViewModel.getPlaceName(weatherInfo: weatherInfo)
        self.conditionLabel.text = weatherViewModel.getCondition(weatherInfo: weatherInfo)
        self.conditionLabel.textColor = UIColor.black
    }
    
    private func updateUiwithError(error: NSError) {
        self.tempLabel.text = "--"
        self.placeLabel.text = "--"
        self.conditionLabel.text = error.localizedDescription
        self.conditionLabel.textColor = self.errorColor
    }
    
    func stopAnimating() {
        self.activityIndecator.isHidden = true
        activityIndecator.stopAnimating()
    }
    
    func startAnimating() {
        self.activityIndecator.isHidden = false
        activityIndecator.startAnimating()
    }
    
}


// MARK: - Class Extension - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return false }
        weatherViewModel.searchLocationWith(location: text)
        return true
    }
}


//MARK: - WeatherInfo Data Delegate.
extension WeatherViewController: WeatherInfoDelegate {
    func didReceivedWeatherInfo(weatherInfo: WeatherInfo) {
        stopAnimating()
        self.updateUI(with: weatherInfo)
    }
    
    func didCallDonePromise(icon: UIImage) {
        self.iconImageView.image = icon
    }
    
    func didFailedWeatherInfoWith(error: NSError) {
        stopAnimating()
        updateUiwithError(error: error)
    }
}
