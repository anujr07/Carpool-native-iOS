//
//  Trip.h
//  Carpool
//
//  Created by Anuj Shah on 12/15/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject


@property(nonatomic,strong)NSString * tripId;
@property(nonatomic,strong)NSString * seats;
@property(nonatomic,strong)NSString * cost;
@property(nonatomic,strong)NSString * tripDate;
@property(nonatomic,strong)NSString * sourcelat;
@property(nonatomic,strong)NSString * sourcelong;
@property(nonatomic,strong)NSString * destinationlat;
@property(nonatomic,strong)NSString * destinationlong;
@property(nonatomic,strong)NSString * userId;
@property(nonatomic,strong)NSString * sourceAddress;
@property(nonatomic,strong)NSString * destinationAddress;
@end
