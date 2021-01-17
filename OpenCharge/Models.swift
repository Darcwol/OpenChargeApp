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
    let connections: [Connection]
    let generalComments: String?

    enum CodingKeys: String, CodingKey {
        case operatorInfo = "OperatorInfo"
        case usageType = "UsageType"
        case usageCost = "UsageCost"
        case addressInfo = "AddressInfo"
        case connections = "Connections"
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
    }
}

struct Connection: Codable {
    let connectionType: ConnectionType
    let level: Level
    let amps: Int?
    let voltage: Int?
    let powerKW: Double?
    let currentType: CurrentType?

    enum CodingKeys: String, CodingKey {
        case connectionType = "ConnectionType"
        case level = "Level"
        case amps = "Amps"
        case voltage = "Voltage"
        case powerKW = "PowerKW"
        case currentType = "CurrentType"
    }
}

struct ConnectionType: Codable {
    let formalName: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case formalName = "FormalName"
        case title = "Title"
    }
}

struct CurrentType: Codable {
    let title: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}

struct Level: Codable {
    let comments: String
    let isFastChargeCapable: Bool
    let title: String

    enum CodingKeys: String, CodingKey {
        case comments = "Comments"
        case isFastChargeCapable = "IsFastChargeCapable"
        case title = "Title"
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
