//
//  CoreDataViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/29/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataViewController: UIViewController {
    // class that all other core data views will inherit from for code reuse purposes
    
    // create fetched result controller, set delegate, and excute search
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet{
            fetchedResultsController?.delegate = self as! NSFetchedResultsControllerDelegate
            executeSearch()
        }
    }
    
    init (fetchedResultsController fc: NSFetchedResultsController<NSFetchRequestResult>){
        fetchedResultsController = fc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CoreDataViewController {
    
    // function that searches data stores or returns an error
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}
