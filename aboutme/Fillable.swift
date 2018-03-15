//
//  Fillable.swift
//  aboutme
//
//  Created by Dmitri Petrishin on 3/15/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import RealmSwift

protocol Fillable {
    associatedtype Model
    func fill(by model: Model) -> Void
}

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}
protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}
