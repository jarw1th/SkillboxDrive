//
//  AllFiles+CoreDataProperties.swift
//  ydisk_skillbox
//
//  Created by Руслан Парастаев on 02.03.2024.
//
//

import Foundation
import CoreData


extension AllFiles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllFiles> {
        return NSFetchRequest<AllFiles>(entityName: "AllFiles")
    }

    @NSManaged public var created: Date?
    @NSManaged public var name: String?
    @NSManaged public var url: URL?
    @NSManaged public var publicUrl: String?
    @NSManaged public var id: String?
    @NSManaged public var path: String?
    @NSManaged public var preview: Data?
    @NSManaged public var size: Int32
    @NSManaged public var type: String?

}

extension AllFiles : Identifiable {

}
