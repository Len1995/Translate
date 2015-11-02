//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerLabel: UILabel!
    
    
    let pickerData = ["French", "Irish", "Turkish"]
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.dataSource = self
        self.picker.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(sender: AnyObject) {
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var transLang: String?
        
        if pickerLabel.text == "French" {
            transLang = "fr"
        }
        else if pickerLabel.text == "Irish" {
            transLang = "ga"
        }
        else if pickerLabel.text == "Turkish" {
            transLang = "tr"
        }
        else {
            transLang = nil
        }
        
        if transLang == nil {
            self.translatedText.text = "ERROR: Output language was set to nil"
        }
        
        let langStr = ("en|\(transLang!)").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = NSURL(string: urlStr)
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
            indicator.stopAnimating()
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                        result = responseData.objectForKey("translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLabel.text = pickerData[row]
    }
}

