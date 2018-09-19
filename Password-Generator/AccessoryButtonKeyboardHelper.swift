//
//  AccessoryButtonKeyboardHelper.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 26/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//


import Foundation
import UIKit

protocol AccessoryButtonKeyboardHelperDelegate : class {
  func didPressdoneButton(on textfield : UITextField)
}

class AccessoryButtonKeyboardHelper {
  
  weak var delegate : AccessoryButtonKeyboardHelperDelegate?
  
  //Creation of the toolbar
  let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
  
  //Creation of an array of UITextField that will have the done button
  var listTextFieldArray = [UITextField]()
  var listTextViewArray = [UITextView]()
  
  init(buttonTitle: String){
    //Creation of a spacer for the toolbar
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
    //Creation of an Array of UIBarButtonItem to populate the toolbar
    var items = [UIBarButtonItem]()
    
    //Creation of the toolbar Done button
    let doneBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: buttonTitle, style: UIBarButtonItem.Style.done, target: self, action: #selector(AccessoryButtonKeyboardHelper.doneButtonAction))
    
    //Addition of the buttons in the items array
    items.append(flexSpace)
    items.append(doneBarButtonItem)
    
    //Addition of the items array in the toolbar and resize
    toolbar.items = items
    toolbar.sizeToFit()
  }
  
  func addDoneButtonOn(_ concernedTextField: UITextField) {
    //Addition of the text field in the list
    listTextFieldArray.append(concernedTextField)
    
    //Addition of the toobar to our TextField
    concernedTextField.inputAccessoryView = toolbar
  }
  
  func addDoneButtonOn(_ concernedTextView: UITextView) {
    //Addition of the text field in the list
    listTextViewArray.append(concernedTextView)
    
    //Addition of the toobar to our TextField
    concernedTextView.inputAccessoryView = toolbar
  }
  
  @objc func doneButtonAction(_ sender: UIBarButtonItem){
    
    //Search of the first responder
    for textField in listTextFieldArray where textField.isFirstResponder {
      textField.resignFirstResponder()
      delegate?.didPressdoneButton(on : textField)
    }
    for textView in listTextViewArray where textView.isFirstResponder {
      textView.resignFirstResponder()
    }
  }
  
}

