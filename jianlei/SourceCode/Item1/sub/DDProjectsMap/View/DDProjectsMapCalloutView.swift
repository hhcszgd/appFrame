//
//  DDProjectsMapCalloutView.swift
//  jianlei
//
//  Created by WY on 2019/9/5.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
import MapKit
class DDProjectsMapCalloutView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        self.addSubview(UISwitch())
//        self.detailCalloutAccessoryView = UISwitch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
