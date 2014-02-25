#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>

@implementation ParseStarterProjectViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib OR NOT
    
    //If using TableView uncomment this part
//    self.tableViewController = [[TableViewController alloc] init];
//    [self presentModalViewController:self.tableViewController animated:YES];
    
    //If using AddEvent uncomment this part
    self.eventViewController = [[AddEventViewController alloc] init];
    [self presentModalViewController:self.eventViewController animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
