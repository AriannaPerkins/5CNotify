//
//  ProfileViewController.m
//  5CNotify
//
//  Created by Paige Garratt on 4/4/14.
//
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UIColor* green;
}

- (id)init{
    self = [super init];
    if (self) {
        green = [UIColor colorWithRed: 95.0/ 255.0
                                green:(float) 190.0/ 255.0
                                 blue:(float) 20.0/ 255.0
                                alpha:1.0];
        self.view.backgroundColor = green;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *curr = [PFUser currentUser];
    
    // Do any additional setup after loading the view.
    CGSize window = self.view.frame.size;
    CGSize windowSize =self.view.frame.size;
    
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {

            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *username = userData[@"name"];
            
            // Now add the data to the UI elements

            //Profile Information goes here
            UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(window.width*.1, window.height*.1, window.width*.8, window.height*0.2)];
            name.font = [UIFont fontWithName:@"Helvetica" size:18];
            name.text = [NSString stringWithFormat:@"Name: %@", username];
            
            [self.view addSubview:name];
        }
    }];
    
    NSString* schoolName = [curr objectForKey:@"school"];
    if (schoolName) {
        UILabel* school = [[UILabel alloc] initWithFrame:CGRectMake(window.width*.1, window.height*.2, window.width*.8, window.height*0.2)];
        school.font = [UIFont fontWithName:@"Helvetica" size:18];
        school.text = [NSString stringWithFormat:@"School: %@", schoolName];
        [self.view addSubview:school];
    }
    
    // Facebook logout button
    UIButton* logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(windowSize.width*.1, windowSize.height*.5, windowSize.width*.8, windowSize.width*.8*0.175)];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout_button.png"]
                     forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor clearColor];
    [logoutButton addTarget:self action:@selector(logoutButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoutButton];

}

- (void)logoutButtonTouchHandler:(id)sender  {
    // Log out from Facebook session, if we want to do that...
//    [[PFFacebookUtils session] closeAndClearTokenInformation];
//    [[PFFacebookUtils session] close];
//    [[FBSession activeSession] closeAndClearTokenInformation];
//    [[FBSession activeSession] close];
//    [FBSession setActiveSession:nil];
    
    [PFUser logOut]; // Log out from Parse
    
    // Return to login page
    [self.navigationController popToRootViewControllerAnimated:YES];
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
