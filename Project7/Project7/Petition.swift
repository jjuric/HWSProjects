//
//  Petition.swift
//  Project7
//
//  Created by Jakov Juric on 08/11/2018.
//  Copyright © 2018 Jakov Juric. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
