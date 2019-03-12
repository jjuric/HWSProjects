//
//  DetailViewController.swift
//  Project1
//
//  Created by Jakov Juric on 04/07/2018.
//  Copyright © 2018 Jakov Juric. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Onemogući large title (trebao bi samo početni ekran bit large)
        navigationItem.largeTitleDisplayMode = .never
        title = selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
       
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem //odreduje gdje ce AVC bit anchored, odakle ce se pojavit
        present(vc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hide home button on iPhoneX when the bar is also hidden
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return navigationController?.hidesBarsOnTap ?? false
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
