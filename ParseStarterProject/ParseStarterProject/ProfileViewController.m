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
    
    //Profile Information goes here
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(window.width*.1, window.height*.1, window.width*.8, window.height*0.2)];
    name.font = [UIFont fontWithName:@"Helvetica" size:18];
    name.text = [NSString stringWithFormat:@"Name: %@", curr.username];
    
    [self.view addSubview:name];
    
    // Facebook logout button
    UIButton* logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(windowSize.width*.1, windowSize.height*.5, windowSize.width*.8, windowSize.width*.8*0.175)];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout_button.png"]
                     forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor clearColor];
    [logoutButton addTarget:self action:@selector(logoutButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoutButton];

}

- (void)logoutButtonTouchHandler:(id)sender  {
    [PFUser logOut]; // Log out
    
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
