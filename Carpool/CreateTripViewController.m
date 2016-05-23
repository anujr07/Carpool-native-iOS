//
//  CreateTripViewController.m
//  Carpool
//
//  Created by Anuj Shah on 12/14/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "CreateTripViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Trip.h"

@interface CreateTripViewController ()
@property (weak, nonatomic) IBOutlet UITextField *source;
@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (weak, nonatomic) IBOutlet UIDatePicker *tripDate;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;
@property (weak, nonatomic) IBOutlet UISlider *seats;
@property (weak, nonatomic) IBOutlet UILabel *costsLabel;
@property (weak, nonatomic) IBOutlet UISlider *costs;


@end

@implementation CreateTripViewController{
    Trip *trip;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    trip = [[Trip alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged:(id)sender {
    self.seatsLabel.text = [NSString stringWithFormat:@"%d", (int)roundf(self.seats.value)];
}
- (IBAction)costSliderChanged:(id)sender {
    self.costsLabel.text = [NSString stringWithFormat:@"%d", (int)roundf(self.costs.value)];
}
- (IBAction)sourceLocationCalculator:(id)sender {
    // source latitude and longitude conversion
    NSString *source = [NSString stringWithFormat:@"%@", self.source.text];
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
            trip.sourcelat = [slat stringValue];
            NSNumber *slong = [NSNumber numberWithFloat:location.coordinate.longitude];
            trip.sourcelong = [slong stringValue];
          
        }
    }];
}

- (IBAction)destinationLocationCalculator:(id)sender {
    //destination latitude and longitude conversion
    NSString *destination = [NSString stringWithFormat:@"%@", self.destination.text];
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
            trip.destinationlat = [slat stringValue];
            NSNumber *slong = [NSNumber numberWithFloat:location.coordinate.longitude];
            trip.destinationlong = [slong stringValue];
        }
    }];
}

- (IBAction)location:(id)sender {
    
    if([[self.source text] isEqualToString:@""] ) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                            message: @"Enter Source Address"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    }else if([[self.destination text] isEqualToString:@""] ) {
        
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
    
    
    trip.seats = [NSString stringWithFormat:@"%d", (int)roundf(self.seats.value)];
    trip.cost = [NSString stringWithFormat:@"%d", (int)roundf(self.costs.value)];
    trip.tripDate = [NSString stringWithFormat:@"%@", [self.tripDate date]];
    trip.userId = self.user.userId;
    trip.sourceAddress = [NSString stringWithFormat:@"%@", self.source.text];
    trip.destinationAddress = [NSString stringWithFormat:@"%@", self.destination.text];

    
    
    NSDictionary *tripinfo = [NSDictionary dictionaryWithObjectsAndKeys:trip.seats,@"seats",trip.cost,@"cost",trip.tripDate,@"tripDate",trip.userId,@"userId",trip.sourcelat,@"sourcelat",trip.sourcelong,@"sourcelong", trip.destinationlat,@"destinationlat",trip.destinationlong,@"destinationlong",trip.sourceAddress,@"sourceAddress",trip.destinationAddress,@"destinationAddress",nil];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tripinfo options:kNilOptions error: nil];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/controller/saveTrip"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]]forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *resultstring = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
