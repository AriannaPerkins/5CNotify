@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *navController;

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;

@property (nonatomic, retain) UINavigationController *navController;

@end
