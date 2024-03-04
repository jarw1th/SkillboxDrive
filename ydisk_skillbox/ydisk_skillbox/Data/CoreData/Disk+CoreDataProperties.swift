//
//  Disk+CoreDataProperties.swift
//  ydisk_skillbox
//
//  Created by Руслан Парастаев on 03.03.2024.
//
//

import Foundation
import CoreData


extension Disk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Disk> {
        return NSFetchRequest<Disk>(entityName: "Disk")
    }

    @NSManaged public var usedSpace: Int64
    @NSManaged public var totalSpace: Int64

}

extension Disk : Identifiable {

}
