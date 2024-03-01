//
//  Files+CoreDataProperties.swift
//  
//
//  Created by Руслан Парастаев on 01.03.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Files {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Files> {
        return NSFetchRequest<Files>(entityName: "Files")
    }

    @NSManaged public var created: Date?
    @NSManaged public var name: String?
    @NSManaged public var preview: Data?
    @NSManaged public var size: Int32

}

extension Files : Identifiable {

}
