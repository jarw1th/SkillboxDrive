//
//  Files+CoreDataProperties.swift
//  ydisk_skillbox
//
//  Created by Руслан Парастаев on 01.03.2024.
//
//

import Foundation
import CoreData


extension Files {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Files> {
        return NSFetchRequest<Files>(entityName: "Files")
    }

    @NSManaged public var name: String?
    @NSManaged public var preview: Data?
    @NSManaged public var created: Date?
    @NSManaged public var size: Int32
    @NSManaged public var path: String?
    @NSManaged public var url: URL?
    @NSManaged public var publicUrl: String?
    @NSManaged public var type: String?
    @NSManaged public var id: String?

}

extension Files : Identifiable {

}
