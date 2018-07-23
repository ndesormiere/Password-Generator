//
//  Generator.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 23/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

class Generator {
    
    static let shared = Generator()
    
    // MARK: - generator settings
    
    var lengthOfPassword: Int = 16
    var wantSymbols: Bool = true
    var avoidCharactersUsedInProgramming: Bool = false
    var avoidSimilarCharacters: Bool = false
    
    // MARK: - public methods
    
    func generatePassword() -> String {
        var passwordArray: [String] = []
        
        for _ in 0..<lengthOfPassword {
            let char = randomNumber() % 2 == 0 ?
                randomUpperChar(from: letters) :
                randomChar(from: letters)
            passwordArray.append(char)
        }
        
        let numberOfDigits = randomNumberLessThanOrEqual(to: lengthOfPassword)
        for _ in 0..<numberOfDigits {
            passwordArray[(randomNumberLessThanOrEqual(to: lengthOfPassword)) - 1] = randomChar(from: numbers)
        }
        
        if wantSymbols {
            let numberOfSymbols = randomNumberLessThanOrEqual(to: lengthOfPassword)
            for _ in 0..<numberOfSymbols {
                passwordArray[(randomNumberLessThanOrEqual(to: lengthOfPassword)) - 1] = randomChar(from: symbols)
            }
        }
        
        return passwordArray.joined()
    }
    
    // MARK: - private methods

    //preventing others from using the default '()' initializer for this class.
    private init() {}
    
    private var symbols: [String] {
        return avoidCharactersUsedInProgramming ?
            ["!", "%", "^", "*", "-", "_", "=", "+", ";", ":", "~", "|", "."] :
            ["`", " ", "!", "\"", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "{", "]", "}", ";", ":", "'", "@", "#", "~", "|", ",", "<", ".", ">", "/", "?", "\\"]
    }
    
    private var letters: [String] {
        return avoidSimilarCharacters ?
            ["a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] :
            ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    }
    
    private var numbers: [String] {
        return avoidSimilarCharacters ?
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

