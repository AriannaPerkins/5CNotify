//
//  LoginViewController.m
//  5CNotify
//
//  Created by Paige Garratt on 4/4/14.
//
//

#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface LoginViewController ()

@end

@implementation LoginViewController{
    UIColor *green;
    NSArray* schools;
}

- (id)init{
    self = [super init];
    if (self) {
        
        green = [UIColor colorWithRed: 95.0/ 255.0
                                green:(float) 190.0/ 255.0
                                 blue:(float) 20.0/ 255.0
                                alpha:1.0];
        self.view.backgroundColor = green;
        schools = [[NSArray alloc] initWithObjects:@"HMC", @"Scripps", @"Pitzer", @"Pomona", @"Pitzer", nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self goToTableView];
    }
    
    //Create login screen
    CGSize windowSize =self.view.frame.size;
    UILabel* notify = [[UILabel alloc] initWithFrame:CGRectMake(0, windowSize.height*.15, windowSize.width, windowSize.width*0.2)];
    notify.font = [UIFont fontWithName:@"Helvetica" size:40];
    notify.backgroundColor = [UIColor blackColor];
    notify.textColor = green;
    notify.textAlignment = NSTextAlignmentCenter;
    notify.text = @"5CNotify";
    UILabel* welcome = [[UILabel alloc] initWithFrame:CGRectMake(windowSize.width*.1, windowSize.height*.2, windowSize.width * 0.8, windowSize.height*0.3)];
    welcome.font = [UIFont fontWithName:@"Helvetica" size:12];
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.text = @"Welcome to 5CNotify, please sign in with Facebook below. \n \n We will only ask Facebook for your name. We will never post anything without your permission.";
    welcome.numberOfLines = 5;
    welcome.lineBreakMode = NSLineBreakByWordWrapping;
    
    UIButton* login = [[UIButton alloc] initWithFrame:CGRectMake(windowSize.width*.1, windowSize.height*.5, windowSize.width*.8, windowSize.height*.3)];
    login.backgroundColor = [UIColor blueColor];
    [login setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    login.titleLabel.textColor = [UIColor whiteColor];
    [login addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:welcome];
    [self.view addSubview:login];
    [self.view addSubview:notify];
    
}

-(void) goToTableView{
    [_parseProjectViewController openTableView];
}

-(void) loginButtonPressed{
    [PFFacebookUtils logInWithPermissions:@[@"basic_info"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"School" message:@"Please Pick Your School" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"HMC", @"Scripps", @"Pitzer", @"Pomona", @"Pitzer", nil];
            [alert show];
            [self goToTableView];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self goToTableView];
        }
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* schoolName = [schools objectAtIndex:buttonIndex];
    NSLog(@"School: %@", schoolName);
}

// Logged-in user experience
-(void)loginViewShowingLoggedInUser:(FBLoginView*) loginView{
    [_parseProjectViewController openTableView];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
