//
//  ViewController.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 23/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var scrollview: UIScrollView!
  @IBOutlet weak var generatePasswordButton: UIButton!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var passwordLabelView: UIView!
  @IBOutlet weak var copyButton: UIButton!
  @IBOutlet weak var copyLabelView: UIView!
  @IBOutlet weak var lenghtStackView: UIStackView!
  @IBOutlet weak var lenghtTextField: UITextField!
  @IBOutlet weak var wantSymbolsStackView: UIStackView!
  @IBOutlet weak var wantSymbolsSwitch: UISwitch!
  @IBOutlet weak var avoidProgCharsStackView: UIStackView!
  @IBOutlet weak var avoidProgCharsSwitch: UISwitch!
  @IBOutlet weak var avoidSimilarCharsStackView: UIStackView!
  @IBOutlet weak var avoidSimilarCharsSwitch: UISwitch!
  
  let viewModel = ViewModel()
  let disposeBag = DisposeBag()
  let pasteboard = UIPasteboard.general
  fileprivate lazy var accessoryButtonKeyboard = AccessoryButtonKeyboardHelper(buttonTitle: "Done")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    lenghtTextField.delegate = self
    
    setupUI()
    setupViewModel()
  }
  
  private func setupUI() {
    
    generatePasswordButton.layer.cornerRadius = 5
    generatePasswordButton.layer.masksToBounds = true
    
    passwordLabelView.layer.cornerRadius = 5
    passwordLabelView.layer.masksToBounds = true

    accessoryButtonKeyboard.addDoneButtonOn(lenghtTextField)
  }
  
  private func setupViewModel() {
    
    // Input
    
    generatePasswordButton.rx.tap
      .bind(to: viewModel.input.generatePasswordTapped)
      .disposed(by: disposeBag)
    
    lenghtTextField.rx.text
      .orEmpty
      .bind(to: viewModel.input.length)
      .disposed(by: disposeBag)
    
    wantSymbolsSwitch.rx.isOn.changed
      .bind(to: viewModel.input.wantSymbols)
      .disposed(by: disposeBag)
    
    avoidProgCharsSwitch.rx.isOn.changed
      .bind(to: viewModel.input.avoidProgChars)
      .disposed(by: disposeBag)
    
    avoidSimilarCharsSwitch.rx.isOn.changed
      .bind(to: viewModel.input.avoidSimilarChars)
      .disposed(by: disposeBag)
    
    passwordLabelView.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] (_) in
        self?.copyToPasteboard()
      })
      .disposed(by: disposeBag)
    
    copyButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.copyToPasteboard()
      })
      .disposed(by: disposeBag)
    
    // Output
    
    viewModel.output.password
      .asObservable()
      .map { $0 }
      .bind(to: passwordLabel.rx.text)
      .disposed(by: disposeBag)
    
  }
  
  private func copyToPasteboard() {
    pasteboard.string = passwordLabel.text
    if let string = pasteboard.string {
      print(string)
    }
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    lenghtTextField.text = ""
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    
    // limit to 2 char ==> 99
    let limitLength = 2
    let newLength = text.count + string.count - range.length

    // disable . in numeric pad (only decimalDigits allowed)
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    
    return allowedCharacters.isSuperset(of: characterSet) && newLength <= limitLength
  }
  
}


