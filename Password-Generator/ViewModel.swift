//
//  ViewModel.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 25/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum PasswordError {
  case tooShort
  case tooLong
  case ok
}

class ViewModel: ViewModelType {
  
  struct Input {
    let length: AnyObserver<String>
    let wantSymbols: AnyObserver<Bool>
    let avoidProgChars: AnyObserver<Bool>
    let avoidSimilarChars: AnyObserver<Bool>
    let generatePasswordTapped: AnyObserver<Void>
  }
  
  struct Output {
    let password: Driver<String>
    let length: Driver<String>
    let wantSymbols: Driver<Bool>
    let avoidProgChars: Driver<Bool>
    let avoidSimilarChars: Driver<Bool>
    let isLengthValid: Driver<PasswordError>
    let shouldDisplayError: Driver<PasswordError>
  }
  
  private struct Subject {
    let generatePasswordTapped = PublishSubject<Void>()
    let length = BehaviorSubject<String>(value: "15")
    let wantSymbols = BehaviorSubject<Bool>(value: true)
    let avoidProgChars = BehaviorSubject<Bool>(value: false)
    let avoidSimilarChars = BehaviorSubject<Bool>(value: false)
    let password = PublishSubject<String>()
    let isLengthValid = BehaviorSubject<PasswordError>(value: .ok)
    let shouldDisplayError = PublishSubject<PasswordError>()
  }
  
  private let subject = Subject()
  private let disposeBag = DisposeBag()
  private var settings = GeneratorSettings(length: 15, wantSymbols: true, avoidProgChars: false, avoidSimilarChars: false)
  private var isLengthValid: PasswordError = .ok
  
  let output: Output
  let input: Input
  
  // Life cycle
  
  init() {
    
    input = Input(
      length: subject.length.asObserver(),
      wantSymbols: subject.wantSymbols.asObserver(),
      avoidProgChars: subject.avoidProgChars.asObserver(),
      avoidSimilarChars: subject.avoidSimilarChars.asObserver(),
      generatePasswordTapped: subject.generatePasswordTapped.asObserver()
    )
    
    output = Output(
      password: subject.password.asDriver(onErrorJustReturn: ""),
      length: subject.length.asDriver(onErrorJustReturn: "15"),
      wantSymbols: subject.wantSymbols.asDriver(onErrorJustReturn: true),
      avoidProgChars: subject.avoidProgChars.asDriver(onErrorJustReturn: false),
      avoidSimilarChars: subject.avoidSimilarChars.asDriver(onErrorJustReturn: false),
      isLengthValid: subject.isLengthValid.asDriver(onErrorJustReturn: .ok),
      shouldDisplayError: subject.shouldDisplayError.asDriver(onErrorJustReturn: .ok)
    )
    
    setup()
  }
  
  // MARK: - private
  
  private func setup() {

    Observable
      .combineLatest(subject.wantSymbols.asObservable(), subject.avoidProgChars.asObservable(), subject.avoidSimilarChars.asObservable())
      .subscribe(onNext: { [weak self] (wantSymbols, avoidProgChars, avoidSimilarChars) in
        guard let `self` = self else { return }
        let generatorSettings = GeneratorSettings(length: self.settings.length, wantSymbols: wantSymbols, avoidProgChars: avoidProgChars, avoidSimilarChars: avoidSimilarChars)
        self.settings = generatorSettings
        self.generatePassword()
      })
      .disposed(by: disposeBag)
    
    subject.generatePasswordTapped
      .subscribe(onNext: { [weak self] (_) in
        self?.generatePassword()
      })
      .disposed(by: disposeBag)
    
    subject.length
      .subscribe(onNext: { [weak self] (length) in
        let intLength = Int(length) ?? 15
        self?.checkPassword(intLength)
        self?.settings.length = intLength
      })
      .disposed(by: disposeBag)
    
  }
  
  private func checkPassword(_ length: Int) {
    if length < 8 {
      isLengthValid = .tooShort
    } else if length > 99 {
      isLengthValid = .tooLong
    } else {
      isLengthValid = .ok
    }
    subject.isLengthValid.onNext(isLengthValid)
  }
  
  private func generatePassword() {
    switch isLengthValid {
    case .tooShort, .tooLong:
      subject.shouldDisplayError.onNext(isLengthValid)
    case .ok:
      let password = Generator.shared.generatePassword(settings)
      subject.password.onNext(password)
    }
  }
  
}
