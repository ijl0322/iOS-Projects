//
//  ViewController.swift
//  It’s A Zoo in There
//
//  Created by Isabel  Lee on 24/01/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.
//

// - Attribution : http://stackoverflow.com/questions/26569371/how-do-you-create-a-uiimage-view-programmatically-swift
// - Attribution : https://www.youtube.com/watch?v=dqad3XuMwHI
// - Attribution : http://stackoverflow.com/questions/25461202/how-to-access-uibutton-via-tag-in-swift


import UIKit
import AVFoundation


class Animal {
    let name: String
    let species: String
    let age: Int
    let image: UIImage?
    let soundPath: String
    
    init (name: String, species: String, age: Int, image: UIImage, soundPath: String)
    {
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
    }
    
    func dumpAnimalObject() -> String {
        let description = "Name: \(name), Species: \(species), Age: \(age), Image: \(String(describing: image))"
        return description
    }
}


class ViewController: UIViewController, UIScrollViewDelegate {
    
    //Mark: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var AnimalLabel: UILabel!
    
    //Mark: Variables
    var animalArray = [Animal]()
    
    var dogAudio = AVAudioPlayer()
    
    var catAudio = AVAudioPlayer()
    
    var owlAudio = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize three animals and add them to the animal array
        let dog = Animal(name: "Lucky", species: "Dog", age: 5, image: UIImage(named: "dog")!, soundPath: "dog")
        let cat = Animal(name: "Marie", species: "Cat", age: 2, image: UIImage(named: "cat")!, soundPath: "cat")
        let owl = Animal(name: "Hedwig", species: "Owl", age: 7, image: UIImage(named: "owl")!, soundPath: "owl")
        animalArray += [dog, cat, owl]
        animalArray.shuffle()

        do {
            dogAudio = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "dog", ofType: "mp3")!))
            catAudio = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cat", ofType: "mp3")!))
            owlAudio = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "owl", ofType: "mp3")!))
            dogAudio.prepareToPlay()
            catAudio.prepareToPlay()
            owlAudio.prepareToPlay()
        } catch {
            print(error)
        }
        
        
        //Add images of animals to scrollView
        for i in 0...2 {
            let imageView = UIImageView(image: animalArray[i].image!)
            imageView.frame = CGRect(x: 375.0 * Double(i), y: 0, width: 375, height: 500)
            scrollView.addSubview(imageView)
        }
        
        //Add buttons to scrollView
        for i in 1...3 {
            let button: UIButton = UIButton(frame: CGRect(x: Double(i-1) * 375.0 + 127.0 , y: 450.0, width: 120.0, height: 50.0))
            button.backgroundColor = UIColor.black
            button.setTitle("\(animalArray[i-1].name)", for: UIControlState.normal)
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
            button.tag = i
            scrollView.addSubview(button)
        }
        
        //Set the animal label to the first animal when app launches
        AnimalLabel.text = animalArray[0].species
        
        //Set up scrollView
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 1125, height: 500)
        scrollView.backgroundColor = UIColor.white
    }
    
    
    //buttonTapped: Shows info of the animal on the page
    //- Parameter: UIButton (the button tapped)
    
    func buttonTapped(_ button: UIButton!) {
        //print("\(button.tag)Button pressed")
        showInfo(button.tag)
        print(animalArray[button.tag-1].dumpAnimalObject())
    }
    
    //showInfo - shows the information of the animal on screen and plays the sound of the animal
    //- Parameters: tag is the tag of the button pressed
    func showInfo(_ tag: Int) {
        let info = UIAlertController(title: "\(animalArray[tag-1].species)",
            message: "The \(animalArray[tag-1].species) is \(animalArray[tag-1].age) years old!",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default,handler: nil)
        info.addAction(action)
        present(info, animated: true, completion: nil)
        
        //Decide which sound to play accorind to the animal on screen
        if animalArray[tag-1].species == "Dog" {
            dogAudio.play()
        }
        if animalArray[tag-1].species == "Cat" {
            catAudio.play()
        }
        if animalArray[tag-1].species == "Owl" {
            owlAudio.play()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("Scroll view is scrolling: \(scrollView.contentOffset)")
        
        var position = scrollView.contentOffset.x
        while (position >= 375){
            position -= 375.0
        }
        
        //Animating the label to fade out
        AnimalLabel.alpha = 1 - position/375
        
        //Animating buttons to fade out
        if let tempButton0 = self.view.viewWithTag(1) as? UIButton {
            tempButton0.alpha  = 0.5
        }
        
        if let tempButton1 = self.view.viewWithTag(2) as? UIButton {
            tempButton1.alpha  = 0.5
        }
        
        if let tempButton2 = self.view.viewWithTag(3) as? UIButton {
            tempButton2.alpha  = 0.5
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        //Change text according to the animal on the page
        if scrollView.contentOffset == CGPoint(x: 0.0, y: 0.0){
            AnimalLabel.text = animalArray[0].species
        }
        
        if scrollView.contentOffset == CGPoint(x: 375.0, y: 0.0){
            AnimalLabel.text = animalArray[1].species
        }
        
        if scrollView.contentOffset == CGPoint(x: 750.0, y: 0.0){
            AnimalLabel.text = animalArray[2].species
        }
        
        //Animate buttons to fade in
        if let tempButton0 = self.view.viewWithTag(1) as? UIButton {
            tempButton0.alpha  = 1.0
        }
        
        if let tempButton1 = self.view.viewWithTag(2) as? UIButton {
            tempButton1.alpha  = 1.0
        }
        
        if let tempButton2 = self.view.viewWithTag(3) as? UIButton {
            tempButton2.alpha  = 1.0
        }
        
    }
    
}


extension Array {

    //shuffle: randomly switches order of all elements inside an array
    mutating func shuffle() {
        for i in 0..<count{
            let j = Int(arc4random_uniform(UInt32(count)))
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
