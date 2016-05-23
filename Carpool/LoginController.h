//
//  LoginController.h
//  Carpool
//
//  Created by Anuj Shah on 12/13/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userLogin.h"

@interface LoginController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property userLogin* user;
@end
