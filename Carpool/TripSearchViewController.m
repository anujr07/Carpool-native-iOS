//
//  TripSearchViewController.m
//  Carpool
//
//  Created by Anuj Shah on 12/17/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "TripSearchViewController.h"
#import <MapKit/MapKit.h>
#import "SearchTrip.h"
#import "MapViewController.h"
#import "Trip.h"
#import "SearchResultTableViewController.h"

@interface TripSearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sourceAddress;
@property (weak, nonatomic) IBOutlet UITextField *destinationAddress;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;

@end

@implementation TripSearchViewController{
    SearchTrip *searchTrip;
    NSMutableArray *searchedList;
    NSString * sourceAddress;
    NSString * destinationAddress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchedList = [[NSMutableArray alloc]init];
    searchTrip = [[SearchTrip alloc]init];
    self.mapdisplay = [[MapDisplay alloc]init];
    self.mapdisplay.dataToMap = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sourceLatitudeLongitude:(id)sender {
    // source latitude and longitude conversion
    NSString *source = [NSString stringWithFormat:@"%@", self.sourceAddress.text];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    NSString *address = source;
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            //do something
        }
        if(placemarks && placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            CLLocation *location =placemark.location;
            NSLog(@"lat:%f,lon:%f",location.coordinate.latitude,location.coordinate.longitude);
            NSNumber *slat = [NSNumber numberWithFloat:location.coordinate.latitude];
            searchTrip.searchSourceLat = [slat stringValue];
            NSNumber *slong = [NSNumber numberWithFloat:location.coordinate.longitude];
            searchTrip.searchSourceLong = [slong stringValue];
        }
    }];
}
- (IBAction)destinationLatitudeLongitude:(id)sender {
    //destination latitude and longitude conversion
    NSString *destination = [NSString stringWithFormat:@"%@", self.destinationAddress.text];
    CLGeocoder *geoCoder1 = [[CLGeocoder alloc]init];
    NSString *destaddress = destination;
    [geoCoder1 geocodeAddressString:destaddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            //do something
        }
        if(placemarks && placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            CLLocation *location =placemark.location;
            NSLog(@"lat:%f,lon:%f",location.coordinate.latitude,location.coordinate.longitude);
            NSNumber *slat = [NSNumber numberWithFloat:location.coordinate.latitude];
            searchTrip.searchDestinationLat = [slat stringValue];
            NSNumber *slong = [NSNumber numberWithFloat:location.coordinate.longitude];
            searchTrip.searchDestinationLong = [slong stringValue];
        }
    }];
}

- (IBAction)maps:(id)sender {
    if([[self.sourceAddress text] isEqualToString:@""] ) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                            message: @"Enter Source Address"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    }else if([[self.destinationAddress text] isEqualToString:@""] ) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                            message: @"Enter Destination Address"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    }else{
        searchTrip.searchDate = [NSString stringWithFormat:@"%@",[self.date date]];
        
        NSDictionary *searchinfo = [NSDictionary dictionaryWithObjectsAndKeys:searchTrip.searchDate,@"tripDate",searchTrip.searchDestinationLat,@"sourcelat",searchTrip.searchDestinationLong,@"sourcelong",searchTrip.searchDestinationLat,@"destinationlat",searchTrip.searchDestinationLong,@"destinationlong", nil];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:searchinfo options:kNilOptions error: nil];
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:8080/controller/searchTrip"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]]forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSString *resultstring = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        
        if ([response statusCode] >= 200 && [response statusCode] < 300){
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            
            NSDictionary *jsonData = [NSJSONSerialization
                                      JSONObjectWithData:urlData
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
            
            //        id objects = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
            
            for(NSDictionary *n in jsonData){
                
                NSString *sourcelat = [n objectForKey:@"sourcelat"];
                NSString *sourcelong = [n objectForKey:@"sourcelong"];
                NSString *destinationlat = [n objectForKey:@"destinationlat"];
                NSString *destinationlong = [n objectForKey:@"destinationlong"];
                NSString *tripDate = [n objectForKey:@"tripDate"];
                NSString *cost = [n objectForKey:@"cost"];
                NSString *seats = [n objectForKey:@"seats"];
//                NSString *userId = [n objectForKey:@"userId"];
//                NSString *sourceAddress = [n objectForKey:@"sourceAddress"];
//                NSString *destinationAddress = [n objectForKey:@"destinationAddress"];
//                NSString *tripId = [n objectForKey:@"tripId"];
                
                NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:tripDate,@"tripDate",sourcelat,@"sourcelat",sourcelong,@"sourcelong",destinationlat,@"destinationlat",destinationlong,@"destinationlong",cost,@"cost",seats,@"seats",nil];
                
                [self.mapdisplay.dataToMap addObject:temp];
            }
        }
    }
}

- (IBAction)searchTrip:(id)sender {
    if([[self.sourceAddress text] isEqualToString:@""] ) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                            message: @"Enter Source Address"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    }else if([[self.destinationAddress text] isEqualToString:@""] ) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                            message: @"Enter Destination Address"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    }else{
    searchTrip.searchDate = [NSString stringWithFormat:@"%@",[self.date date]];

    NSDictionary *searchinfo = [NSDictionary dictionaryWithObjectsAndKeys:searchTrip.searchDate,@"tripDate",searchTrip.searchDestinationLat,@"sourcelat",searchTrip.searchDestinationLong,@"sourcelong",searchTrip.searchDestinationLat,@"destinationlat",searchTrip.searchDestinationLong,@"destinationlong", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:searchinfo options:kNilOptions error: nil];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/controller/searchTrip"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]]forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *resultstring = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    if ([response statusCode] >= 200 && [response statusCode] < 300){
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;

        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        
//        id objects = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
        
        for(NSDictionary *n in jsonData){
            
            
            Trip *trip = [[Trip alloc]init];
            trip.sourcelat = [n objectForKey:@"sourcelat"];
            trip.sourcelong = [n objectForKey:@"sourcelong"];
            trip.destinationlat = [n objectForKey:@"destinationlat"];
            trip.destinationlong = [n objectForKey:@"destinationlong"];
            trip.tripDate = [n objectForKey:@"tripDate"];
            trip.cost = [n objectForKey:@"cost"];
            trip.seats = [n objectForKey:@"seats"];
            trip.userId = [n objectForKey:@"userId"];
            trip.sourceAddress = [n objectForKey:@"sourceAddress"];
            trip.destinationAddress = [n objectForKey:@"destinationAddress"];
            trip.tripId = [n objectForKey:@"tripId"];
            [self.mapdisplay.dataToMap addObject:trip];
        }
    }
}
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"table"]){
        SearchResultTableViewController *search = (SearchResultTableViewController*)[segue destinationViewController];
        [search setDataToMap:self.mapdisplay.dataToMap];
    }
    if([segue.identifier isEqualToString:@"maps"]){
        MapViewController *map = (MapViewController*)[segue destinationViewController];
        [map setDataToMap:self.mapdisplay.dataToMap];
    }
}


@end
