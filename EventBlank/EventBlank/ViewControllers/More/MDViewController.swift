//
//  MDViewController.swift
//  EventBlank
//
//  Created by Marin Todorov on 6/24/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import UIKit
import SQLite
import CocoaMarkdown

class MDViewController: UIViewController, UIWebViewDelegate {
    
    var textRow: Row! //set from previous view controller
    
    @IBOutlet weak var webView: UIWebView!
    
    let database: Database = {
        DatabaseProvider.databases[eventDataFileName]!
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = textRow[Text.title]
        
        //convert markdown to html
        let document = CMDocument(
            data: textRow[Text.content]!.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: true))
        let renderer = CMHTMLRenderer(document: document, options: nil)
        let markdownHtml = renderer.render()
        
        //load event data
        let event = database[EventConfig.tableName].first!
        
//        println("main: \(event[Event.mainColor])")
//        println("sec: \(event[Event.secondaryColor])")
//        println("bg: \(event[Event.ternaryColor])")
        
        //build template
        let template = NSString(
            contentsOfFile: NSBundle.mainBundle().pathForResource("markdown", ofType: "html")!,
            encoding: NSUTF8StringEncoding,
            error: nil)!
        var fullPage = template.stringByReplacingOccurrencesOfString("%markdown%", withString: markdownHtml)
        fullPage = fullPage.stringByReplacingOccurrencesOfString("%headingColor%", withString: event[Event.mainColor])
        let linkColor = UIColor(hexString: event[Event.mainColor])
        fullPage = fullPage.stringByReplacingOccurrencesOfString("%linkColor%", withString: linkColor.toHexString())
        
        //load html in webview
        let resourcesURL = NSBundle.mainBundle().resourceURL!
        webView.loadHTMLString(fullPage, baseURL: resourcesURL)
        println(fullPage)
    }
    
    //MARK: - web view methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == UIWebViewNavigationType.LinkClicked {
            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            webVC.initialURL = request.URL
            self.navigationController!.pushViewController(webVC, animated: true)
            return false
        }
        
        return true
    }

}