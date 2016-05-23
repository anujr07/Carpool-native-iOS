//
//  MapPin.h
//  Carpool
//
//  Created by Anuj Shah on 12/18/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation>

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *Date;
@property(nonatomic,copy) NSString *Cost;
@property(nonatomic,copy) NSString *Seats;

@end
