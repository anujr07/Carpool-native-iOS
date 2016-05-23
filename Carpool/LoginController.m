//
//  LoginController.m
//  Carpool
//
//  Created by Anuj Shah on 12/13/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "LoginController.h"
#import "userLogin.h"
#import "CreateTripViewController.h"
#import "TripSearchViewController.h"

@interface LoginController (){
  
}
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUp:(id)sender {
}
- (IBAction)logIn:(id)sender {
   
    @try {
        
        if([[self.username text] isEqualToString:@""] ) {
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                                message: @"Enter Username"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            
            [controller addAction: alertAction];
            
            [self presentViewController: controller animated: YES completion: nil];
            
        }
        if([[self.password text] isEqualToString:@""]) {
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                                message: @"Enter Password"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            
            [controller addAction: alertAction];
            
            [self presentViewController: controller animated: YES completion: nil];
        }else{
        //= //[[userLogin alloc]init];
            
          //  user.username = self.username.text;
           // user.password = self.password.text;
            
            
            NSDictionary *loginfo = [NSDictionary dictionaryWithObjectsAndKeys:[self.username text],@"username",[self.password text],@"password",nil];
            
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:loginfo options:kNilOptions error:nil];
            
            NSURL *url = [NSURL URLWithString:@"http://localhost:8080/controller/login"];
            
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
            
            if ([response statusCode] >= 200 && [response statusCode] < 300){
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                if (jsonData) {
                    
                    
                id objects = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
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
               
            }else{
                //username and password does not match
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Error!"
                                                                                    message: @"Username or Password Does Not Match!"
                                                                             preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Okay"
                                                                      style: UIAlertActionStyleDestructive
                                                                    handler: ^(UIAlertAction *action) {
                                                                    }];
                
                [controller addAction: alertAction];
                
                [self presentViewController: controller animated: YES completion: nil];
                
            }
                }
        }
    }
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"login"]) {
        
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
