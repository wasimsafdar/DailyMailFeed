//
//  RSSXMLParser.swift
//  Article Reader
//
//  Created by Eng Waseem on 03/10/2017.
//  Copyright © 2017 Humma Embedded Consultancy and Development. All rights reserved.
//

import UIKit

struct XMLItem {
    
    var title: String //Article title
    var description: String //Article description
    var pubDate: String //Article publication date
    var link: String //Url of related news
}

/*
1. Download xml data from web server
2. Parse XML data to stuct objects
3.
*/
class RSSXMLParser: NSObject, XMLParserDelegate {
    
    //Initialization
    
    var xmlItems : [XMLItem] = [] //Creating Items array
    
    var currentElement: String = ""
    
    //XML Parser Completion Handler for RSS Feed
    var parserCompletionHandler: (([XMLItem])->Void)?
    
    var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var articleDescription: String = "" {
        didSet {
            articleDescription = articleDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var articlePubDate: String = "" {
        didSet {
            articlePubDate = articlePubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var articleLink: String = "" {
        didSet {
            articleLink = articleLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseXmlData (url: String, completionHandler: ((([XMLItem])->Void)?)){
        
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) {(data,response,error ) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            //Parse our xml Data
            let parser = XMLParser(data:data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    //MARK: - XML Parser Delegate
    
    // Start parsing
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item" {
            
            currentTitle = ""
            articleDescription = ""
            articlePubDate = ""
            articleLink = ""
        }
    }

    // Find characters while parsing
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            articleDescription += string
        case "pubDate":
            articlePubDate += string
        case "link":
            articleLink += string
        default:
            break
        }
    }
    
    //End parsing
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let xmlItem = XMLItem (title: currentTitle ,description: articleDescription, pubDate:articlePubDate,link:articleLink)
            self.xmlItems.append(xmlItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        parserCompletionHandler?(xmlItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
}














