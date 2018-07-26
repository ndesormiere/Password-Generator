//
//  ViewController+Keyboard.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 26/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit

extension ViewController {
  @objc func keyboardWillShow(notification:NSNotification){
    var userInfo = notification.userInfo!
    var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    var contentInset:UIEdgeInsets = scrollview.contentInset
    contentInset.bottom = keyboardFrame.size.height + 50 // +50 for the accessory toolbar
    scrollview.contentInset = contentInset
  }
  
  @objc func keyboardWillHide(notification:NSNotification){
    let contentInset:UIEdgeInsets = UIEdgeInsets.zero
    scrollview.contentInset = contentInset
  }
}
