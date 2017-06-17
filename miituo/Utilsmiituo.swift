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
    
    ToastView.appearance().bottomOffsetPortrait = 90.0
    //ToastView.appearance().backgroundColor = UIColor.blue
    let to = Toast(text: message)
    to.show()
    //Toast(text: message).show()
}
