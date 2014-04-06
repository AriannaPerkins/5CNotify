@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *navController;

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) ParseStarterProjectViewController *viewController;

@property (nonatomic, retain) UINavigationController *navController;

@end
