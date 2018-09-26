//
//  TeamMembers.swift
//  NameGame
//
//  Created by TJ Barber on 9/24/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

typealias TeamMembers = [TeamMember]
typealias TeamMembersDict = [String: TeamMember]

struct TeamMember: Codable {
    let id: String
    let type: String = "people"
    let slug: String
    let jobTitle: String?
    let firstName, lastName: String
    let headshot: Headshot
    let socialLinks: [SocialLink]
    let bio: String?
}

struct Headshot: Codable {
    let type: String = "image"
    let mimeType: MIMEType?
    let id: String
    let url: String?
    let alt: String
    let height, width: Int?
}

enum MIMEType: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
}

struct SocialLink: Codable {
    let type: SocialLinkType
    let callToAction: String
    let url: String
}

enum SocialLinkType: String, Codable {
    case google = "google"
    case linkedin = "linkedin"
    case twitter = "twitter"
}
