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
BOOL* editing;

NSInteger selected;
NSMutableArray* parties;
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
        
        editing = NO;
        selected = NSIntegerMin;
        
        self.tableView.sectionHeaderHeight = 30;
        self.tableView.scrollEnabled = YES;
        self.tableView.scrollsToTop = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        self.view.backgroundColor = [UIColor blackColor];
        parties = [[NSMutableArray alloc] init];
        
        // Pull all events that have a start date today or later
        NSDate *currentDate = [[NSDate alloc] init];
        
        calendar = [NSCalendar currentCalendar];
        comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        
        NSDateComponents* currentDateComps = [calendar components:comps fromDate: currentDate];
        
        currentDate = [calendar dateFromComponents:currentDateComps];
        
        PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
        [query whereKey:@"startTime" greaterThan:currentDate];
        
        NSMutableArray* tempParties = [[NSMutableArray alloc] init];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
                
                // Do something with the found objects
                
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
                NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
                NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
                date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
                NSDateComponents* components = [[NSDateComponents alloc] init];
                [components setDay:1];
                date = [calendar dateByAddingComponents:components toDate:date options:0];
                NSLog(@"CurrDate is %@", date);
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
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEventView)];
    
    UIImage* profile = [UIImage imageNamed:@"profile_pic.png"];
    UIImage* scaledProfile = [UIImage imageWithCGImage:[ profile CGImage] scale:25 orientation:profile.imageOrientation];
    UIButton* tempProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempProfileButton.bounds = CGRectMake(0, 0, scaledProfile.size.width, scaledProfile.size.height);
    [tempProfileButton setImage:scaledProfile forState:UIControlStateNormal];
    [tempProfileButton addTarget:self action:@selector(profileView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithCustomView:tempProfileButton];
    
    self.navigationItem.rightBarButtonItem = addItem;
    self.navigationItem.leftBarButtonItem = profileItem;
    
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
    [query whereKey:@"startTime" greaterThan:currentDate];
    
    NSMutableArray* tempParties = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            
            // Do something with the found objects
            
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
                
                BOOL newEvent = YES;
                
                for (NSMutableArray* day in parties){
                    for (Event* cell in day){
                        if ([cell.name isEqualToString:temp.name]){
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
                //If the party starts after the current last party, add new section and corresponding
                //backend array to hold this data
                if (i>=parties.count) {
                    Event* sortee = tempParties[0];
                    NSMutableArray* newDay = [[NSMutableArray alloc] init];
                    [newDay addObject:sortee];
                    [tempParties removeObject:sortee];
                    [parties insertObject:newDay atIndex:i];
                    
                    //Add new section and row into the table
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationAutomatic];
                    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:i];
                    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                //Grab new event
                Event* temp = [[parties objectAtIndex:i] objectAtIndex:0];
                NSDate* curr = temp.start;
                NSDateComponents* currentComps = [calendar components:comps fromDate:curr];
                curr = [calendar dateFromComponents: currentComps];
                for (int n=0; n<tempParties.count; n++) {
                    Event* sortee =tempParties[n];
                    NSDate* start = sortee.start;
                    NSDateComponents* startComps = [calendar components:comps fromDate:start];
                    start = [calendar dateFromComponents: startComps];
                    
                    //If the event starts on the current day
                    if (start == curr) {
                        [[parties objectAtIndex:i] addObject:sortee];
                        [tempParties removeObject:sortee];
                        
                        //Add row to tableview
                        int lastRow = ((NSMutableArray*)parties[i]).count -1;
                        NSIndexPath* path = [NSIndexPath indexPathForRow:lastRow inSection:i];
                        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                        n--;
                        
                    //If the event starts on a new date
                    } else if (start < curr){
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
    [_parseProjectViewController openAddEventView];
}

-(void) profileView{
    [_parseProjectViewController openProfileView];
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
    return parties.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* temp = [parties objectAtIndex:section];
    return temp.count;
}

- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    [self.tableView registerClass: [EventCell class] forCellReuseIdentifier:CellIdentifier];
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:2.0f];
    
    //Tag cannot be 0 because they are default 0, set it to the row plus 1
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
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (((indexPath.section<<16) | indexPath.row)+1 == selected) {
        //Sets height based on how large description is
        Event* selectedEvent = [parties objectAtIndex:indexPath.row];
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
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop-self.tableView.sectionHeaderHeight animated:NO];
    EventCell* cell = (EventCell*)[self.tableView viewWithTag:((indexPath.section<<16)|indexPath.row)+1];
    //Check if already selected
    if (selected == cell.tag){
        selected=NSIntegerMin;
        cell.descriptionLabel.hidden = YES;
    }else{
        selected = cell.tag;
        //CGFloat height = [self tableView:[self tableView] heightForRowAtIndexPath:indexPath];
        //[cell longView: height];
        cell.descriptionLabel.hidden = NO;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
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
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight)];
    header.backgroundColor = [UIColor blackColor];
    UILabel* date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, header.frame.size.width, self.tableView.sectionHeaderHeight-5)];
    date.textAlignment = NSTextAlignmentCenter;
    date.textColor = green;
    date.text = niceDate;
    [header addSubview:date];
    
    return header;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
