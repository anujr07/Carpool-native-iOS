//
//  SearchResultTableViewController.h
//  Carpool
//
//  Created by Anuj Shah on 12/18/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

//send search result

@property NSMutableArray *dataToMap;

-(NSString*)calculateLat:(NSString*)lat andLong:(NSString*)Long;

@end
