//
//  ViewController.swift
//  AFNetworkingCarthage
//
//  Created by Deepak Surti on 12/17/16.
//  Copyright © 2016 Ison Apps. All rights reserved.
//

import UIKit
import LTMorphingLabel
//import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var forecastLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.forecastLabel.text = ""
        
        //instantiate a gray Activity Indicator View
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //add the activity to the ViewController's view
        view.addSubview(activityIndicatorView)
        //position the Activity Indicator View in the center of the view
        activityIndicatorView.center = view.center
        //tell the Activity Indicator View to begin animating
        activityIndicatorView.startAnimating()
        

        let manager = AFHTTPSessionManager()
        
        manager.get("http://api.openweathermap.org/data/2.5/forecast/daily?q=Peoria&mode=json&units=metric&cnt=1&appid=bd782bc031aaf7ad058d79be007f41e0",
                    parameters: nil,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        let json = JSON(responseObject)
                        if let forecast = json["list"][0]["weather"][0]["description"].string {
                            self.forecastLabel.morphingEffect = .burn
                            self.forecastLabel.text = forecast
                        }
                        activityIndicatorView.removeFromSuperview()
                        
                        if let localTemp = json["list"][0]["temp"]["max"].double {
                            print("\(localTemp)")
                            //
                            let fLocalTemp = localTemp * 9 / 5 + 32
                            print("\(fLocalTemp)")
                            if fLocalTemp > 80 {
                                self.forecastLabel.textColor = UIColor.red
                            } else if fLocalTemp < 20 {
                                self.forecastLabel.textColor = UIColor.blue
                            } else {
                                self.forecastLabel.textColor = UIColor.black
                            }
                        }
                        
                        
                        /* WITHOUT SWIFTY JSON
                        if let responseObject = responseObject {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let listOfDays = (responseObject as AnyObject)["list"] as? [AnyObject] {
                                if let tomorrow = listOfDays[0] as? [String:AnyObject] {
                                    if let tomorrowsWeather = tomorrow["weather"] as? [AnyObject] {
                                        if let firstWeatherOfDay = tomorrowsWeather[0] as? [String:AnyObject] {
                                            if let forecast = firstWeatherOfDay["description"] as? String {
                                                self.forecastLabel.text = forecast
                                            }
                                        }
                                    }
                                }
                            }
                        }*/
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
            if error.localizedDescription == "The Internet connection appears to be offline." {
                activityIndicatorView.removeFromSuperview()
                self.forecastLabel.text = "No Internet Connection"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

