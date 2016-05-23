//
//  ViewController.m
//  Carpool
//
//  Created by Anuj Shah on 12/13/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "ViewController.h"
#import "Signup.h"
#import "CreateTripViewController.h"
#import "TripSearchViewController.h"

@interface ViewController (){
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUp:(id)sender {
    if([[self.name text] isEqualToString:@""]  || [[self.userName text] isEqualToString:@""] || [[self.password text] isEqualToString:@""] || [[self.streetAddress text] isEqualToString:@""] || [[self.city text] isEqualToString:@""] || [[self.state text] isEqualToString:@""] || [[self.zip text] isEqualToString:@""]){
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                            message: @"Enter values in all fields"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    }else{
    
    Signup* signup = [[Signup alloc]init];
    
    signup.name = self.name.text;
    signup.username = self.userName.text;
    signup.password = self.password.text;
    signup.street = self.streetAddress.text;
    signup.city = self.city.text;
    signup.state =self.state.text;
    signup.zip = self.zip.text;
    
    if (self.gender.selectedSegmentIndex == 0) {
        signup.gender = @"Male";
    }    else if (self.gender.selectedSegmentIndex == 1) {
        signup.gender = @"Female";
    }
        
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys: signup.name,@"name",signup.username,@"username",signup.password,@"password",signup.street,@"street",signup.city,@"city",signup.state,@"state",signup.zip,@"zip",signup.gender,@"gender",nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
    
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/controller/signup"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%ul",(unsigned)[jsonData length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:jsonData];

    NSHTTPURLResponse *response = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *resultstring = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    //NSLog(resultstring);
    
    if ([response statusCode] >= 200 && [response statusCode] < 300){
        NSString *responseData = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:result
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        id objects = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        
        self.user = [[userLogin alloc]init];
        
        self.user.username =[objects objectForKey:@"username"];
        self.user.password =[objects objectForKey:@"password"];
        self.user.name = [objects objectForKey:@"name"];
        self.user.street = [objects objectForKey:@"street"];
        self.user.city = [objects objectForKey:@"city"];
        self.user.state = [objects objectForKey:@"state"];
        self.user.zip = [objects objectForKey:@"zip"];
        self.user.gender = [objects objectForKey:@"gender"];
        
        self.user.userId = [objects objectForKey:@"userId"];
        
    }
    }}

    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([[segue identifier]isEqualToString:@"signup"]) {
            
            UITabBarController* tab = [segue destinationViewController];
            
            UINavigationController* tabatindex0 = [tab.viewControllers objectAtIndex:0];
            CreateTripViewController* create = [tabatindex0 topViewController];
            [create setUser:self.user];
            
            UINavigationController* tabatindex1 = [tab.viewControllers objectAtIndex:1];
            TripSearchViewController* search = [tabatindex1 topViewController];
            [search setUser:self.user];
        }
    }
    

@end
