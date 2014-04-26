//
//  ProfileViewController.m
//  5CNotify
//
//  Created by Paige Garratt on 4/4/14.
//
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Event.h"
#import "EventCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UIColor* green;
    UIColor* lightGreen;
    
    NSInteger selected;
    NSMutableArray* parties;
    NSMutableArray* partiesAttending;
    NSCalendar *calendar;
    NSInteger comps;
    
    UITableView* eventsCreatedTable;
    UITableView* eventsAttendingTable;
    UIButton* eventsCreatedButton;
    UIButton* eventsCreatedEditButton;
    UIButton* eventsAttendingButton;
    
    CGSize window;
    
    BOOL eventsCreatedVisible;
    BOOL eventsAttendingVisible;
    
    BOOL editingEventsCreated;
}

- (id)init{
    self = [super init];
    if (self) {
        green = [UIColor colorWithRed: 95.0/ 255.0
                                green:(float) 190.0/ 255.0
                                 blue:(float) 20.0/ 255.0
                                alpha:1.0];
        lightGreen = [UIColor colorWithRed: 200.0/255.0
                                     green: 240.0/255.0
                                      blue: 160.0/255.0
                                     alpha: 1.0];

        self.view.backgroundColor = green;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    eventsCreatedVisible   = YES;
    eventsAttendingVisible = YES;
    editingEventsCreated   = NO;
    
    PFUser *curr = [PFUser currentUser];
    
    // Do any additional setup after loading the view.
    window = self.view.frame.size;
    
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
            UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(window.width*.1, window.height*.08, window.width*.8, window.height*0.2)];
            name.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
            name.text = username;
            name.textColor = [UIColor whiteColor];
            
            [self.view addSubview:name];
        }
    }];
    
    // Navigation Bar Title
    UILabel* profileLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    profileLabel.textAlignment = UITextAlignmentCenter;
    profileLabel.text=@"Profile";
    profileLabel.font=[UIFont fontWithName:@"Helvetica" size:25.0 ];
    profileLabel.textColor = green;
    
    [self.navigationItem setTitleView:profileLabel];
    
    // Log out button
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
    
    self.navigationItem.leftBarButtonItem = createItem;
    
    // Navigation back to the calendar view
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.rightBarButtonItem = backButton;
    
    // School Name
    NSString* schoolName = [curr objectForKey:@"school"];
    
    if (schoolName) {
        UIButton *school = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [school addTarget:self action:@selector(changeSchool)
         forControlEvents:UIControlEventTouchUpInside];
        [school setTitle:[NSString stringWithFormat:@"School: %@",schoolName]
                forState:UIControlStateNormal];
        school.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        school.tintColor = [UIColor whiteColor];
        school.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        school.frame = CGRectMake(window.width*.1, window.height*.2, window.width*.8, window.height*0.08);
        
        [self.view addSubview:school];
    } else {
        // Let users add/change their school
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(addSchool)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Add School" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        button.tintColor = [UIColor redColor];
        button.frame = CGRectMake(window.width*.1, window.height*.2, window.width*.8, window.height*0.08);
        [self.view addSubview:button];
    }
    
    NSMutableArray* eventsCreated = [curr objectForKey:@"eventsCreated"];
    NSMutableArray* eventsAttending = [curr objectForKey:@"eventsAttending"];
    
    if (eventsCreated) {
        
        eventsCreatedButton = [[UIButton alloc] initWithFrame:CGRectMake(0,window.height*0.3, window.width, window.height*0.05)];
        [eventsCreatedButton addTarget:self action:@selector(expandCreatedTable) forControlEvents:UIControlEventTouchUpInside];
        [eventsCreatedButton setTitle:@"Events Created" forState:UIControlStateNormal];
        eventsCreatedButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        eventsCreatedButton.tintColor = [UIColor whiteColor];
        eventsCreatedButton.backgroundColor = [UIColor blackColor];
        eventsCreatedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [self.view addSubview:eventsCreatedButton];
        
        eventsCreatedEditButton = [[UIButton alloc] initWithFrame:CGRectMake(window.width*0.86, window.height*0.3, window.width*0.12, window.height*0.05)];
        [eventsCreatedEditButton addTarget:self action:@selector(editEventsCreated) forControlEvents:UIControlEventTouchUpInside];
        [eventsCreatedEditButton setTitle:@"Edit" forState:UIControlStateNormal];
        eventsCreatedEditButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [eventsCreatedEditButton setTitleColor:green forState:UIControlStateNormal];
        eventsCreatedEditButton.backgroundColor = [UIColor blackColor];
        eventsCreatedEditButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.view addSubview:eventsCreatedEditButton];
        
        eventsCreatedTable = [[UITableView alloc] initWithFrame:CGRectMake(0, window.height*0.35, window.width, window.height*0.3)];
        eventsCreatedTable.backgroundColor = [UIColor blackColor];
        eventsCreatedTable.sectionHeaderHeight = 0;
        eventsCreatedTable.scrollEnabled = YES;
        eventsCreatedTable.scrollsToTop = YES;
        eventsCreatedTable.delegate = self;
        eventsCreatedTable.dataSource = self;
        eventsCreatedTable.separatorColor = [UIColor blackColor];
        
        parties = [[NSMutableArray alloc] init];
        
        // Pull all events that have a start date today or later
        NSDate *currentDate = [[NSDate alloc] init];
        
        calendar = [NSCalendar currentCalendar];
        comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents* currentDateComps = [calendar components:comps fromDate: currentDate];
        
        currentDate = [calendar dateFromComponents:currentDateComps];
        
        PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
        [query whereKey:@"objectId" containedIn:eventsCreated];
        [query whereKey:@"endTime" greaterThan:currentDate];
        
        NSMutableArray* tempParties = [[NSMutableArray alloc] init];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. Do something with the found objects.

                for (int i=0; i<objects.count; ++i) {
                    
                    PFObject *event = objects[i];
                    
                    NSString *name = event[@"eventName"];
                    NSString *location = event[@"locationText"];
                    NSDate *startTime = event[@"startTime"];
                    NSDate *endTime = event[@"endTime"];
                    NSString *description = event[@"description"];
                    NSMutableArray *switches = event[@"openTo"];
                    int rsvpCount = [event[@"rsvpCount"] intValue]; // get the rsvp count
                    NSString *objectid = event.objectId;
                    
                    Event* temp = [[Event alloc] initWith:name andLoc:location andStart:startTime andEnd:endTime andDescription:description andOpenTo:switches andRSVPCount:rsvpCount andObjectID:objectid];
                    [tempParties addObject:temp];
                }
                
                // Sorts events by date to later form sections
                NSDate *date = [NSDate date];
                NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
                date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
                NSDateComponents* components = [[NSDateComponents alloc] init];
                [components setDay:1];
                date = [calendar dateByAddingComponents:components toDate:date options:0];
                while (tempParties.count > 0) {
                    NSMutableArray *oneDay = [[NSMutableArray alloc] init];
                    for (NSInteger i=0; i<tempParties.count; i++) {
                        Event* temp = [tempParties objectAtIndex:i];
                        if (temp.start<date) {
                            [oneDay addObject:temp];
                            [tempParties removeObject:temp];
                            i--;
                        }
                    }
                    if (oneDay.count !=0) {
                        [parties addObject:oneDay];
                    }
                    date = [calendar dateByAddingComponents:components toDate:date options:0];
                }
                
                [eventsCreatedTable reloadData];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        [self.view addSubview:eventsCreatedTable];
    }
    
    if (eventsAttending) {

        eventsAttendingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, window.height*0.65, window.width, window.height*0.05)];
        eventsAttendingButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        [eventsAttendingButton addTarget:self action:@selector(expandAttendingTable) forControlEvents:UIControlEventTouchUpInside];
        [eventsAttendingButton setTitle:@"Events Attending" forState:UIControlStateNormal];
        eventsAttendingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        eventsAttendingButton.tintColor = [UIColor whiteColor];
        eventsAttendingButton.backgroundColor = [UIColor blackColor];
        
        [self.view addSubview:eventsAttendingButton];
        
        
        eventsAttendingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, window.height*0.70, window.width, window.height*0.3)];
        eventsAttendingTable.backgroundColor = [UIColor blackColor];
        eventsAttendingTable.sectionHeaderHeight = 0;
        eventsAttendingTable.scrollEnabled = YES;
        eventsAttendingTable.scrollsToTop = YES;
        eventsAttendingTable.delegate = self;
        eventsAttendingTable.dataSource = self;
        eventsAttendingTable.separatorColor = [UIColor blackColor];
        
        partiesAttending = [[NSMutableArray alloc] init];
        
        // Pull all events that have a start date today or later
        NSDate *currentDate = [[NSDate alloc] init];
        
        calendar = [NSCalendar currentCalendar];
        comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents* currentDateComps = [calendar components:comps fromDate: currentDate];
        
        currentDate = [calendar dateFromComponents:currentDateComps];
        
        PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
        [query whereKey:@"objectId" containedIn:eventsAttending];
        [query whereKey:@"endTime" greaterThan:currentDate];
        
        NSMutableArray* tempParties = [[NSMutableArray alloc] init];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                // The find succeeded. Do something with the found objects
                
                for (int i=0; i<objects.count; ++i) {
                    
                    PFObject *event = objects[i];
                    
                    NSString *name = event[@"eventName"];
                    NSString *location = event[@"locationText"];
                    NSDate *startTime = event[@"startTime"];
                    NSDate *endTime = event[@"endTime"];
                    NSString *description = event[@"description"];
                    NSMutableArray *switches = event[@"openTo"];
                    int rsvpCount = [event[@"rsvpCount"] intValue]; // get the rsvp count
                    NSString *objectid = event.objectId;
                    
                    Event* temp = [[Event alloc] initWith:name andLoc:location andStart:startTime andEnd:endTime andDescription:description andOpenTo:switches andRSVPCount:rsvpCount andObjectID:objectid];
                    [tempParties addObject:temp];
                }
                
                // Sorts events by date to later form sections
                NSDate *date = [NSDate date];
                NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
                date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
                NSDateComponents* components = [[NSDateComponents alloc] init];
                [components setDay:1];
                date = [calendar dateByAddingComponents:components toDate:date options:0];
                while (tempParties.count > 0) {
                    NSMutableArray *oneDay = [[NSMutableArray alloc] init];
                    for (NSInteger i=0; i<tempParties.count; i++) {
                        Event* temp = [tempParties objectAtIndex:i];
                        if (temp.start<date) {
                            [oneDay addObject:temp];
                            [tempParties removeObject:temp];
                            i--;
                        }
                    }
                    if (oneDay.count !=0) {
                        [partiesAttending addObject:oneDay];
                    }
                    date = [calendar dateByAddingComponents:components toDate:date options:0];
                }
                
                [eventsAttendingTable reloadData];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }}];
        
        
        [self.view addSubview:eventsAttendingTable];
    
    }
    
}
-(void)viewDidAppear:(BOOL) animated
{
    // Briefly flash scroll bar indicators to viewer after 0.5 seconds
    [super viewDidAppear:animated];
    [eventsCreatedTable performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.5];
    [eventsAttendingTable performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.5];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are editing events created...
    if (editingEventsCreated) {
        // And looking at the events created table
        if (tableView == eventsCreatedTable) {
            if ((indexPath.row + indexPath.section) % 2 == 0) {
                cell.backgroundColor = [UIColor grayColor];
            } else {
                cell.backgroundColor = [UIColor lightGrayColor];
            }
        }
    } else {
        if  ((indexPath.row + indexPath.section) % 2 == 0) {
            cell.backgroundColor = green;
        } else {
            cell.backgroundColor = lightGreen;
        }
    }
}


// Return from Profile View to Table View
- (IBAction) Back
{
    [_parseProjectViewController loadTableView];
    [_parseProjectViewController openTableView];
}


// Expands or collapses the events created table view
- (void) expandCreatedTable {
    if (eventsCreatedVisible) {
        // Collapse the events created table
        CGRect newFrame = eventsCreatedTable.frame;
        newFrame.size.height = 0;
        [UIView animateWithDuration:0.25 animations:^(void){
            eventsCreatedTable.frame = newFrame;
        }];
        eventsCreatedVisible = NO;
        
        // Cannot edit in collapsed view
        [eventsCreatedEditButton removeFromSuperview];
        
        // Move events attending button up
        newFrame = eventsAttendingButton.frame;
        newFrame.origin.y = window.height*0.35;
        [UIView animateWithDuration:0.25 animations:^(void){
            eventsAttendingButton.frame = newFrame;
        }];
        
        
        if (eventsAttendingVisible) {
            // Move the events attending table up
            newFrame = eventsAttendingTable.frame;
            newFrame.origin.y = window.height*0.40;
            newFrame.size.height = window.height*0.59;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingTable.frame = newFrame;
            }];

        } else {
            // Move the events attending table up
            newFrame = eventsAttendingTable.frame;
            newFrame.origin.y = window.height*0.40;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingTable.frame = newFrame;
            }];
        }
    } else {

        eventsCreatedVisible = YES;

        // Users can edit in expanded view
        [self.view addSubview:eventsCreatedEditButton];
        
        if (eventsAttendingVisible) {
            //Expand the events created table
            CGRect newFrame = eventsCreatedTable.frame;
            newFrame.size.height = window.height*0.3;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsCreatedTable.frame = newFrame;
            }];
            
            // Move events attending button down
            newFrame = eventsAttendingButton.frame;
            newFrame.origin.y = window.height*0.65;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingButton.frame = newFrame;
            }];
            
            // Move the events attending table down
            newFrame = eventsAttendingTable.frame;
            newFrame.origin.y = window.height*0.7;
            newFrame.size.height = window.height*0.3;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingTable.frame = newFrame;
            }];

        } else {
            //Expand the events created table
            CGRect newFrame = eventsCreatedTable.frame;
            newFrame.size.height = window.height*0.65;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsCreatedTable.frame = newFrame;
            }];
            
            // Move button down
            newFrame = eventsAttendingButton.frame;
            newFrame.origin.y = window.height*0.95;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingButton.frame = newFrame;
            }];
            
            // Move the events attending table down
            newFrame = eventsAttendingTable.frame;
            newFrame.origin.y = window.height*0.7;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingTable.frame = newFrame;
            }];
        }
    }
}

// Expands or collapses the events attending table view
- (void) expandAttendingTable {
    if(eventsAttendingVisible) {
        // Collapse the events attending table
        CGRect newFrame = eventsAttendingTable.frame;
        newFrame.size.height = 0;
        [UIView animateWithDuration:0.25 animations:^(void){
            eventsAttendingTable.frame = newFrame;
        }];
        eventsAttendingVisible = NO;
        
        if (eventsCreatedVisible) {
            // Move button down
            newFrame = eventsAttendingButton.frame;
            newFrame.origin.y = window.height*0.95;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingButton.frame = newFrame;
            }];

            // Grow the events created table
            CGRect newFrame = eventsCreatedTable.frame;
            newFrame.size.height = window.height*0.6;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsCreatedTable.frame = newFrame;
            }];
        }
        
    } else {

        eventsAttendingVisible = YES;

        if (eventsCreatedVisible) {
            // Expand the events attending table
            CGRect newFrame = eventsAttendingTable.frame;
            newFrame.size.height = window.height*0.3;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingTable.frame = newFrame;
            }];

            // Move button up
            newFrame = eventsAttendingButton.frame;
            newFrame.origin.y = window.height*0.65;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingButton.frame = newFrame;
            }];
            
            // Shrink the events created table
            newFrame = eventsCreatedTable.frame;
            newFrame.size.height = window.height*0.3;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsCreatedTable.frame = newFrame;
            }];
        } else {
            // Expand the events attending table
            CGRect newFrame = eventsAttendingTable.frame;
            newFrame.origin.y = window.height*0.40;
            newFrame.size.height = window.height*0.59;
            [UIView animateWithDuration:0.25 animations:^(void){
                eventsAttendingTable.frame = newFrame;
            }];
        }
    }
    
}


// Turn on and off editing for the events created view
- (void) editEventsCreated
{
    if (!editingEventsCreated) {
        editingEventsCreated = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Events Created" message:@"Select an event in the events created table to edit or delete it." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", @"Cancel", nil];
        alert.tag = 3;
        [alert show];
    } else {
        // Done editing, reset values
        editingEventsCreated = NO;
        [eventsCreatedEditButton setTitle:@"Edit" forState:UIControlStateNormal];
        [eventsCreatedTable reloadData];
    }
    
}

// Change school method: pops up an alert view
- (void)changeSchool {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit School" message:@"Select a school from the list below to change your school. Please note that this will change what parties are available for you to select to attend." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"HMC", @"Scripps", @"Pitzer", @"Pomona", @"CMC", @"Other", nil];
    alert.tag = 2;
    [alert show];
}

// Add school method: pops up an alert view
- (void)addSchool {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit School" message:@"Select a school from the list below to add your school." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"HMC", @"Scripps", @"Pitzer", @"Pomona", @"CMC", @"Other", nil];
    alert.tag = 2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Updating user school
    if (alertView.tag == 2) {
        NSArray* schools = [[NSArray alloc] initWithObjects:@"HMC", @"Scripps", @"Pitzer", @"Pomona", @"CMC", @"Other", nil];
        NSString* schoolName;
        if (buttonIndex != [alertView cancelButtonIndex]) {
            // Off by one error since Cancel button is technically "first"
            schoolName = [schools objectAtIndex:buttonIndex-1];
            PFUser* user = [PFUser currentUser];
            [user setObject:schoolName forKey:@"school"];
            [user saveInBackground];
            [_parseProjectViewController loadProfileView];
            [_parseProjectViewController openProfileView];

        } // Otherwise, clicked cancel: do nothing
    }
    
    // Selected an edit tag
    if (alertView.tag == 3) {
        
        // Clicked OK
        if (buttonIndex == 0) {
            [eventsCreatedEditButton setTitle:@"Done" forState:UIControlStateNormal];
            editingEventsCreated = YES;

            [eventsCreatedTable reloadData];
        }
    }
}

- (void)logoutButtonTouchHandler:(id)sender  {
    [PFUser logOut]; // Log out from Parse
    
    // Return to login page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == eventsCreatedTable) {
        return parties.count;
    } else {
        return partiesAttending.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == eventsCreatedTable) {
        NSMutableArray* temp = [parties objectAtIndex:section];
        return temp.count;
    } else {
        NSMutableArray* temp = [partiesAttending objectAtIndex:section];
        return temp.count;
    }
}

- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    [tableView registerClass: [EventCell class] forCellReuseIdentifier:CellIdentifier];
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:2.0f];
    
    //Tag cannot be 0 because they are default 0, set it to the row plus 1
    cell.tag = ((indexPath.section<<16) | indexPath.row)+1;
    
    NSMutableArray* day;
    if (tableView == eventsCreatedTable) {
        day = [parties objectAtIndex:indexPath.section];
    }
    if (tableView == eventsAttendingTable) {
        day = [partiesAttending objectAtIndex:indexPath.section];
    }
    Event* party = [day objectAtIndex:indexPath.row];
    
    if ((indexPath.row+indexPath.section) % 2 == 0) {
        cell.backgroundColor = green;
    } else {
        cell.backgroundColor = lightGreen;
    }
    
    cell.eventNameLabel.text = party.name;
    cell.locationLabel.text = party.location;
    
    NSMutableString* stringOpenTo = [[NSMutableString alloc] init];
    if (party.openToArray.count > 0) {
        // Make openTo a copy of the party.openToArray
        NSMutableArray* openTo = [NSMutableArray array];
        [openTo addObjectsFromArray:party.openToArray];
        while (openTo.count>0) {
            NSString* temp = [openTo objectAtIndex:0];
            if (openTo.count == 1)
                [stringOpenTo appendString:temp];
            else
                [stringOpenTo appendString:[NSString stringWithFormat:@"%@, ", temp]];
            [openTo removeObjectAtIndex:0];
        }
    } else{
        [stringOpenTo appendString:@"Private Party"];
    }
    cell.switchesLabel.text = stringOpenTo;
    
    // Set the scope of the party
    cell.openToArray = party.openToArray;
    [cell setPartyScope];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd hh:mm aa"];
    
    NSDate* startTime = party.start;
    NSDate* endTime = party.end;
    NSString *startDateString = [dateFormat stringFromDate: startTime];
    NSString *endDateString   = [dateFormat stringFromDate: endTime];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ to %@", startDateString, endDateString];
    cell.descriptionLabel.text = party.description;
    cell.objectid = party.objectid;
    [cell setUpRSVP];
    
    [cell setCheckMark];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (((indexPath.section<<16) | indexPath.row)+1 == selected) {
        //Sets height based on how large description is
        Event* selectedEvent = [parties objectAtIndex:indexPath.row];
        if (tableView == eventsAttendingTable) {
            selectedEvent = [partiesAttending objectAtIndex:indexPath.row];
        }
        NSString *text = selectedEvent.description;
        CGSize constraint = CGSizeMake(260, 100);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint];
        CGFloat height = 75 + (size.height*0.5);
        
        return height;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!editingEventsCreated) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop-tableView.sectionHeaderHeight animated:NO];
        EventCell* cell = (EventCell*)[tableView viewWithTag:((indexPath.section<<16)|indexPath.row)+1];
        //Check if already selected
        if (selected == cell.tag){
            selected=NSIntegerMin;
            cell.descriptionLabel.hidden = YES;
        }else{
            selected = cell.tag;
            cell.descriptionLabel.hidden = NO;
        }
        [tableView beginUpdates];
        [tableView endUpdates];
    } else {
        NSLog(@"We're going to edit the cell that was selected now... load a new view controller");
        NSLog(@"Row selected: %ld, Section selected: %ld", (long)indexPath.row, (long)indexPath.section);
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Get date and format it nicely
    NSMutableArray* temp = [parties objectAtIndex:section];
    Event* firstEvent = [temp objectAtIndex:0];
    NSDate* today = firstEvent.start;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString* niceDate = [formatter stringFromDate:today];
    
    //Create view
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tableView.sectionHeaderHeight)];
    header.backgroundColor = [UIColor blackColor];
    UILabel* date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, header.frame.size.width, tableView.sectionHeaderHeight-5)];
    date.textAlignment = NSTextAlignmentCenter;
    date.textColor = green;
    date.text = niceDate;
//    [header addSubview:date];
    
    return header;
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
