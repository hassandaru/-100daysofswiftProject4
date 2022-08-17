//
//  ViewController.swift
//  Project4
//
//  Created by Hassan Sohail Dar on 16/8/2022.
//

import UIKit
struct websites {
    static var list = ["apple.com", "hackingwithswift.com", "youtube.com", "facebook.com"]
    static var blockedList = "facebook.com"
}
class ViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites.list[indexPath.row]
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailWebView") as? DetailWebViewController {
            // 2: success! Set its selectedImage property
            vc.urlValue = websites.list[indexPath.row]
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

