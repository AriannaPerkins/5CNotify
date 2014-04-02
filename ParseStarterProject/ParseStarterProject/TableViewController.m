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
        
        self.view.backgroundColor = [UIColor blackColor];
        parties = [[NSMutableArray alloc] init];
        
        
        NSDate *currentDate = [[NSDate alloc] init];
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
                    
                    Event* temp = [[Event alloc] initWith:name andLoc:location andStart:startTime andEnd:endTime andDescription:description andOpenTo:switches];
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
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddEventView)];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:addItem, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    UILabel* notifyLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    notifyLabel.textAlignment = UITextAlignmentCenter;
    notifyLabel.text=@"5CNotify";
    notifyLabel.font=[UIFont fontWithName:@"Helvetica" size:25.0 ];
    notifyLabel.textColor = green;
    
    [self.navigationItem setTitleView:notifyLabel];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
}

- (IBAction)openAddEventView {
    
    NSLog(@"Push pressed");
    
    AddEventViewController *addView = [[AddEventViewController alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
    
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
    cell.tag = indexPath.section+indexPath.row + 1;
    
    NSMutableArray* day = [parties objectAtIndex:indexPath.section];
    Event* party = [day objectAtIndex:indexPath.row];
    
    if (cell.tag % 2 == 0) {
        cell.backgroundColor = green;
    } else {
        cell.backgroundColor = lightGreen;
    }
    
    cell.eventNameLabel.text = party.name;
    cell.locationLabel.text = party.location;
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate* startTime = party.start;
    NSDate* endTime = party.end;
    NSString *startDateString = [dateFormat stringFromDate: startTime];
    NSString *endDateString   = [dateFormat stringFromDate: endTime];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@, %@", startDateString, endDateString];
    cell.descriptionLabel.text = party.description;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgView];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == selected) {
        //Sets height based on how large description is
        Event* selectedEvent = [parties objectAtIndex:indexPath.row];
        NSString *text = selectedEvent.description;
        CGSize constraint = CGSizeMake(260, 100);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint];
        CGFloat height = 60 + (size.height*1.2);
        
        return height;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell* cell = (EventCell*)[self.tableView viewWithTag:indexPath.section+indexPath.row+1];
    //Check if already selected
    if (selected == indexPath.row){
        selected=NSIntegerMin;
        cell.descriptionLabel.hidden = YES;
    }else{
        selected = indexPath.row;
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
    [header.layer setCornerRadius:7.0f];
    [header.layer setMasksToBounds:YES];
    [header.layer setBorderWidth:2.0f];
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
