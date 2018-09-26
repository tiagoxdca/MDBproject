//
//  ViewController+CoreData.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 11/08/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.persistentContainer.viewContext
    }
    
    
    
}
