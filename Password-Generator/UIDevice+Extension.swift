//
//  UIDevice+Extension.swift
//  Password-Generator
//
//  Created by Nicolas Desormiere on 27/7/18.
//  Copyright © 2018 Nicolas Desormiere. All rights reserved.
//

import UIKit

public extension UIDevice {
  
  public static var isIphoneX: Bool {
    let size = UIScreen.main.bounds.size
    return size.width == 375 && size.height > 800
  }
  
}
