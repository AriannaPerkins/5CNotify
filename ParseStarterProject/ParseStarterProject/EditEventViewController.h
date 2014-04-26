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

@property(nonatomic,retain) NSString* objectid;

@property(retain) ParseStarterProjectViewController* parseProjectViewController;
-(id)initWith:(NSString*) objectid;

@end
