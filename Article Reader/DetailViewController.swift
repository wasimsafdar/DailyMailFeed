//
//  DetailViewController.swift
//  Article Reader
//
//  Created by Eng Waseem on 06/10/2017.
//  Copyright © 2017 Humma Embedded Consultancy and Development. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkBtn: UIImageView!
    
    var time: Bool!
    var timer: Timer!
    var clicked: Bool!
    var userDefaults: UserDefaults!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        //Initialization
        userDefaults = UserDefaults.standard
        details.text = articleDescription
        webView.delegate = self
        progressBar.progress = 0.0
        
        //Load selected article in webview
        webView.loadRequest(URLRequest(url: URL(string: articleLink)!))
        
        // Check if user mark the article
        let checkValue = userDefaults.bool(forKey: articleTitle)
        
        if checkValue {
            imageView.image = UIImage(named: "Checked Checkbox-32.png")
            clicked = true
        }
        else{
            imageView.image = UIImage(named: "Unchecked Checkbox-32.png")
            clicked = false
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //Timer function for progress bar
    func timerCallBack() {
        
        if time != nil {
            if progressBar.progress >= 1 {
                progressBar.isHidden = true
            }else{
                progressBar.progress += 0.1
            }
        }else{
            progressBar.progress += 0.01
            if progressBar.progress >= 0.95{
                progressBar.progress = 0.95
            }
        }
    }

    @IBAction func checkBtnClicked(_ sender: Any) {
        
        if clicked == false {
            
            imageView.image = UIImage(named: "Checked Checkbox-32.png")
            clicked = true
            userDefaults.set(true, forKey: articleTitle)
            
        }else{
            imageView.image = UIImage(named: "Unchecked Checkbox-32.png")
            clicked = false
            userDefaults.set(false, forKey: articleTitle)

        }
        userDefaults.synchronize()
    }
    
    
    // MARK: -WebView Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        progressBar.progress = 0.0
        time = false
        clicked = false
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(DetailViewController.timerCallBack), userInfo: nil, repeats: true)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        time = true
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
