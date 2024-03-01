//
//  AppSettings+CoreDataProperties.swift
//  ydisk_skillbox
//
//  Created by Руслан Парастаев on 01.03.2024.
//
//

import Foundation
import CoreData


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var isAuthorized: Bool

}

extension AppSettings : Identifiable {

}
