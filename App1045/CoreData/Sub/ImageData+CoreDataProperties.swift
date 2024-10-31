//
//  ImageData+CoreDataProperties.swift
//  App1045
//
//  Created by Николай Щербаков on 31.10.2024.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var imageData: Data
    @NSManaged public var uuid: UUID
    @NSManaged public var imageUUID: UUID

}

extension ImageData : Identifiable {

}
