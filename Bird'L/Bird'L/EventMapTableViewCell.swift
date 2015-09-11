//
//  EventMapTableViewCell.swift
//  Bird'L
//
//  Created by Thibaut Roche on 30/06/2015.
//  Copyright © 2015 Birdl. All rights reserved.
//

import UIKit
import MapKit

class EventMapTableViewCell: EventDetailTableViewCell
{
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Custom methods
    override func fillCell(row: EventRow)
    {
        let address = "3 Rue Pasteur, 94270 Le Kremlin Bicêtre, France"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: ({
            (placemarks, error) in
            
            if placemarks != nil && placemarks!.count > 0
            {
                let topResult = placemarks!.first
                let placemark = MKPlacemark(placemark: topResult!)
                var region = self.mapView.region
                
                region.center = (placemark.region as! CLCircularRegion).center
                region.span.longitudeDelta = 0.25 / 111
                region.span.latitudeDelta = 0.25 / 111
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(placemark)
                self.mapView.zoomEnabled = true
            }
        }))
    }
}