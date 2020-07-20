//
//  RulesViewController.swift
//  PlayingCard
//
//  Created by Рыжков Артем on 20.07.2020.
//  Copyright © 2020 rodzaevsky. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backToMenu(_ sender: UIButton) {
        ViewAnimations.zoomInOut(on: sender) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
