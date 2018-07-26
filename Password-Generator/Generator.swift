//
//  Generator.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 23/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

struct GeneratorSettings {
  var length: Int
  var wantSymbols: Bool
  var avoidProgChars: Bool
  var avoidSimilarChars: Bool
}

class Generator {
  
  static let shared = Generator()
  
  // MARK: - public methods
  
  func generatePassword(_ settings: GeneratorSettings) -> String {
    var passwordArray: [String] = []
    
    for _ in 0..<settings.length {
      let char = randomNumber() % 2 == 0 ?
        randomUpperChar(from: letters(settings.avoidSimilarChars)) :
        randomChar(from: letters(settings.avoidSimilarChars))
      passwordArray.append(char)
    }
    
    let numberOfDigits = randomNumberLessThanOrEqual(to: settings.length)
    for _ in 0..<numberOfDigits {
      passwordArray[(randomNumberLessThanOrEqual(to: settings.length)) - 1] = randomChar(from: numbers(settings.avoidSimilarChars))
    }
    
    if settings.wantSymbols {
      let numberOfSymbols = randomNumberLessThanOrEqual(to: settings.length)
      for _ in 0..<numberOfSymbols {
        passwordArray[(randomNumberLessThanOrEqual(to: settings.length)) - 1] = randomChar(from: symbols(settings.avoidProgChars))
      }
    }
    
    return passwordArray.joined()
  }
  
  // MARK: - private methods
  
  //preventing others from using the default '()' initializer for this class.
  private init() {}
  
  private func symbols(_ avoidProgChars: Bool) -> [String] {
    return avoidProgChars ?
      ["!", "%", "^", "*", "-", "_", "=", "+", ";", ":", "~", "|", "."] :
      ["`", " ", "!", "\"", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "{", "]", "}", ";", ":", "'", "@", "#", "~", "|", ",", "<", ".", ">", "/", "?", "\\"]
  }
  
  private func letters(_ avoidSimilarChars: Bool) -> [String] {
    return avoidSimilarChars ?
      ["a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] :
      ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  }
  
  private func numbers(_ avoidSimilarChars: Bool) -> [String] {
    return avoidSimilarChars ?
      ["2", "3", "4", "5", "6", "7", "8", "9"] :
      ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  }
  
  private func randomChar(from array: [String]) -> String {
    let rand = randomNumberLessThan(to: array.count)
    return array[rand]
  }
  
  private func randomUpperChar(from array: [String]) -> String {
    let rand = randomNumberLessThan(to: array.count)
    return array[rand].uppercased()
  }
  
  private func randomNumberLessThanOrEqual(to limit: Int) -> Int {
    return Int(arc4random_uniform(UInt32(limit)) + 1)
  }
  
  private func randomNumberLessThan(to limit: Int) -> Int {
    return Int(arc4random_uniform(UInt32(limit)))
  }
  
  private func randomNumber() -> Int {
    return Int(arc4random_uniform(UInt32(100)))
  }
  
}


