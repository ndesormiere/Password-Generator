//
//  ViewModelType.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 25/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import Foundation

protocol ViewModelType {
  
  associatedtype Input
  associatedtype Output
  
  var input: Input { get }
  var output: Output { get }
  
}
