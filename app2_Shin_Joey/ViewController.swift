//
//  ViewController.swift
//  app2_Shin_Joey
//
//  Created by Joey Shin on 2/6/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audio : AVAudioPlayer?
    let hapticEngine = UIImpactFeedbackGenerator()
    @IBOutlet var titleText : UILabel!
    @IBOutlet var playerOne : UILabel!
    @IBOutlet var playerTwo : UILabel!
    @IBOutlet var gameStatus : UILabel!
    var playerOneScore = 0
    var playerTwoScore = 0
    
    

    @IBOutlet var buttons: [UIButton]!
    var buttonStates = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    let winning = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [2, 4, 6], [0, 4, 8]]
    
    var firstPlayer = true
    var gameOngoing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerOneScore = 0
        playerTwoScore = 0
        titleText.text = "Tic Tac Toe"
        playerOne.text = "P1 Score: " + String(playerOneScore)
        playerTwo.text = "P2 Score: " + String(playerTwoScore)
        gameStatus.text = "first player's turn"
        buttonStates = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        // 0 is unpressed, 1 is x, 2 is o
        if (buttonStates[sender.tag - 1] == 0 && gameOngoing) {
            hapticEngine.impactOccurred()
            if firstPlayer {
                sender.setImage(UIImage.init(named: "mark-x"), for: .normal)
                gameStatus.text = "second player's turn"
                firstPlayer = false
                buttonStates[sender.tag - 1] = 1
                
            } else {
                sender.setImage(UIImage.init(named: "mark-o"), for: .normal)
                gameStatus.text = "first player's turn"
                firstPlayer = true
                buttonStates[sender.tag - 1] = 2
            }
        }
        
        
        if gameDrawn() && gameOngoing{
            let path = Bundle.main.path(forResource: "draw.wav", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            do {
                audio = try AVAudioPlayer(contentsOf: url)
                audio?.play()
            } catch {
                print("error with audio")
            }
            
            gameOngoing = false
            gameStatus.text = "Draw!"
            for i in 0...8 {
                
                if buttonStates[i] == 1 {
                    let buttonImage = UIImage(named: "mark-x")?.withRenderingMode(.alwaysTemplate)
                    buttons[i].setImage(buttonImage, for: .normal)
                    
                } else if buttonStates[i] == 2 {
                    let buttonImage = UIImage(named: "mark-o")?.withRenderingMode(.alwaysTemplate)
                    buttons[i].setImage(buttonImage, for: .normal)
                    
                }
                
                buttons[i].tintColor = .systemGray
                
            }
        } else if gameWonPlayerOne() && gameOngoing {
            
            let path = Bundle.main.path(forResource: "victory.wav", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            do {
                audio = try AVAudioPlayer(contentsOf: url)
                audio?.play()
            } catch {
                print("error with audio")
            }
            
            gameOngoing = false
            gameStatus.textColor = UIColor.green
            gameStatus.text = "Player one wins!"
            playerOneScore = playerOneScore + 1
            playerOne.text = "P1 Score: " + String(playerOneScore)

            
        } else if gameWonPlayerTwo() && gameOngoing {
            
            let path = Bundle.main.path(forResource: "victory.wav", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            do {
                audio = try AVAudioPlayer(contentsOf: url)
                audio?.play()
            } catch {
                print("error with audio")
            }
            
            gameOngoing = false
            gameStatus.textColor = UIColor.green
            gameStatus.text = "Player two wins!"
            playerTwoScore = playerTwoScore + 1
            playerTwo.text = "P2 Score: " + String(playerTwoScore)
            
            
        }

        
    }
    
    @IBAction func clear(_ sender: UIButton) {
        gameStatus.textColor = UIColor.black
        gameStatus.text = "first player's turn"
        gameOngoing = true
        firstPlayer = true
        audio?.stop()
        for button in buttons {
            button.setImage(UIImage.init(named: "mark-none"), for: .normal)
            buttonStates[button.tag - 1] = 0
        }
        
    }
    
    
    func gameWonPlayerOne() -> Bool {
        for wins in winning {
            if (buttonStates[wins[0]] == 1 && buttonStates[wins[0]] == buttonStates[wins[1]]) && (buttonStates[wins[1]] == buttonStates[wins[2]]) {
                
                let buttonImage = UIImage(named: "mark-x")?.withRenderingMode(.alwaysTemplate)
                buttons[wins[0]].setImage(buttonImage, for: .normal)
                buttons[wins[1]].setImage(buttonImage, for: .normal)
                buttons[wins[2]].setImage(buttonImage, for: .normal)
                buttons[wins[0]].tintColor = .systemYellow
                buttons[wins[1]].tintColor = .systemYellow
                buttons[wins[2]].tintColor = .systemYellow

                return true
            }
        }
        
        return false
    }
    
    func gameWonPlayerTwo() -> Bool {
        for wins in winning {
            if (buttonStates[wins[0]] == 2 && buttonStates[wins[0]] == buttonStates[wins[1]]) && (buttonStates[wins[1]] == buttonStates[wins[2]]) {
                
                let buttonImage = UIImage(named: "mark-o")?.withRenderingMode(.alwaysTemplate)
                buttons[wins[0]].setImage(buttonImage, for: .normal)
                buttons[wins[1]].setImage(buttonImage, for: .normal)
                buttons[wins[2]].setImage(buttonImage, for: .normal)
                buttons[wins[0]].tintColor = .systemYellow
                buttons[wins[1]].tintColor = .systemYellow
                buttons[wins[2]].tintColor = .systemYellow
                return true
            }
        }
        
        return false
    }
    
    func gameDrawn() -> Bool {
        var allButtTouched = true
        for state in buttonStates {
            if state == 0 {
                allButtTouched = false
            }
        }
        if allButtTouched && !(gameWonPlayerOne() || gameWonPlayerTwo()) {
            return true
        }
        return false
    }
    
    


}

