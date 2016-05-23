//
//  MapViewController.h
//  Carpool
//
//  Created by Anuj Shah on 12/17/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapDisplay.h"
#import "MapKit/MapKit.h"

@interface MapViewController : UIViewController<MKAnnotation>{
    
}


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *dataToMap;

@property NSString *tripDate;
@property NSString *cost;
@property NSString *seats;
@property NSString *sourcelat;
@property NSString *sourcelong;
@property NSString *destinationlat;
@property NSString *destinationlong;

@end


