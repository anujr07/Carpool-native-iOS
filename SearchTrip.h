//
//  SearchTrip.h
//  Carpool
//
//  Created by Anuj Shah on 12/17/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTrip : NSObject

@property(nonatomic,strong)NSString * searchSourceLat;
@property(nonatomic,strong)NSString * searchSourceLong;
@property(nonatomic,strong)NSString * searchDestinationLat;
@property(nonatomic,strong)NSString * searchDestinationLong;
@property(nonatomic,strong)NSString * searchDate;

@end
