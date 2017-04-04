//
//  ViewController.swift
//  TicTacToe
//
//  Created by Isabel  Lee on 07/02/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//


// - Attribution: http://stackoverflow.com/questions/31320819/scale-uibutton-animation-swift
// - Attribution: http://stackoverflow.com/questions/5725099/how-to-use-cgaffinetransformmakerotation
// - Attribution: http://stackoverflow.com/questions/25827330/what-is-the-swift-equivalent-of-uigesturerecognizerstateended
// - Attribution: https://www.youtube.com/watch?v=VnFQEhrHRlY
// - Attribution: https://www.youtube.com/watch?v=qbvUyIrmMxM
// - Attribution: https://www.youtube.com/watch?v=0JJNYaIsV7M
// - Attribution: https://www.youtube.com/watch?v=smvBuQ_uGqU
// - Attribution: https://www.youtube.com/watch?v=0XROSQxcNrk


import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Mark: Variables
    var board = ["E", "E", "E", "E", "E", "E", "E", "E", "E"]
    let wins = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    //wins is the block combination of winning boards. 
    //winLineVal is the x, y, width, height, rotation angle of the line corresponding the winning block 
    //combination in wins (used to draw a line connecting the three winning pieces)
    let winLineVal = [[25.0, 135.5, 325.0, 20.0, 0.0],
                      [25.0, 260.5, 325.0, 20.0, 0.0],
                      [25.0, 385.5, 325.0, 20.0, 0.0],
                      [52.5, 105.5, 20.0, 325.0, 0.0],
                      [177.5, 105.0, 20.0, 325.0, 0.0],
                      [302.5, 105.0, 20.0, 325.0, 0.0],
                      [177.5, 85.0, 20.0, 375.0, 2.356],
                      [177.5, 85.0, 20.0, 375.0, 0.78]]
    var winner = "E"         //winner is set to "E" , signifying no winner
    var player = "x"         //first player is x
    var gestureX: UIPanGestureRecognizer?
    var gestureO: UIPanGestureRecognizer?
    
    //sets up the audio player
    var okSound = AVAudioPlayer()
    var notOkSound = AVAudioPlayer()
    var winSound = AVAudioPlayer()
    
    //set up the UIView to draw the line connecting winning pieces
    var line = UIView(frame: CGRect(x: 0, y: 83, width: 325.0, height: 325.0))

    //Mark: Properties
    @IBOutlet weak var playerO: UIImageView!
    @IBOutlet weak var playerX: UIImageView!


    //Mark: Actions
    @IBAction func clearBoard(_ sender: UIButton) {
        // Not required. Used for debugging
        clearBoard()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureX = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gestureO = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        playerX.addGestureRecognizer(gestureX!)
        playerO.addGestureRecognizer(gestureO!)
        playerO.alpha = 0.5
        gestureO?.isEnabled = false
        self.view.addSubview(self.line)
        prepareSound()
    }
    
    
    //handlePan handles the pan gesture used to move x and o. Put pieces into blocks if no other pieces
    //occupy the block. Play the okSound if move is successful. Play the notOkSound if there is already 
    //a piece in the block. If the user moves a piece, but does not put it in any block, simply move the
    //piece back to its original place and wait for the user to make a move again. 
    
    func handlePan(_ recognizer:UIPanGestureRecognizer) {
        
        //This part assuems the current player is x
        var coordinate = CGPoint(x: 55, y: 539)
        var nextPlayer = self.gestureO
        var nextPlayerName = "o"
        var nextPlayerImg = playerO
        //If the player is o, set up the values as follows:
        if self.player == "o" {
            coordinate = CGPoint(x: 320, y: 539)
            nextPlayer = self.gestureX
            nextPlayerName = "x"
            nextPlayerImg = playerX
        }
        
        //This block of code makes sure x and o follows the user's pan gesture
        let translation = recognizer.translation(in: self.view)

        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        

        //handleMove function handles a user's move after the pan gesture eneded. 
        //Patameter: imgTag is an Int the is the tag a the image view
        //there are 9 imageViews in the storyboard(with tag 1~9), each representing 
        //a valid block to hold o or o. This funcion tests whether x or o intersects 
        //with the imageView with tag imgTag. If it does, put the piece in there.
        //This function is intentionally nested inside the handlePan function because it uses
        //a lot of local variables in handlePan, and no other part of the program need to
        //call this function. 
        
        func handleMove(imgTag: Int) {
            guard let tempImgView = self.view.viewWithTag(imgTag) as? UIImageView else {
                print("unsucessful unwrap")
                return
            }
            
            let smallerFrame = tempImgView.frame.insetBy(dx: 60.0, dy: 60.0)
            // This temporarily shrinks the image view for more precise intersection checking. 
            //Otherwise the piece often intsersect with more than one image view, causing some
            //unneccesary trouble.
            
            if (recognizer.view?.frame)!.intersects(smallerFrame) && emptySpot(board: self.board).contains(imgTag){
                board[imgTag - 1] = self.player
                tempImgView.image = UIImage(named: self.player)
                recognizer.view?.alpha = 0.5
                recognizer.view?.center = coordinate
                recognizer.isEnabled = false
                self.player = nextPlayerName
                nextPlayer?.isEnabled = true
                nextPlayerImg?.alpha = 1
                okSound.play()
                UIView.animate(withDuration: 0.6, animations: {
                    nextPlayerImg?.transform = CGAffineTransform(scaleX: 2, y: 2) },
                               completion: { (finish: Bool) in
                                UIView.animate(withDuration: 0.6, animations: {
                                    nextPlayerImg?.transform = CGAffineTransform.identity }) })
                

            } else if ((recognizer.view?.frame)!.intersects(tempImgView.frame) && !emptySpot(board: self.board).contains(imgTag)) {
                notOkSound.play()
            }
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {

            for i in 1...9{
                handleMove(imgTag: i)
            }
            recognizer.view?.center = coordinate
            
            for i in 0...7{

                
                let patterns = self.wins[i]
                if board[patterns[0]] != "E" && board[patterns[0]] == board[patterns[1]] && board[patterns[1]] == board[patterns[2]]{
                    self.winner = board[patterns[0]]
                    print("\(self.winner) wins")
                    self.gestureO?.isEnabled = false
                    self.gestureX?.isEnabled = false
                    winSound.play()
                    drawLine(value: self.winLineVal[i])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        self.performSegue(withIdentifier: "win", sender: Any?.self)
                        self.clearBoard()
                    }
                    break
                }
            }
            
            if emptySpot(board: board) == [] && self.winner == "E" {
                print("It's a tie")
                self.performSegue(withIdentifier: "win", sender: Any?.self)
                clearBoard()
            }
        }
    }
    
    
    //emptySpot takes in an array of Strings, and returns an array of integers, which are the tag of the empty blocks.
    func emptySpot(board: [String]) -> [Int]{
        var emptyBlock:[Int] = []
        for i in 0...8{
            if board[i] == "E" {
                emptyBlock.append(i+1)
            }
        }
        return emptyBlock
    }
    
    //clears board and get ready for a new game.
    func clearBoard(){
        for i in 1...9 {
            if let tempImg = self.view.viewWithTag(i) as? UIImageView {
                tempImg.image  = nil
            }
        }
        self.board = ["E", "E", "E", "E", "E", "E", "E", "E", "E"]
        self.playerO.alpha = 0.5
        self.playerX.alpha = 1
        self.gestureO?.isEnabled = false
        self.gestureX?.isEnabled = true
        self.playerX.center = CGPoint(x: 55, y: 539)
        self.playerO.center = CGPoint(x: 320, y: 539)
        self.player = "x"
        self.winner = "E"
        self.line.alpha = 0
        self.view.willRemoveSubview(self.line)
    }

    //allow other views to unwind to this view
    @IBAction func unwindToRVC(sender: UIStoryboardSegue) {
        print("Back at RVC")
    }

    //Two segue are used in this project. The first one is has identifier "info".
    //"info" gets triggered when the user taps the "how to play" button. 
    //The other one is "win", which is triggered programmatically to show win/tie information. 
    //This function makes sure proper information is passed into the InfoViewController
    //So that the InfoViewController can show appropriate text/ title accordingly.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "info") {
            
            let viewController = segue.destination as! InfoViewController
            
            viewController.passedData = "info"
        }
        if (segue.identifier == "win") {
            
            let viewController = segue.destination as! InfoViewController
            
            viewController.passedData = winner
        }
    }
    
    //prepares the sound to be played
    func prepareSound(){
        do {
            self.okSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ok", ofType: "mp3")!))
            self.winSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "win", ofType: "mp3")!))
            self.notOkSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "notOk", ofType: "mp3")!))
            self.okSound.prepareToPlay()
            self.winSound.prepareToPlay()
            self.notOkSound.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    //drawLine takes in an array of Doubles with 5 values inside. 
    //The values are [x, y, width, height, rotationAngle].
    //This function is used to draw an appropriate line connecting the winning pieces when x or o wins.
    func drawLine(value:[Double]){
        self.line = UIView(frame: CGRect(x: value[0], y: value[1], width: value[2], height: value[3]))
        //self.line.frame = CGRect(x: value[0], y: value[1], width: value[2], height: value[3])
        self.line.alpha = 1
        self.line.layer.backgroundColor = UIColor.red.cgColor
        self.line.transform = CGAffineTransform(rotationAngle: CGFloat(value[4]));
        print("====== Draw Line: \(self.line.frame.width), \(self.line.frame.height) ==========")
        self.view.addSubview(self.line)
    }
    
}

