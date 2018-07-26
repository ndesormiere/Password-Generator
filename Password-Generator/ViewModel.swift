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

class ViewModel: ViewModelType {
  
  struct Input {
    let length: AnyObserver<Int>
    let wantSymbols: AnyObserver<Bool>
    let avoidProgChars: AnyObserver<Bool>
    let avoidSimilarChars: AnyObserver<Bool>
    let generatePasswordTapped: AnyObserver<Void>
  }
  
  struct Output {
    let password: Driver<String>
  }
  
  private struct Subject {
    let generatePasswordTapped = PublishSubject<Void>()
    let length = BehaviorSubject<Int>(value: 15)
    let wantSymbols = BehaviorSubject<Bool>(value: true)
    let avoidProgChars = BehaviorSubject<Bool>(value: false)
    let avoidSimilarChars = BehaviorSubject<Bool>(value: false)
    let password = BehaviorSubject<String>(value: "")
  }
  
  private let subject = Subject()
  private let disposeBag = DisposeBag()
  private var settings = GeneratorSettings(length: 15, wantSymbols: true, avoidProgChars: false, avoidSimilarChars: false)
  
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
      password: subject.password.asDriver(onErrorJustReturn: "")
    )
    
    setup()
  }
  
  // MARK: - private
  
  private func setup() {

    Observable
      .combineLatest(subject.length.asObservable(), subject.wantSymbols.asObservable(), subject.avoidProgChars.asObservable(), subject.avoidSimilarChars.asObservable())
      .subscribe(onNext: { [weak self] (length, wantSymbols, avoidProgChars, avoidSimilarChars) in
        let generatorSettings = GeneratorSettings(length: length, wantSymbols: wantSymbols, avoidProgChars: avoidProgChars, avoidSimilarChars: avoidSimilarChars)
        self?.settings = generatorSettings
        let password = Generator.shared.generatePassword(generatorSettings)
        self?.subject.password.onNext(password)
      })
      .disposed(by: disposeBag)
    
    subject.generatePasswordTapped
      .subscribe(onNext: { [weak self] (_) in
        guard let generatorSettings = self?.settings else { return }
        let password = Generator.shared.generatePassword(generatorSettings)
        self?.subject.password.onNext(password)
      })
      .disposed(by: disposeBag)
    
  }
  
}
