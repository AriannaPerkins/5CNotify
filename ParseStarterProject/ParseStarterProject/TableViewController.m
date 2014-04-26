//
//  TableViewController.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "TableViewController.h"
#import <Parse/Parse.h>
#import "Event.h"

@interface TableViewController ()

@end

@implementation TableViewController

// Global variables (get initialized in initWithStyle)
UIColor* green;
UIColor* lightGreen;
UIColor* lightlightGreen;
UIFont* helvet15;

NSInteger selected;
NSMutableArray* parties;
NSMutableArray* collapsedSections;
NSCalendar *calendar;
NSInteger comps;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        //Set global variables
        green = [UIColor colorWithRed: 95.0/ 255.0
                                green:(float) 190.0/ 255.0
                                 blue:(float) 20.0/ 255.0
                                alpha:1.0];
        lightGreen = [UIColor colorWithRed: 200.0/255.0
                                     green: 240.0/255.0
                                      blue: 160.0/255.0
                                     alpha: 1.0];
        lightlightGreen = [UIColor colorWithRed: 172.0/255.0
                                          green: 225.0/255.0
                                           blue: 115.0/255.0
                                          alpha: 1.0];
        helvet15 = [UIFont fontWithName:@"Helvetica" size:15.0 ];
        
        selected = NSIntegerMin;
        
        //Set variables about the view
        self.tableView.sectionHeaderHeight = 30;
        self.tableView.scrollEnabled = YES;
        self.tableView.scrollsToTop = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.tableView.bounces = NO;
        
        self.view.backgroundColor = [UIColor blackColor];
        self.tableView.separatorColor = [UIColor blackColor];
        parties = [[NSMutableArray alloc] init];
        collapsedSections = [[NSMutableArray alloc] init];
        
        // Pull all events that have a start date today or later
        NSDate *currentDate = [[NSDate alloc] init];
        
        calendar = [NSCalendar currentCalendar];
        comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents* currentDateComps = [calendar components:comps fromDate: currentDate];
        
        currentDate = [calendar dateFromComponents:currentDateComps];
        
        PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
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
                
                //Make a date
                NSDate *date = [NSDate date];
                NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
                NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
                date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
                NSDateComponents* components = [[NSDateComponents alloc] init];
                [components setDay:1];
                date = [calendar dateByAddingComponents:components toDate:date options:0];
                
                while (tempParties.count > 0) {
                    
                    //If event is on this date add to the oneDay array to be added to parties
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
                [self.tableView reloadData];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create pull to refresh functionality
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = green;
    [refreshControl addTarget:self action:@selector(refreshEvents) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    //Make + button for navigation bar
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEventView)];
    
    //Make profile button for navigation bar
    UIImage* profile = [UIImage imageNamed:@"profile_pic.png"];
    UIImage* scaledProfile = [UIImage imageWithCGImage:[ profile CGImage] scale:25 orientation:profile.imageOrientation];
    UIButton* tempProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempProfileButton.bounds = CGRectMake(0, 0, scaledProfile.size.width, scaledProfile.size.height);
    [tempProfileButton setImage:scaledProfile forState:UIControlStateNormal];
    [tempProfileButton addTarget:self action:@selector(profileView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithCustomView:tempProfileButton];
    
    self.navigationItem.rightBarButtonItem = addItem;
    self.navigationItem.leftBarButtonItem = profileItem;
    
    //Make title of navigation bar
    UILabel* notifyLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    notifyLabel.textAlignment = UITextAlignmentCenter;
    notifyLabel.text=@"5CNotify";
    notifyLabel.font=[UIFont fontWithName:@"Helvetica" size:25.0 ];
    notifyLabel.textColor = green;
    
    [self.navigationItem setTitleView:notifyLabel];
    [self.navigationItem setHidesBackButton:YES animated:YES];

}

-(void) refreshEvents{
    
    NSDate* currentDate = [[NSDate alloc] init];
    
    //Query for all events that end after the current time
    PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
    [query whereKey:@"endTime" greaterThan:currentDate];
    
    //Array to store events that need to be added
    NSMutableArray* tempParties = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            
            // Create event objects for each event found
            
            for (int i=0; i<objects.count; ++i) {
                
                PFObject *event = objects[i];
                
                NSString *name = event[@"eventName"];
                NSString *location = event[@"locationText"];
                NSDate *startTime = event[@"startTime"];
                NSDate *endTime = event[@"endTime"];
                NSString *description = event[@"description"];
                NSMutableArray *switches = event[@"openTo"];
                int rsvpCount = [event[@"rsvpCount"] intValue];
                NSString *objectid = event.objectId;
                
                Event* temp = [[Event alloc] initWith:name andLoc:location andStart:startTime andEnd:endTime andDescription:description andOpenTo:switches andRSVPCount:rsvpCount andObjectID:objectid];
                
                //If the event is new add it to tempParties to be added into data
                BOOL newEvent = YES;
                for (NSMutableArray* day in parties){
                    for (Event* cell in day){
                        if ([cell.objectid isEqualToString:temp.objectid]){
                            newEvent = NO;
                            break;
                        }
                    }
                }
                if (newEvent){
                    [tempParties addObject:temp];
                }
            }
            
            
            // Sorts events by date
            int i=0;
            [self.tableView beginUpdates];
            while (tempParties.count > 0) {
                //If the party starts on a new day after the last party in our local data
                if (i>=parties.count) {
                    Event* sortee = tempParties[0];
                    
                    //Remove object from tempParties and add it to local data parties
                    NSMutableArray* newDay = [[NSMutableArray alloc] init];
                    [newDay addObject:sortee];
                    [tempParties removeObject:sortee];
                    [parties insertObject:newDay atIndex:i];
                    
                    //Add new section and row into the table for this new event
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationAutomatic];
                    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:i];
                    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                //Grab first event to get start time from and increment off of
                Event* temp = [[parties objectAtIndex:i] objectAtIndex:0];
                NSDate* curr = temp.start;
                NSDateComponents* currentComps = [calendar components:comps fromDate:curr];
                curr = [calendar dateFromComponents: currentComps];
                
                //Go through all the parties in tempParties
                for (int n=0; n<tempParties.count; n++) {
                    Event* sortee =tempParties[n];
                    NSDate* start = sortee.start;
                    NSDateComponents* startComps = [calendar components:comps fromDate:start];
                    start = [calendar dateFromComponents: startComps];
                    
                    //If the event starts on the current day
                    if (start == curr) {
                        
                        //Sort event into correct place in day based on start time
                        NSMutableArray* day = [parties objectAtIndex:i];
                        for (int j=0; j<day.count; j++){
                            Event* event = [day objectAtIndex:j];
                            if (sortee.start < event.start){
                                
                                //Add row to tableview
                                [day insertObject:sortee atIndex:j];
                                NSIndexPath* path = [NSIndexPath indexPathForRow:(unsigned long)j inSection:i];
                                [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                                [self redoColoringForSection:i];
                                break;
                            }
                        }
                        
                        n--;
                        [tempParties removeObject:sortee];
                        
                    //If the event starts on a new date
                    } else if (start < curr){
                        
                        //Add new day with object to local data and remove event from tempParties
                        NSMutableArray* newDay = [[NSMutableArray alloc] init];
                        [newDay addObject:sortee];
                        [tempParties removeObject:sortee];
                        [parties insertObject:newDay atIndex:i];
                        
                        //Insert section and row into tableview
                        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationAutomatic];
                        NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:i];
                        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                        n--;
                        i--;
                    }
                }
                ++i;
            }
            
            //Update RSVP data in all cells of table
            NSArray* cells = [self.tableView visibleCells];
            for (EventCell* cell in cells) {
                [cell updateRSVPText];
            }
            
            [self.tableView endUpdates];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }}];
    
    [self.refreshControl endRefreshing];

}

-(void) addEventView{
    [_parseProjectViewController loadAddEventView];
    [_parseProjectViewController openAddEventView];
}

-(void) profileView{
    [_parseProjectViewController loadProfileView];
    [_parseProjectViewController openProfileView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When section header is pressed
-(void)sectionButtonTouchUpInside:(UIButton*)sender {
    [self.tableView beginUpdates];
    int section = (int)sender.tag;
    bool shouldCollapse = ![collapsedSections containsObject:@(section)];
    if (shouldCollapse) {
        int numOfRows = (int)[self.tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [collapsedSections addObject:@(section)];
    } else {
        NSMutableArray* temp = [[NSMutableArray alloc] init];
        temp = [parties objectAtIndex:section];
        int numOfRows = (int)temp.count;
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [collapsedSections removeObject:@(section)];
    }
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return parties.count;
}

-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    if ([collapsedSections containsObject:@(section)]) {
        temp = 0;
    } else {
        temp = [parties objectAtIndex:section];
    }
    return temp.count;
}

- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make a generic event cell
    static NSString *CellIdentifier = @"EventCell";
    [self.tableView registerClass: [EventCell class] forCellReuseIdentifier:CellIdentifier];
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Make cell into rounded rect shape
    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:2.0f];
    
    //Tag cannot be 0 because they are default 0, this bit shifting gives a unique integer
    cell.tag = ((indexPath.section<<16) | indexPath.row)+1;
    
    NSMutableArray* day = [parties objectAtIndex:indexPath.section];
    Event* party = [day objectAtIndex:indexPath.row];
    
    if ((indexPath.row+indexPath.section) % 2 == 0) {
        cell.backgroundColor = green;
    } else {
        cell.backgroundColor = lightGreen;
    }
    
    cell.eventNameLabel.text = party.name;
    cell.locationLabel.text = party.location;
    
    //Make string with openTo list
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
    
    cell.objectid = party.objectid;
    [cell setCheckMark];
    
    //Make pretty dates
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterNoStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate* startTime = party.start;
    NSDate* endTime = party.end;
    NSString *startDateString = [dateFormat stringFromDate: startTime];
    NSString *endDateString   = [dateFormat stringFromDate: endTime];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ to %@", startDateString, endDateString];
    cell.descriptionLabel.text = party.description;
    cell.objectid = party.objectid;
    [cell setUpRSVP];
    [cell setChecked];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //If cell is selected, make it as large as the description text it must fit
    if (((indexPath.section<<16) | indexPath.row)+1 == selected) {
        //Sets height based on how large description is
        Event* selectedEvent = [self getEventAtIndexPath:indexPath];
        NSString *text = selectedEvent.description;
        CGSize constraint = CGSizeMake(260, 100);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint];
        CGFloat height = 80 + (size.height);
        
        return height;
    }
    
    //All other cells are this height
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell* cell = (EventCell*)[self.tableView viewWithTag:((indexPath.section<<16)|indexPath.row)+1];
    //Scroll to cell
//    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
//    double diff = (rect.origin.y-self.navigationController.navigationBar.frame.origin.y)/500;
//    NSLog(@"navigation %f, rect %f, diff, %f", self.navigationController.navigationBar.frame.origin.y, rect.origin.y, diff);
//    [UIView animateWithDuration: diff
//                     animations: ^{
//                         [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                     }completion: ^(BOOL finished){
//                     }
//     ];
    
//    [UIView animateWithDuration:diff animations:^{
//        //Move table view to where you want
//        [tableView setContentOffset:rect.origin];
//    } completion:^(BOOL finished){
//    }];
    
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    if (selected == cell.tag){
        selected=NSIntegerMin;
        cell.descriptionLabel.hidden = YES;
    }else{
        selected = cell.tag;
        cell.descriptionLabel.hidden = NO;
    }
    
    //Make animation happen
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Get date for this section and format it nicely
    NSMutableArray* temp = [parties objectAtIndex:section];
    Event* firstEvent = [temp objectAtIndex:0];
    NSDate* today = firstEvent.start;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString* niceDate = [formatter stringFromDate:today];
    
    //Create view
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight)];
    header.backgroundColor = [UIColor blackColor];
    
    // Make button
    UIButton* dateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, header.frame.size.width, self.tableView.sectionHeaderHeight)];
    [dateButton addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setTitle:niceDate forState:UIControlStateNormal];
    dateButton.backgroundColor = [UIColor blackColor];
    dateButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    dateButton.tintColor = green;
    dateButton.tag = section;
    
    return dateButton;
}

-(Event*) getEventAtIndexPath:(NSIndexPath*) indexpath{
    NSMutableArray* day = [parties objectAtIndex:indexpath.section];
    return [day objectAtIndex:indexpath.row];
}


-(void) redoColoringForSection:(NSInteger) section{
    //Get number of rows that need to be recolored
    NSInteger numRows = [self.tableView numberOfRowsInSection:section];
    for (NSInteger i=0; i<numRows; i++) {
        EventCell* cell = (EventCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
        
        //Recolor in every other pattern
        if ((i+section) % 2 == 0) {
            cell.backgroundColor = green;
        } else {
            cell.backgroundColor = lightGreen;
        }

    }
    
    //Make table reload section
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}


@end
