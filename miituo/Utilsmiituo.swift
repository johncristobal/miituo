//
//  Utilsmiituo.swift
//  devmiituo
//
//  Created by vera_john on 30/03/17.
//  Copyright © 2017 VERA. All rights reserved.
//

import UIKit
import Foundation
import Toaster

//function to show toast
func showmessage(message: String){
    
    ToastView.appearance().bottomOffsetPortrait = 220.0
    ToastView.appearance().font = UIFont(name: "DIN Next Rounded LT Pro", size: 18.0)

    //ToastView.appearance().backgroundColor = UIColor.blue
    let to = Toast(text: message,duration: Delay.long)
    to.show()
    //Toast(text: message).show()
}
