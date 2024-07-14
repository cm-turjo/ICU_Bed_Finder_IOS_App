//
//  ViewController.swift
//  api3
//
//  Created by Turjo-Mac on 11/27/23.
//

import UIKit

class WeatherController: UIViewController {
    
    var id:String = ""
    var location:String = ""
    
    @IBOutlet var imgvw: UIImageView!
    @IBOutlet var cloud: UILabel!
    @IBOutlet var winddir: UILabel!
    @IBOutlet var flike: UILabel!
    @IBOutlet var vlskm: UILabel!
    @IBOutlet var rain: UILabel!
    @IBOutlet var humidity: UILabel!
    
    @IBOutlet var wind: UILabel!
    @IBOutlet var temp: UILabel!
    
    @IBOutlet var country: UILabel!
    @IBOutlet var region: UILabel!
    @IBOutlet var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.text = location
        FetchData()
    }
    
    
    
    func FetchData() {
        // Get the user-inputted city name
        guard let cityName = cityTextField.text, !cityName.isEmpty else {
            //print("Please enter a city name.")
            DispatchQueue.main.async {
                   let alertController = UIAlertController(
                       title: "Error",
                       message: "Invalid city name. Please enter a valid city name. (eg: Khulna) ",
                       preferredStyle: .alert
                   )
                   
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(okAction)
                   
                   self.present(alertController, animated: true, completion: nil)
               }
            return
        }
        
        let apiKey = "YOUR API KEY"
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityName)&aqi=no"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error occurred while accessing the data with the URL")
                
                return
            }
            
            var fullWeatherData: WeatherData?
            
            do {
                fullWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    
                    self.region.text = "Region : \(fullWeatherData!.location.name)"
                    self.country.text = "Country : \(fullWeatherData!.location.country)"
                    self.temp.text = "Temperature (Celsius) : \(fullWeatherData!.current.temp_c)"
                    self.humidity.text = "Humidity: \(fullWeatherData!.current.humidity)"
                    self.wind.text = "Wind(Km/Hr) : \(fullWeatherData!.current.wind_kph)"
                    
                    self.cloud.text = "Cloud:  \(fullWeatherData!.current.cloud)"
                    self.winddir.text = "Wind Dir: \(fullWeatherData!.current.wind_dir)"
                    self.rain.text = "Rain(mm): \(fullWeatherData!.current.precip_mm)"
                    self.flike.text = "Feels: (.C): \(fullWeatherData!.current.feelslike_c)"
                    self.vlskm.text = "Vis_KM: \(fullWeatherData!.current.vis_km)"
                    
                    var feelslike: Float = Float(fullWeatherData!.current.feelslike_c)
                    var cloud : Float = Float(fullWeatherData!.current.cloud)
                    var rain : Float = Float(fullWeatherData!.current.precip_mm)
                    var wind : Float = Float(fullWeatherData!.current.wind_kph)
                    
                    
                    if(cloud >= 30.0)
                    {
                        self.imgvw.image = UIImage(named: "cloudy.png")
                    }
                    else if(feelslike >= 30.0 )
                    {
                        self.imgvw.image = UIImage(named: "hotweather.png")
                    }
                    else if(rain >= 0.5)
                    {
                        self.imgvw.image = UIImage(named: "rainy-day.png")
                    }
                    else if(feelslike >= 20.0 && feelslike < 30.0)
                    {
                        self.imgvw.image = UIImage(named: "sunny.png")
                    }
                    else if(feelslike < 15.0)
                    {
                        self.imgvw.image = UIImage(named: "cold.png")
                        
                    }
                    else if(wind >= 10.0)
                    {
                        self.imgvw.image = UIImage(named: "umbrella.png")
                    }
                    else if(wind > 10.0 && rain >= 0.5)
                    {
                        self.imgvw.image = UIImage(named: "people.png")
                    }
                    else
                    {
                        self.imgvw.image = UIImage(named: "hot.png")
                    }
                    
                }
                
            } catch {
                print("Error occurred while decoding JSON into Swift Object Structure \(error)")
                DispatchQueue.main.async {
                       let alertController = UIAlertController(
                           title: "Error",
                           message: "Invalid city name. Please enter a valid city name. (eg: Khulna) ",
                           preferredStyle: .alert
                       )
                       
                       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alertController.addAction(okAction)
                       
                       self.present(alertController, animated: true, completion: nil)
                   }
            }
            
            
        }
        dataTask.resume()
    }
    
    
    
    

    @IBAction func refreshbtn(_ sender: UIButton) {
        
        FetchData()
        
    }
    
    @IBAction func goToHome(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Home") as! HomeController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func backToDetails(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "details") as! DetailController
        vc.id = id
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

