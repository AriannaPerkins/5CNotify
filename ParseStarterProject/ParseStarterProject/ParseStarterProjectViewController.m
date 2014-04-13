#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "AddEventViewController.h"
#import "TableViewController.h"

@implementation ParseStarterProjectViewController{
    TableViewController *tableViewController;
    AddEventViewController *eventViewController;
    LoginViewController *loginViewController;
    ProfileViewController* profileViewController;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Default.png"]];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:background];
    
}

-(void)viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib OR NOT
    
    // Make view controllers    
    eventViewController = [[AddEventViewController alloc] init];
    eventViewController.parseProjectViewController = self;
    
    loginViewController = [[LoginViewController alloc] init];
    loginViewController.parseProjectViewController = self;
    
    //This does not actually make the switch...
    FBSession* currentSession = [PFFacebookUtils session];
    if (currentSession.accessTokenData.accessToken) {
        [self loadTableView];
        [self loadProfileView];
        [self.navigationController pushViewController:tableViewController animated:NO];
    }else{
        [self.navigationController pushViewController:loginViewController animated:NO];
    }
}

-(void) openAddEventView{
    [self.navigationController pushViewController:eventViewController animated:YES];
}

-(void) openTableView{
    [self.navigationController pushViewController:tableViewController animated:YES];
}

-(void) loadTableView{
    tableViewController = [[TableViewController alloc] init];
    tableViewController.parseProjectViewController = self;
}

-(void) openProfileView{
    [self.navigationController pushViewController:profileViewController animated:YES];
}

-(void) loadProfileView{
    profileViewController = [[ProfileViewController alloc] init];
    profileViewController.parseProjectViewController = self;
}

-(void) openLoginView{
    [self.navigationController pushViewController:loginViewController animated:YES];
}

-(void) pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
