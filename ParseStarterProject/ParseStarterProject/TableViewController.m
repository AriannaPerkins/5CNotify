//
//  TableViewController.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "TableViewController.h"
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
NSArray* parties;

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
        
        self.view.backgroundColor = green;
        
        NSMutableArray* addParties = [[NSMutableArray alloc] init];
        // Some dummy cells for now;
        for (int i=0; i<9; ++i) {
            
            NSString* name = [NSString stringWithFormat:@"Sample Party %i", i];
            
            NSString* loc = [NSString stringWithFormat:@"Sample Dorm %i", i];
            
            int rand = arc4random()%5000;
            NSDate* start = [NSDate dateWithTimeIntervalSinceNow:rand*60];
            
            NSDate* end = [NSDate dateWithTimeIntervalSinceNow:rand*60+120];
            
            NSString* descrip = [NSString stringWithFormat:@"THIS PARTY WILL BE CRAY!!!! I am so excited for just how good it will be"];
            
            Event* tempParty = [[Event alloc] initWith:name andLoc:loc andStart:start andEnd:end andDesciption:descrip];
            
            [addParties addObject:tempParty];
        }
        
        parties = [addParties sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(Event*)a start];
            NSDate *second = [(Event*)b start];
            return [first compare:second];
        }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return parties.count;
}

- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    [self.tableView registerClass: [EventCell class] forCellReuseIdentifier:CellIdentifier];
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Tag cannot be 0 because they are default 0, set it to the row plus 1
    cell.tag = indexPath.row + 1;
    
    Event* party = [parties objectAtIndex:indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        cell.cellView.backgroundColor = green;
    } else {
        cell.cellView.backgroundColor = lightGreen;
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
    EventCell* cell = (EventCell*)[self.tableView viewWithTag:indexPath.row+1];
    //Check if already selected
    if (selected == indexPath.row){
        selected=NSIntegerMin;
        [cell returnToNormalView];
    }else{
        selected = indexPath.row;
        CGFloat height = [self tableView:[self tableView] heightForRowAtIndexPath:indexPath];
        [cell longView: height];
    }
    [self.tableView reloadData];
    
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
