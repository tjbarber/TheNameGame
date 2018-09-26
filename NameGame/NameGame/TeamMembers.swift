//
//  TeamMembers.swift
//  NameGame
//
//  Created by TJ Barber on 9/24/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

typealias TeamMembers = [TeamMember]
typealias TeamMembersDict = [String: TeamMember]

class TeamMember: Codable {
    let id: String
    let type: String = "people"
    let slug: String
    let jobTitle: String?
    let firstName, lastName: String
    let headshot: Headshot
    let socialLinks: [SocialLink]
    let bio: String?
    
    init(id: String, slug: String, jobTitle: String?, firstName: String, lastName: String, headshot: Headshot, socialLinks: [SocialLink], bio: String?) {
        self.id = id
        self.slug = slug
        self.jobTitle = jobTitle
        self.firstName = firstName
        self.lastName = lastName
        self.headshot = headshot
        self.socialLinks = socialLinks
        self.bio = bio
    }
}

class Headshot: Codable {
    let type: String = "image"
    let mimeType: MIMEType?
    let id: String
    let url: String?
    let alt: String
    let height, width: Int?
    var image: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case type, mimeType, id, url, alt, height, width
    }
    
    init(mimeType: MIMEType?, id: String, url: String?, alt: String, height: Int?, width: Int?) {
        self.mimeType = mimeType
        self.id = id
        self.url = url
        self.alt = alt
        self.height = height
        self.width = width
    }
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
