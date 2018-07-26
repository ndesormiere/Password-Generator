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

class ViewController: UIViewController {
  
  @IBOutlet weak var generatePasswordButton: UIButton!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var showOptionButton: UIButton!
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupViewModel()
  }
  
  private func setupUI() {
    
    hideStackViews(true)

    generatePasswordButton.layer.cornerRadius = 5
    generatePasswordButton.layer.masksToBounds = true
  }
  
  private func setupViewModel() {
    
    // Input
    
    generatePasswordButton.rx.tap
      .bind(to: viewModel.input.generatePasswordTapped)
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
    
    // Output
    
    viewModel.output.password
      .asObservable()
      .map { $0 }
      .bind(to: passwordLabel.rx.text)
      .disposed(by: disposeBag)
    
  }
  
  @IBAction func showOptionsTapped(_ sender: Any) {
    hideStackViews(false)
  }
  
  private func hideStackViews(_ value: Bool) {
    showOptionButton.isHidden = !value
    lenghtStackView.isHidden = value
    wantSymbolsStackView.isHidden = value
    avoidProgCharsStackView.isHidden = value
    avoidSimilarCharsStackView.isHidden = value
  }
  
}


