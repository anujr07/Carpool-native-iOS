//
//  FlipSegue.m
//  Carpool
//
//  Created by Anuj Shah on 12/16/15.
//  Copyright © 2015 Anuj Shah. All rights reserved.
//

#import "FlipSegue.h"

@implementation FlipSegue
- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}
@end
