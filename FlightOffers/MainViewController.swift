//
//  MainViewController.swift
//  FlightOffers
//
//  Created by Kris Flajs on 10.09.19.
//  Copyright © 2019 eRazred. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let ApiURL : String = "https://api.skypicker.com/flights"
    let partnerID : String = "krisflajsflightoffers"
    var slides:[Slide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        getDataFromApi()
    }
    
    func getDataFromApi() {
//        gets data from the api
        let params : Parameters = [
            "partner": partnerID,
            "v": 2,
            "sort": "popularity",
            "limit": 5,
            "asc": 0,
            "locale": "en",
            "flyFrom": "FRA",
            "to": "anywhere",
            "adults": 1,
            "infants": 0,
            "children": 0,
            "featureName": "aggregateResults",
            "one_per_date": 0,
            "oneforcity": 1,
            "wait_for_refresh": 0,
            "typeFlight": "oneway",
//            "dateFrom": setDates().dateFrom,
//            "dateTo": setDates().dateTo
            "dateFrom": "13/09/2019",
            "dateTo": "14/09/2019"
        ]
        Alamofire.request(ApiURL, method: .get, parameters: params).responseJSON(completionHandler: { response in
            
            if response.result.isSuccess {
                let json = response.result.value!
                self.processResponse(res: JSON(json))
            }
            else {
                print(response.error!)
            }
            
            print(JSON(response.result.value!))
        })
    }
    
    func processResponse(res: JSON) {
        
        var departure: String = ""
        var depDate: String = ""
        var depTime: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy at HH:mm"
        
        
        for i in 0..<res["data"].count {
            print("Flying from \(res["data"][i]["cityFrom"].string!) to \(res["data"][i]["cityTo"].string!)")
            
            let dTime = Date(timeIntervalSince1970: TimeInterval(res["data"][i]["dTime"].int!))
            
            formatter.dateFormat = "dd/MM/yyyy"
            depDate = formatter.string(from: dTime)
            formatter.dateFormat = "HH:mm"
            depTime = formatter.string(from: dTime)
            
            departure = "\(depDate) at \(depTime)"
            
            slides.append(createSlide(from: res["data"][i]["cityFrom"].string!, to: res["data"][i]["cityTo"].string!, price: res["data"][i]["price"].int!, departure: departure, cityId: res["data"][i]["mapIdto"].string!))
            
        }
        
        setupScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        
    }
    
//    func requestToServer(params: Parameters, completion: @escaping (Bool, String) -> Void) {
//
//        Alamofire.request(LOGIN_REQUEST_URL, method: .post, parameters: params).responseJSON { response in
//
//            if response.result.isSuccess {
//
//                let json = response.result.value!
//
//                self.responseHead = self.processResponse(response: JSON(json))
//
//                completion(true, self.responseHead)
//
//            }
//            else {
//                completion(false, self.responseHead)
//            }
//        }
//
//
//
//    }
//
//    func processResponse(response: JSON) -> String {
//
//        let responseHead : String = response["responseHead"].string!
//
//        switch responseHead {
//        case "suc":
//            let userID = response["user_id"].string!
//            let userRazred = response["user_razred"].string!
//            let userDostop = response["user_dostop"].string!
//
//            updateUserPlist(user_id: Int(userID)!, user_razred: Int(userRazred)!, user_dostop: Int(userDostop)!)
//
//        default:
//            print("Response head parsed over: \(responseHead)")
//        }
//
//        return responseHead
//
//    }

    func createSlide(from: String,to: String,price: Int,departure: String,cityId: String) -> (Slide) {
        let slide : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        
        slide.lFrom.text = "Flying from \(from) to"
        slide.lTo.text = to
        slide.lPrice.text = "\(price) €"
        slide.lDeparture.text = "departing \(departure)"
        
        slide.cityImage.load(url: URL(string: "https://images.kiwi.com/photos/472x640/\(cityId).jpg")!)
        
        return slide
    }
    
    func setupScrollView(slides:[Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func setDates() -> (dateFrom: String,dateTo: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateFrom = formatter.string(from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day)
        
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        let dateTo = formatter.string(from: tomorrow!)
        
        return (dateFrom,dateTo)
    }
}
