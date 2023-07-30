//
//  AppConstants.swift
//  TodoApp
//
//  Created by koala panda on 2023/07/30.
//

import Foundation
import UIKit

struct Design {
    struct Color {
        struct Primary {
//            static let Blue = UIColor.rgba(red: 0, green: 122, blue: 255, alpha: 1)

        }
        struct Secondary {

        }
        struct Grayscale {

        }
    }
    struct Image {
        static let icoStar = UIImage(named: "ico_imageName")

    }
    struct Font {

         static let Body = UIFont.systemFont(ofSize: 16, weight: .regular)

    }

}

struct FirestoreKeys {
    enum Todo: String {
        case title
        case detail
        case isDone
    }
}


struct API {

    static let twitterApiUrl = "https://api.twitter.com/"
//    static let DB_REF = Firestore.firestore()

}
