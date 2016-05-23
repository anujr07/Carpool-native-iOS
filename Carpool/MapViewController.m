//
//  MapViewController.m
//  Carpool
//
//  Created by Anuj Shah on 12/17/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"

@interface MapViewController (){
 CLLocationManager *myLocationManager;
}
@end

@implementation MapViewController
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(NSDictionary *n in self.dataToMap){
        
        self.tripDate =  [n objectForKey:@"tripDate"];
        self.cost = [n objectForKey:@"cost"];
        self.seats = [n objectForKey:@"seats"];
        self.sourcelat = [n objectForKey:@"sourcelat"];
        self.sourcelong = [n objectForKey:@"sourcelong"];
        self.destinationlat = [n objectForKey:@"destinationlat"];
        self.destinationlong = [n objectForKey:@"destinationlong"];
        
        
        //the center of the region we'll move the map to
        double slat = [self.sourcelat doubleValue];
        double slong = [self.sourcelong doubleValue];
        CLLocationCoordinate2D center;
        center.latitude = slat;
        center.longitude = slong;
        
        //set up zoom level
        MKCoordinateSpan zoom;
        zoom.latitudeDelta = .1f; //the zoom level in degrees
        zoom.longitudeDelta = .1f;//the zoom level in degrees
        
        //the region the map will be showing
        MKCoordinateRegion myRegion;
        myRegion.center = center;
        myRegion.span = zoom;
        
        //programmatically create a map that fits the screen
        CGRect screen = [[UIScreen mainScreen] bounds];
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:screen ];
        
        //set the map location/region
        [self.mapView setRegion:myRegion animated:YES];
        
        self.mapView.mapType = MKMapTypeStandard;//standard map(not satellite)
        
        MapPin *pin = [[MapPin alloc] init];
        pin.Cost = self.cost;
        pin.Seats = self.seats;
        pin.Date = self.tripDate;
        [self.mapView addAnnotation:pin];
        pin.coordinate = center;
        
        [self.view addSubview:self.mapView];//add map to the view

        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
