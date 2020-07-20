//
//  MenuViewController.swift
//  PlayingCard
//
//  Created by Рыжков Артем on 19.07.2020.
//  Copyright © 2020 rodzaevsky. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameViewController.modalPresentationStyle = .fullScreen
        ViewAnimations.zoomInOut(on: sender) { _ in
            self.navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
}
