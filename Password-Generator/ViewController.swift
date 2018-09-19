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
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    
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
    
    viewModel.output.length
      .asObservable()
      .map { $0 }
      .bind(to: lenghtTextField.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.wantSymbols
      .asObservable()
      .bind(to: wantSymbolsSwitch.rx.isOn)
      .disposed(by: disposeBag)
    
    viewModel.output.avoidProgChars
      .asObservable()
      .bind(to: avoidProgCharsSwitch.rx.isOn)
      .disposed(by: disposeBag)
    
    viewModel.output.avoidSimilarChars
      .asObservable()
      .bind(to: avoidSimilarCharsSwitch.rx.isOn)
      .disposed(by: disposeBag)
    
    viewModel.output.isLengthValid
      .asObservable()
      .subscribe(onNext: { [weak self] (isLengthValid) in
        self?.changeTextFieldBackground(isLengthValid)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.shouldDisplayError
      .asObservable()
      .subscribe(onNext: { [weak self] (isLengthValid) in
        self?.displayAlertIfNeeded(isLengthValid)
      })
      .disposed(by: disposeBag)
    

  }
  
  private func copyToPasteboard() {
    pasteboard.string = passwordLabel.text
    if let string = pasteboard.string {
      print(string)
    }
  }
  
  private func changeTextFieldBackground(_ isLengthValid: PasswordError) {
    switch isLengthValid {
    case .tooLong, .tooShort:
      lenghtTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
    case .ok:
      lenghtTextField.backgroundColor = .none
    }
  }
  
  private func displayAlertIfNeeded(_ isLengthValid: PasswordError) {
    var title = ""
    let message = "Please type a number between 8 and 99 for the length"
    switch isLengthValid {
    case .tooLong:
      title = "Password is too Long"
    case .tooShort:
      title = "Password is too short"
    case .ok:
      return
    }
    presentAlert(title, message)
  }
  
  private func presentAlert(_ title: String, _ message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - UITextFieldDelegate
  
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


