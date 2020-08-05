//
//  City+CoreDataClass.swift
//  Lab5
//
//  Created by Melanie Hendricks on 3/20/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//
//

import Foundation
import CoreData


public class City: NSManagedObject {

    /*
    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }
 */

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var picture: Data?

}
