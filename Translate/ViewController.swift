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
    
    @IBOutlet weak var transLangPicker: UIPickerView!
    @IBOutlet weak var transLangPickerLabel: UILabel!
    
    @IBOutlet weak var initLangPicker: UIPickerView!
    @IBOutlet weak var initLangPickerLabel: UILabel!
    
    let transLangPickerData = ["English", "French", "Irish", "Turkish"]
    let initLangPickerData = ["English", "French", "Irish", "Turkish"]
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLangPicker.dataSource = self
        self.initLangPicker.delegate = self
        self.transLangPicker.dataSource = self
        self.transLangPicker.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(sender: AnyObject) {
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var transLang: String?
        var initLang: String?
        
        //language to be translated
        if initLangPickerLabel.text == "English"{
            initLang = "en"
        }
        else if initLangPickerLabel.text == "French" {
            initLang = "fr"
        }
        else if initLangPickerLabel.text == "Irish" {
            initLang = "ga"
        }
        else if initLangPickerLabel.text == "Turkish" {
            initLang = "tr"
        }
        else {
            initLang = nil
        }
        
        //translated language
        if transLangPickerLabel.text == "English"{
            transLang = "en"
        }
        else if transLangPickerLabel.text == "French" {
            transLang = "fr"
        }
        else if transLangPickerLabel.text == "Irish" {
            transLang = "ga"
        }
        else if transLangPickerLabel.text == "Turkish" {
            transLang = "tr"
        }
        else {
            transLang = nil
        }
        
        if transLang == nil {
            self.translatedText.text = "ERROR: Output language was set to nil"
        }
        
        let langStr = ("\(initLang!)|\(transLang!)").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
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
        if pickerView == initLangPicker {
            return initLangPickerData.count
        }
        else {
            return transLangPickerData.count
        }
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == initLangPicker {
            return initLangPickerData[row]
        }
        else {
            return transLangPickerData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == initLangPicker{
            initLangPickerLabel.text = initLangPickerData[row]
        }
        else {
            transLangPickerLabel.text = transLangPickerData[row]
        }
    }
}

