//
//  BookTripViewController.m
//  Carpool
//
//  Created by Anuj Shah on 12/18/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "BookTripViewController.h"

@interface BookTripViewController ()

@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation BookTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.source.text = self.trip.sourceAddress;
    self.destination.text = self.trip.destinationAddress;
    self.cost.text = self.trip.cost;
    self.date.text = self.trip.tripDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)book:(id)sender {
    NSDictionary *loginfo = [NSDictionary dictionaryWithObjectsAndKeys:self.trip.userId,@"userId",self.trip.tripId,@"tripId",nil];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:loginfo options:kNilOptions error:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/controller/saveBooking"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]]forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"Response code: %ld", (long)[response statusCode]);

    [self performSegueWithIdentifier:@"redirect" sender:self];

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
