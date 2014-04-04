//
//  LoginViewController.h
//  5CNotify
//
//  Created by Paige Garratt on 4/4/14.
//
//

@class ParseStarterProjectViewController;
#import <UIKit/UIKit.h>
#import "ParseStarterProjectViewController.h"
# import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property(retain) ParseStarterProjectViewController* parseProjectViewController;

@end
