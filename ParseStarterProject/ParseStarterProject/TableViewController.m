//
//  TableViewController.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

// Global variables (get initialized in initWithStyle)
UIColor* green;
UIColor* lightGreen;
UIColor* lightlightGreen;
UIFont* helvet15;
BOOL* editing;

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
        
        self.view.backgroundColor = green;
        
        // Some dummy cells for now
        EventCell *cell1 = [[EventCell alloc] initWithStyle:UITableViewStylePlain
                                            reuseIdentifier:@"EventCell1"];
        EventCell *cell2 = [[EventCell alloc] initWithStyle:UITableViewStylePlain
                                            reuseIdentifier:@"EventCell2"];
        EventCell *cell3 = [[EventCell alloc] initWithStyle:UITableViewStylePlain
                                            reuseIdentifier:@"EventCell3"];
        EventCell *cell4 = [[EventCell alloc] initWithStyle:UITableViewStylePlain
                                            reuseIdentifier:@"EventCell4"];
        
        self.cellsArray = [NSMutableArray arrayWithObjects:cell1, cell2, cell3, cell4, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     // Display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddEventView)];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:addItem,editButton, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    UILabel* notifyLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    notifyLabel.textAlignment = UITextAlignmentCenter;
    notifyLabel.text=@"5CNotify";
    notifyLabel.font=[UIFont fontWithName:@"Helvetica" size:25.0 ];
    notifyLabel.textColor = [UIColor whiteColor];
    
    [self.navigationItem setTitleView:notifyLabel];
    
}

- (IBAction)openAddEventView {
    
    NSLog(@"Push pressed");
    
    AddEventViewController *addView = [[AddEventViewController alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
    
}


- (void)editTable
{
    editing = !editing;
        [self.tableView setEditing:editing animated:editing];

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
    return [self.cellsArray count];
}

- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    // necessary to use forIndexPath:indexPath below
    [self.tableView registerClass: [EventCell class] forCellReuseIdentifier:CellIdentifier];
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell.
    cell = [self.cellsArray objectAtIndex:indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = green;
    } else {
        cell.backgroundColor = lightGreen;
    }
    
//    cell.textLabel.textColor = [UIColor whiteColor];
    
    // Set what happens when you click on a cell
    // Idea: pass this in to initWithStyle in didSelectRowAtIndexPath, then reload data.
//    if (indexPath.row % 2 == 0) {
//        cell.textColoring = lightGreen;
//    } else {
//        cell.textColoring = green;
//    }
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgView];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row at %d selected.",indexPath.row);
//    static NSString *CellIdentifier = @"EventCell";
//    EventCell* expandedCell = [[EventCell alloc] initLongWithStyle:UITableViewStylePlain reuseIdentifier:CellIdentifier];
//    self.cellsArray[indexPath.row] = expandedCell;
//    [self.tableView reloadData];
    
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
