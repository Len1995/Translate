//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var translatedText: UITextField!
    
    @IBOutlet weak var transLangPicker: UIPickerView!
    @IBOutlet weak var initLangPicker: UIPickerView?
    
    @IBOutlet weak var initPickerTextField: UITextField!
    
    var transLangText: String?
    let transLangPickerData = ["English", "French", "Irish", "Turkish"]
    let initLangPickerData = ["English", "French", "Irish", "Turkish"]
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*self.initLangPicker.dataSource = self
        self.initLangPicker.delegate = self
        self.transLangPicker.dataSource = self
        self.transLangPicker.delegate = self
        */
        let initLangPicker = UIPickerView()
        initLangPicker.showsSelectionIndicator = true
        initLangPicker.delegate = self
        initLangPicker.dataSource = self
        initPickerTextField.inputView = initLangPicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        initPickerTextField.inputAccessoryView = toolBar
        
        // Dismiss Keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func donePressed(sender: UIBarButtonItem) {
        initPickerTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(sender: AnyObject) {
        let str = textToTranslate.text
        let escapedStr = str!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var transLang: String?
        var initLang: String?
        
        //language to be translated
        if initPickerTextField.text == "English" {
            initLang = "en"
        }
        else if initPickerTextField.text == "French" {
            initLang = "fr"
        }
        else if initPickerTextField.text == "Irish" {
            initLang = "ga"
        }
        else if initPickerTextField.text == "Turkish" {
            initLang = "tr"
        }
        else {
            initLang = nil
        }
        
        //translated language
        if transLangText == "English"{
            transLang = "en"
        }
        else if transLangText == "French" {
            transLang = "fr"
        }
        else if transLangText == "Irish" {
            transLang = "ga"
        }
        else if transLangText == "Turkish" {
            transLang = "tr"
        }
        else {
            transLang = nil
        }
        
        if initLang == nil {
            self.translatedText.text = "ERROR: Input language was set to nil"
        }
        
        if transLang == nil {
            self.translatedText.text = "ERROR: Output language was set to nil"
        }
        
        if initLang == transLang {
            self.translatedText.text = "Cannot translate from itself to itself"
            return
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
        if pickerView == initLangPicker {
            initPickerTextField.text = initLangPickerData[row]
        }
        else {
            transLangText = transLangPickerData[row]
        }
    }
}

