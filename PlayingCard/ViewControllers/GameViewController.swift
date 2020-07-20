//
//  ViewController.swift
//  PlayingCard
//
//  Created by Andrey Dolgov on 08/07/2019.
//  Copyright © 2019 rodzaevsky. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private var points = 0 {
        didSet {
            navigationItem.title = "Очков: \(points)"
        }
    }
    
    private var additionalPoints = 20 {
        didSet {
            if additionalPoints < 0 {
                additionalPoints = 0
            }
        }
    }
    
    private var deck = PlayingCardDeck()
    
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Очков: \(points)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.additionalPoints -= 5
        }
        
        edgesForExtendedLayout = []
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Очков: \(points)"
        navigationController?.navigationBar.topItem?.title = "Назад"
        navigationController?.navigationBar.tintColor = .black
        
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch {
                            self.points += (10 + self.additionalPoints)
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                            },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardsToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                    },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                                self.checkIfGameOver()
                                            }
                                    }
                                    )
                            }
                            )
                            
                        } else if cardsToAnimate.count == 2 {
                            if chosenCardView == self.lastChosenCardView {
                                if chosenCardView.isChosen,
                                    let isChosen = self.lastChosenCardView?.isChosen,
                                    isChosen {
                                    self.points -= 5
                                }
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            cardView.isFaceUp = false
                                    },
                                        completion: { finished in
                                            self.cardBehavior.addItem(cardView)
                                    }
                                    )
                                }
                                chosenCardView.isChosen = true
                                self.lastChosenCardView?.isChosen = true
                            }
                        } else {
                            if !chosenCardView.isFaceUp {
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                }
                )
            }
        default:
            break
        }
    }
    
    private func checkIfGameOver() {
        var isGameOver = true
        for card in cardViews {
            if !card.isHidden {
                isGameOver = false
                break
            }
        }
        if isGameOver {
            showResults()
        }
    }
    
    private func showResults() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoreViewController = storyboard.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
        scoreViewController.modalPresentationStyle = .fullScreen
        scoreViewController.score = points
        navigationController?.pushViewController(scoreViewController, animated: true)
    }
    
    
}
