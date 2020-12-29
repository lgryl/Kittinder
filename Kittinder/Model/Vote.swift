// Created 29/12/2020

import Foundation

struct Vote: Encodable {
    let imageId: String
    let userId: String
    let liked: Bool
}

extension Vote {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageId, forKey: .imageId)
        try container.encode(userId, forKey: .userId)
        let value = liked ? 1 : 0
        try container.encode(value, forKey: .liked)
    }

    enum CodingKeys: String, CodingKey {
        case imageId = "image_id"
        case userId = "sub_id"
        case liked = "value"
    }
}
