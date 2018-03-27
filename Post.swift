//
//  Post.swift
//  Selfigram
//
//  Created by Liam Fahy on 2018-03-07.
//  Copyright © 2018 Liam Fahy. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing{
    
    @NSManaged var image:PFFile
    @NSManaged var user:PFUser
    @NSManaged var comment:String
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    convenience init(image:PFFile, user:PFUser, comment:String){
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        self.init()
        self.image = image
        self.user = user
        self.comment = comment
    }

    
}
