//
//  ViewController.swift
//  AnimatedBar
//
//  Created by Alex Smetannikov on 04/06/2019.
//  Copyright (c) 2019 Alex Smetannikov. All rights reserved.
//

import UIKit
import AnimatedBar

class ViewController: UIViewController {
    @IBOutlet weak var firstAnimatedBar: AnimatedBar!
    @IBOutlet weak var secondAnimatedBar: AnimatedBar!
    @IBOutlet weak var thirdAnimatedBar: AnimatedBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAnimatedBars()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateBars()
    }

    func configureAnimatedBars() {
        firstAnimatedBar.backgroundColor = .clear
        firstAnimatedBar.barColors = [UIColor(red: 67/255, green: 198/255, blue: 172/255, alpha: 1),
                                      UIColor(red: 248/255, green: 255/255, blue: 174/255, alpha: 1)]

        secondAnimatedBar.backgroundColor = .clear
        secondAnimatedBar.barColors = [UIColor(red: 252/255, green: 92/255, blue: 125/255, alpha: 1),
                                       UIColor(red: 147/255, green: 84/255, blue: 227/255, alpha: 1),
                                       UIColor(red: 106/255, green: 130/255, blue: 251/255, alpha: 1)]

        thirdAnimatedBar.backgroundColor = .clear
        thirdAnimatedBar.barColors = [UIColor(red: 0/255, green: 12/255, blue: 64/255, alpha: 1),
                                      .white]
        thirdAnimatedBar.borderColor = .lightGray
        thirdAnimatedBar.borderWidth = 0.5
    }

    func animateBars() {
        thirdAnimatedBar.setPosition(0, withDuration: 0)  // Just cleaning bar

        firstAnimatedBar.setPosition(0.2, withDuration: 1.4)
        secondAnimatedBar.setPosition(0.9, withDuration: 1.4) { _ in
            self.thirdAnimatedBar.setPosition(0.9, withDuration: 1.4)
        }
    }

    @IBAction func onPushSartButton(_ sender: UIButton) {
        animateBars()
    }
}

