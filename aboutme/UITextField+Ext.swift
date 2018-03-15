//
//  UITextField+Ext.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/15/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

extension UITextField {

    func makeToolBar(items: [UIBarButtonItem]) -> Void {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        toolBar.sizeToFit()

        // Adding Button ToolBar
        toolBar.setItems(items, animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }

}
