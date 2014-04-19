//
//  AddEventViewController.h
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

@class ParseStarterProjectViewController;

#import <UIKit/UIKit.h>
#import "ParseStarterProjectViewController.h"

@interface AddEventViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property(retain) ParseStarterProjectViewController* parseProjectViewController;

@end
