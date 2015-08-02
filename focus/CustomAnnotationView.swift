//
// Created by syouhei on 15/08/01.
// Copyright (c) 2015 山口将平. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    class var size :CGSize {
        return CGSize(width: 44.0, height: 44.0)
    }

    var thumbnailImage: UIImage? {
        didSet {
            self.thumbnailImageView.image = self.thumbnailImage
        }
    }

    private let thumbnailImageView: UIImageView! = UIImageView(frame: CGRect(origin: CGPointMake(-7, -40), size: CustomAnnotationView.size))

    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(origin: self.frame.origin, size: CustomAnnotationView.size)
        self.canShowCallout = true
        self.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
        self.thumbnailImageView.contentMode = .ScaleAspectFill
        self.thumbnailImageView.clipsToBounds = true
        self.addSubview(self.thumbnailImageView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        self.thumbnailImage = nil
    }
}
