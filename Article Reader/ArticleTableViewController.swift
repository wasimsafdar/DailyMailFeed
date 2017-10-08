//
//  ArticleTableViewController.swift
//  Article Reader
//
//  Created by Eng Waseem on 04/10/2017.
//  Copyright © 2017 Humma Embedded Consultancy and Development. All rights reserved.
//

import UIKit

var articleTitle :String = ""
var articleDescription :String = ""
var articleLink :String = ""

class ArticleTableViewController: UITableViewController {
    
    private var xmlItems: [XMLItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retreive parsed data from RSS feed.
        retreiveData()
    
    }
    
    private func retreiveData()
    {
        let rssXmlParser = RSSXMLParser()
        rssXmlParser.parseXmlData(url: "http://www.dailymail.co.uk/sport/index.rss"){
            (xmlItems) in self.xmlItems = xmlItems
            OperationQueue.main.addOperation {
                
                self.tableView.reloadSections(IndexSet(integer:0), with:.left)

            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let xmlItems = xmlItems else {
            
            return 0
        }
        
        return xmlItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article Cell", for: indexPath) as! RSSReaderCell
        if let item = xmlItems?[indexPath.item]{
        
            cell.item = item 
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
 
    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = xmlItems?[indexPath.item]{
            
            articleTitle = item.title
            articleDescription = item.description
            articleLink = item.link
            
            performSegue(withIdentifier: "DetailView", sender: nil)

        }
        
    }
    
    //Erase an article from Table view
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let erase = UITableViewRowAction(style: .normal, title: "Erase") { action, index in
            
            self.xmlItems?.remove(at: index.row)
            
            OperationQueue.main.addOperation {
                
                self.tableView.reloadSections(IndexSet(integer:0), with:.left)
                
            }

        }
        // Set backgroud colour
        erase.backgroundColor = UIColor(red
            :102/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
        
        return [erase]
    }
 
}
