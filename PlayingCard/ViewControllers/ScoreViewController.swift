//
//  ScoreViewController.swift
//  PlayingCard
//
//  Created by Рыжков Артем on 20.07.2020.
//  Copyright © 2020 rodzaevsky. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    struct defaultsKeys {
        static let bestScore = "bestScoreKey"
    }
    
    @IBOutlet weak var scoreBeatenLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var score: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Набрано очков: \(score)"
        if let savedScore = getRecordScore(),
            savedScore > score {
            recordLabel.text = "Рекорд: \(savedScore)"
        } else {
            scoreBeatenLabel.isHidden = false
            recordLabel.text = "Рекорд: \(score)"
            saveRecordScore(score: score)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func retryTapped(_ sender: UIButton) {
        ViewAnimations.zoomInOut(on: sender) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func getRecordScore() -> Int? {
        let defaults = UserDefaults.standard
        let scoreString = defaults.object(forKey: defaultsKeys.bestScore) as? Int
        return scoreString
    }
    
    private func saveRecordScore(score: Int) {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: defaultsKeys.bestScore)
    }
}
