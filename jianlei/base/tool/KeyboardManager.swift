//
//  KeyboardManager.swift
//  keyboardControler
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2018 zhangkaiqiang. All rights reserved.
//

import UIKit

class KeyboardManager: NSObject {
    static let share = { () -> KeyboardManager in
        let object = KeyboardManager.init()
        object.parper()
        return object
    }()
    func parper() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            self?.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            self?.keyboardDidHidden(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            self?.keyboardWillChangeFrame(notification: notification)
        }
       
        
    }
    var keyboardFrame: CGRect = CGRect.zero
    var keyboardDuartion: Float = 0
    var keyboardWillChangeFrameBlock: ((CGRect, Float) -> ())?
    
    private func configShow(textField: UITextField) {
        if keyboardFrame == CGRect.zero {
            
        }else {
            
        }
    }
    
    
    
    
    private func keyboardWillShow(notification: Notification) {
        
        
        
//        print(notification)
    }
    
    private func keyboardDidHidden(notification: Notification) {
//        print(notification)
    }
    
    
    
    private func keyboardWillChangeFrame(notification: Notification) {
//        print(notification)
        var keyboardRect: CGRect = CGRect.zero
        var keyboardAnimationDuration: Float = 0
        if let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            keyboardRect = keyboardFrame
            self.keyboardFrame = keyboardFrame
            keyboardHeight = keyboardFrame.height
        }
        if let duration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Float {
            keyboardAnimationDuration = duration
            self.keyboardDuartion = duration
        }
    
        self.keyboardWillChangeFrameBlock?(keyboardRect, keyboardAnimationDuration)
    }
    
    
    private override init() {
        super.init()
    }

    
}
