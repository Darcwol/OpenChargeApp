//
//  Station.swift
//  OpenCharge
//
//  Created by Kiril Maneichyk on 17/01/2021.
//

struct Station: Codable {
    let operatorInfo: OperatorInfo?
    let usageType: UsageType?
    let usageCost: String?
    let addressInfo: AddressInfo
    let generalComments: String?

    enum CodingKeys: String, CodingKey {
        case operatorInfo = "OperatorInfo"
        case usageType = "UsageType"
        case usageCost = "UsageCost"
        case addressInfo = "AddressInfo"
        case generalComments = "GeneralComments"
    }
}

struct AddressInfo: Codable {
    let title: String
    let addressLine1: String
    let addressLine2: String?
    let contactTelephone1: String?
    let contactTelephone2: String?
    let contactEmail: String?
    let accessComments: String?
    let relatedURL: String?
    let distance: Double
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case contactTelephone1 = "ContactTelephone1"
        case contactTelephone2 = "ContactTelephone2"
        case contactEmail = "ContactEmail"
        case accessComments = "AccessComments"
        case relatedURL = "RelatedURL"
        case distance = "Distance"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}


struct OperatorInfo: Codable {
    let websiteURL: String?
    let phonePrimaryContact: String?
    let phoneSecondaryContact: String?
    let contactEmail: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case websiteURL = "WebsiteURL"
        case phonePrimaryContact = "PhonePrimaryContact"
        case phoneSecondaryContact = "PhoneSecondaryContact"
        case contactEmail = "ContactEmail"
        case title = "Title"
    }
}

struct UsageType: Codable {
    let isPayAtLocation: Bool?
    let isMembershipRequired: Bool?
    let isAccessKeyRequired: Bool?
    let title: String

    enum CodingKeys: String, CodingKey {
        case isPayAtLocation = "IsPayAtLocation"
        case isMembershipRequired = "IsMembershipRequired"
        case isAccessKeyRequired = "IsAccessKeyRequired"
        case title = "Title"
    }
}
