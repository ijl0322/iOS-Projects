//
//  MessagesViewController.swift
//  Benny Cam imessage
//
//  Created by Isabel  Lee on 07/03/2017.
//  Copyright © 2017 Isabel  Lee. All rights reserved.

//  - Attribution: https://developer.apple.com/videos/play/wwdc2016/224/
//  - Attribution: https://developer.apple.com/videos/play/wwdc2016/204/

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
    
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Determine the controller to present.
        
        let controller: UIViewController
        if presentationStyle == .compact {
            controller = instantiateStickerController()
            
        }
        else {
            print("image view controller instantiated")
            controller = instantiateImageController()
        }
        
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    private func instantiateStickerController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "stickerViewController") as? StickerViewController else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        controller.delegate = self
        
        return controller
    }
    
    private func instantiateImageController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "imageViewController") as? ImageViewController else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        controller.delegate = self
        
        return controller
    }
    
}


extension MessagesViewController: sendPhotoDelegate {
    func sendPhoto(img: UIImage) {
        requestPresentationStyle(.compact)
        print("image received")
        let layout = MSMessageTemplateLayout()
        //layout.caption = "HI"
        layout.image = img
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }

}

extension MessagesViewController: stickerViewDelegate {
    
    func createImage() {
        requestPresentationStyle(.expanded)
    }
}
