//
//  ViewController.swift
//  Project7
//
//  Created by Jakov Juric on 08/11/2018.
//  Copyright © 2018 Jakov Juric. All rights reserved.
//
import UIKit

enum Url: String {
    case first = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    case second = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
}

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    func getUrl(_ tag: Int?) -> String {
        guard tag != nil else { return Url.first.rawValue }
        if tag == 1 {
            return Url.second.rawValue
        }
        return Url.first.rawValue
        
    }
    @objc func fetchJSON() {
        let tag = navigationController?.tabBarItem.tag
        let urlString = getUrl(tag)
        
        guard
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) else {
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
                return
        }
        parse(json: data)

    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    @objc func showError() {
            let ac = UIAlertController(title: "Loading failed", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

