#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "AddEventViewController.h"
#import "TableViewController.h"
#import "EditEventViewController.h"

@implementation ParseStarterProjectViewController{
    TableViewController *tableViewController;
    AddEventViewController *eventViewController;
    LoginViewController *loginViewController;
    ProfileViewController* profileViewController;
    EditEventViewController* editEventViewController;
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
    self.view.backgroundColor = [UIColor blackColor];
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

    editEventViewController = [[EditEventViewController alloc] init];
    editEventViewController.parseProjectViewController = self;
    
    
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

-(void) loadAddEventView {
    eventViewController = [[AddEventViewController alloc] init];
    eventViewController.parseProjectViewController = self;
}

-(void) openAddEventView{
    [self.navigationController pushViewController:eventViewController animated:YES];
}

-(void) loadEditEventView {
    editEventViewController = [[EditEventViewController alloc] init];
    editEventViewController.parseProjectViewController = self;
}
-(void) openEditEventView {
    [self.navigationController pushViewController:editEventViewController animated:YES];
}

-(void) openTableView{
    [self.navigationController pushViewController:tableViewController animated:YES];
}

-(void) loadTableView{
    tableViewController = [[TableViewController alloc] init];
    tableViewController.parseProjectViewController = self;
}

-(void) openProfileView{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:profileViewController animated:NO];
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
