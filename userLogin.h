//
//  userLogin.h
//  Carpool
//
//  Created by Anuj Shah on 12/14/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userLogin : NSObject

@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,strong)NSString *street;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *zip;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic)BOOL *car;

@end
