//
//  TableViewController.h
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

@class ParseStarterProjectViewController;

#import <UIKit/UIKit.h>
#import "ParseStarterProjectViewController.h"
#import "EventCell.h"

@interface TableViewController : UITableViewController

@property(retain) ParseStarterProjectViewController* parseProjectViewController;

@end
