//
//  ChatViewController.swift
//  Jetpal
//
//  Created by Alexandr on 10/18/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    var isKeyboardAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestures()
        notificationSetup()
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    
    //MARK: - Gestures
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap))
        view.addGestureRecognizer(tap)
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    //MARK: - Notifications
    func notificationSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
    }
    
    //MARK: - Keyboard hide and change methods
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if messageTxtBox.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    //MARK: - Notification Methods
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLabel.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    //MARK: - Channel and Messages methods
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    //MARK: - SendMessages, GetMessages
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTxtBox.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxtBox.text = ""
                    self.messageTxtBox.resignFirstResponder()
                }
            }
        }
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channels yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
           //ss
        }
    }
    
}
