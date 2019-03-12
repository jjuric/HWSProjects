//
//  ViewController.swift
//  Project1
//
//  Created by Jakov Juric on 04/07/2018.
//  Copyright © 2018 Jakov Juric. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //MARK: Properties
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Allow large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Storm Viewer"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
    }
    
    //Broj redova u tablici
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    //izgled pojedinih ćelija u indexPath-u(sadrži sectionXrow)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    //When someone touched a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Try to load "detail" view controller layout from the storyboard, i moramo naglasiti da ga promatra DetailViewController kako bi manipulirali fileovima unutar njega(npr.selectedImage)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            //Set his selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            //Push into navigation controller - on omogućuje prikaz ekrana, mislim da ga šalje u stack od nC-a da se ekrani stackaju kad ih otvaramo (back strelica)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

