//
//  CustomAnnotation.swift
//  轨迹生活
//
//  Created by home on 2020/3/20.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomAnnotation: NSObject ,MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var title: String? = String()

    var subtitle: String? = String()
    
}
