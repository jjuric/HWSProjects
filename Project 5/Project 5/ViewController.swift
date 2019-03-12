//
//  ViewController.swift
//  Project 5
//
//  Created by Jakov Juric on 18/10/2018.
//  Copyright © 2018 Jakov Juric. All rights reserved.
//
import GameplayKit
import UIKit

class ViewController: UITableViewController {
    //MARK: Properties
    var allWords = [String]()
    var usedWords = [String]()
    var gameCounter = 0
    var correctWords = 0
    var score = 0
    @IBOutlet weak var scoreLabel: UILabel!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            } else {
                loadDefaultWords()
            }
        } else {
            loadDefaultWords()
        }
        startGame()
    }
    //TableView settings
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    //Submit answers button and method
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(answer: String){
        let lowerAnswer = answer.lowercased()
        let errorTitle : String
        let errorMessage : String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    correctWords += 1
                    score += 1
                    scoreLabel.text = "Score: \(score)"
                    if correctWords > 3 {
                        startGame()
                    }
                    
                    return
                } else {
                    errorTitle = "Word not recognized or too short"
                    errorMessage = "You can't just make up words"
                    showErrorMessage(title: errorTitle, message: errorMessage)
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original!"
                showErrorMessage(title: errorTitle, message: errorMessage)
            }
        } else {
            errorTitle = "Word not possible!"
            errorMessage = "You can't spell that word from \(title!.lowercased())"
            showErrorMessage(title: errorTitle, message: errorMessage)
        }
    }
    //Game setup and restart
    @objc func restartGame() {
        gameCounter = 0
        score = 0
        scoreLabel.text = "Score: \(score)"
        startGame()
    }
    func startGame() {
        if gameCounter == 0 {
            allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
            usedWords.removeAll(keepingCapacity: true)
            tableView.reloadData()
        }
        title = allWords[gameCounter]
        gameCounter += 1
        correctWords = 0
    }
    //Testing submitted answers and error handling
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    func isOriginal(word: String) -> Bool {
        guard word != title else {
            return false
        }
        return !usedWords.contains(word)
    }
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledWordRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledWordRange.location == NSNotFound && word.utf16.count >= 3
    }
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func loadDefaultWords() {
        allWords = ["something ain't right"]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

