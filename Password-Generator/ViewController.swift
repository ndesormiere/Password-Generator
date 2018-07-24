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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        generatePasswordButton.layer.cornerRadius = 5
        generatePasswordButton.layer.masksToBounds = true
    }

    @IBAction func generatePasswordTapped(_ sender: Any) {
        let password = Generator.shared.generatePassword()
        passwordLabel.text = password
    }
    
}

