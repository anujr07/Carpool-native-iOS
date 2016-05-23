//
//  ViewController.h
//  Carpool
//
//  Created by Anuj Shah on 12/13/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userLogin.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *streetAddress;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;
@property (weak, nonatomic) IBOutlet UISwitch *carStatus;

@property userLogin* user;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end

