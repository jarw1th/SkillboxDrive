//
//  Public+CoreDataProperties.swift
//  ydisk_skillbox
//
//  Created by Руслан Парастаев on 04.03.2024.
//
//

import Foundation
import CoreData


extension Public {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Public> {
        return NSFetchRequest<Public>(entityName: "Public")
    }

    @NSManaged public var created: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var path: String?
    @NSManaged public var preview: Data?
    @NSManaged public var publicUrl: String?
    @NSManaged public var size: Int32
    @NSManaged public var type: String?
    @NSManaged public var url: URL?

}

extension Public : Identifiable {

}
