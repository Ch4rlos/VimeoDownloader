//
//  ViewController.swift
//  VimeoDownloader
//
//  Created by Developer on 4/4/19.
//  Copyright © 2019 Multinf S.A. de C.V. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var idVimeo: String? = nil
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var idTextBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func downloadVimeo(_ sender: Any) {
        idVimeo = nil
        idVimeo = idTextBar.text
        parseVimeoJason()
    }
    
    
    func parseVimeoJason(){
        guard let url = URL(string: "https://player.vimeo.com/video/\(idVimeo!)/config") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
                //print(type(of: json))
                if let video = json["video"] as? [String:AnyObject]{
                    if let title = video["title"] as? String{
                        print(title)
                        if let routes = json["request"] as? [String:AnyObject]{
                            //print(type(of: routes))
                            if let legs = routes["files"] as? [String:AnyObject]{
                                //print(type(of: legs))
                                if let steps = legs["progressive"] as? [[String:AnyObject]]{
                                    //print(type(of: legs))
                                    if let vimeoURL = steps[0]["url"] as? String{
                                        print(vimeoURL)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
