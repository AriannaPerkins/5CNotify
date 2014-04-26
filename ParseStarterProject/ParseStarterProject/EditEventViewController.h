//
//  EditEventViewController.h
//  5CNotify
//
//  Created by Arianna Perkins on 4/26/14.
//
//

@class ParseStarterProjectViewController;

#import <UIKit/UIKit.h>
#import "ParseStarterProjectViewController.h"

@interface EditEventViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property(retain) ParseStarterProjectViewController* parseProjectViewController;

@end
