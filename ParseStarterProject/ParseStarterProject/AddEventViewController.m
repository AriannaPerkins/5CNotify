//
//  AddEventViewController.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@property (nonatomic)  UITextField *startTimeField;
@property (nonatomic)  UITextField *endTimeField;


@end

@implementation AddEventViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 108) ? NO : YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 30) ? NO : YES;
}

-(void)updateTextField:(id)sender
{
    // For the start time field
    UIDatePicker *startPicker = (UIDatePicker*)self.startTimeField.inputView;
    //get date from picker
    NSDate *startDate = startPicker.date;
    
    NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
    NSString *prettyStart = [startDateFormat stringFromDate:startDate];
    self.startTimeField.text = prettyStart;
    
    // For the end time field
    UIDatePicker *endPicker = (UIDatePicker*)self.endTimeField.inputView;
    //get date from picker
    NSDate *endDate = endPicker.date;
    
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
    NSString *prettyEnd = [endDateFormat stringFromDate:endDate];
    self.endTimeField.text = prettyEnd;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Colors
    UIColor* green = [UIColor colorWithRed: 95.0/ 255.0
                                     green:(float) 190.0/ 255.0
                                      blue:(float) 20.0/ 255.0 alpha:1.0];
    
    UIColor* lightGreen = [UIColor colorWithRed: 200.0/ 255.0
                                          green:(float) 240.0/ 255.0
                                           blue:(float) 160.0/ 255.0 alpha:1.0];
    
    UIColor* datePickerGreen = [UIColor colorWithRed: 175.0/ 255.0
                                               green:(float) 216.0/ 255.0
                                                blue:(float) 154.0/ 255.0 alpha:1.0];
    
    // constants
    double height = self.view.frame.size.height;
    double width = self.view.frame.size.width;
    
    UIScrollView* scrollingView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 2 * height)];
    scrollingView.contentSize = CGSizeMake(width, 2.5 * height);
    
    double top = 55.0;
    
    UILabel* addEventLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, top, width, 30)];
    addEventLabel.textAlignment = UITextAlignmentCenter;
    addEventLabel.text=@"Add an Event";
    addEventLabel.font=[UIFont fontWithName:@"Helvetica" size:25.0 ];
    addEventLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: addEventLabel];
    
    double eventsTop = top + 40;
    
    UITextField* addEventField = [[UITextField alloc] initWithFrame:CGRectMake(20, eventsTop, width - 40, 30)];
    addEventField.placeholder = @"Event Name";
    [addEventField setBorderStyle:UITextBorderStyleRoundedRect];
    [addEventField setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    addEventField.delegate = self;
    
    [scrollingView addSubview:addEventField];
    
    double timesTop = eventsTop + 40;
    
    UILabel* startTimeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, timesTop, (width/2) - 30, 30)];
    startTimeLabel.text=@"Start Time";
    startTimeLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    startTimeLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: startTimeLabel];
    
    UILabel* endTimeLabel = [ [UILabel alloc] initWithFrame:CGRectMake((width/2) + 10, timesTop, (width/2) - 30, 30)];
    endTimeLabel.text=@"End Time";
    endTimeLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    endTimeLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: endTimeLabel];
    
    // The start date picker
    UIDatePicker *startDatePicker = [[UIDatePicker alloc]
                                     initWithFrame:CGRectMake(0, 0, 250, 250)];
    startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //dateobj.minimumDate=[NSDate date];
    startDatePicker.backgroundColor = datePickerGreen;
    startDatePicker.tintColor = [UIColor whiteColor];
    
    //get date from picker
    NSDate *startDate = startDatePicker.date;
    
    NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
    NSString *prettyStart = [startDateFormat stringFromDate:startDate];
    
    double timeFieldsTop = timesTop + 25;
    
    self.startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(20, timeFieldsTop, (width/2) - 28, 30)];
    self.startTimeField.placeholder = prettyStart;
    [self.startTimeField setBorderStyle:UITextBorderStyleRoundedRect];
    self.startTimeField.delegate = self;
    [self.startTimeField setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [startDatePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startTimeField setInputView:startDatePicker];
    
    // add the field to the view
    [scrollingView addSubview:_startTimeField];
    
    // The end date picker
    UIDatePicker *endDatePicker = [[UIDatePicker alloc]
                                   initWithFrame:CGRectMake(0, 0, 250, 250)];
    endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //dateobj.minimumDate=[NSDate date];
    endDatePicker.backgroundColor = datePickerGreen;
    
    //get date from picker
    NSDate *endDate = endDatePicker.date;
    
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
    NSString *prettyEnd = [startDateFormat stringFromDate:endDate];
    
    self.endTimeField = [[UITextField alloc] initWithFrame:CGRectMake((width/2) + 6, timeFieldsTop, (width/2) - 28, 30)];
    self.endTimeField.placeholder = prettyEnd;
    [self.endTimeField setBorderStyle:UITextBorderStyleRoundedRect];
    self.endTimeField.delegate = self;
    [self.endTimeField setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [endDatePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.endTimeField setInputView:endDatePicker];
    [scrollingView addSubview:self.endTimeField];
    
    double locationTop = timeFieldsTop + 35;
    
    UILabel* locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, locationTop, width, 30)];
    locationLabel.text=@"Location";
    locationLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    locationLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: locationLabel];
    
    double locationFieldsTop = locationTop + 25;
    
    UITextField* locationField = [[UITextField alloc] initWithFrame:CGRectMake(20, locationFieldsTop, width - 40, 30)];
    locationField.placeholder = @"College, Building, Room";
    [locationField setBorderStyle:UITextBorderStyleRoundedRect];
    [locationField setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [scrollingView addSubview:locationField];
    
    
    double openTop = locationFieldsTop + 35;
    
    UILabel* openLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, openTop, width, 30)];
    openLabel.text=@"Open to";
    openLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    openLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: openLabel];
    
    double switchesTop = openTop + 30;
    
    // first column of switches
    UISwitch* cmcSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, switchesTop, (width/2) - 30, 10)];
    cmcSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    cmcSwitch.onTintColor = green;
    [scrollingView addSubview:cmcSwitch];
    
    UILabel* cmcLabel = [ [UILabel alloc] initWithFrame:CGRectMake(110, switchesTop, (width/2) - 30, 30)];
    cmcLabel.text=@"CMC";
    cmcLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    cmcLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: cmcLabel];
    
    UISwitch* hmcSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, switchesTop + 25, (width/2) - 30, 10)];
    hmcSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    hmcSwitch.onTintColor = green;
    [scrollingView addSubview:hmcSwitch];
    
    UILabel* hmcLabel = [ [UILabel alloc] initWithFrame:CGRectMake(110, switchesTop + 25, (width/2) - 30, 30)];
    hmcLabel.text=@"HMC";
    hmcLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    hmcLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: hmcLabel];
    
    UISwitch* poSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, switchesTop + 50, (width/2) - 30, 10)];
    poSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    poSwitch.onTintColor = green;
    [scrollingView addSubview:poSwitch];
    
    UILabel* poLabel = [ [UILabel alloc] initWithFrame:CGRectMake(110, switchesTop + 50, (width/2) - 30, 30)];
    poLabel.text=@"PO";
    poLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    poLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: poLabel];
    
    // second column of switches
    
    UISwitch* pzSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 150, switchesTop, (width/2) - 30, 10)];
    pzSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    pzSwitch.onTintColor = green;
    [scrollingView addSubview:pzSwitch];
    
    UILabel* pzLabel = [ [UILabel alloc] initWithFrame:CGRectMake(width - 90, switchesTop, (width/2) - 30, 30)];
    pzLabel.text=@"PZ";
    pzLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    pzLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: pzLabel];
    
    UISwitch* scSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 150, switchesTop + 25, (width/2) - 30, 10)];
    scSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    scSwitch.onTintColor = green;
    [scrollingView addSubview: scSwitch];
    
    UILabel* scLabel = [ [UILabel alloc] initWithFrame:CGRectMake(width - 90, switchesTop + 25, (width/2) - 30, 30)];
    scLabel.text=@"SC";
    scLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    scLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: scLabel];
    
    UISwitch* otherSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 150, switchesTop + 50, (width/2) - 30, 10)];
    otherSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    otherSwitch.onTintColor = green;
    [scrollingView addSubview:otherSwitch];
    
    UILabel* otherLabel = [ [UILabel alloc] initWithFrame:CGRectMake(width - 90, switchesTop + 50, (width/2) - 30, 30)];
    otherLabel.text=@"Other";
    otherLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    otherLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: otherLabel];
    
    double descriptionTop = switchesTop + 90;
    
    UILabel* descriptionLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, descriptionTop, width, 30)];
    descriptionLabel.text=@"Description";
    descriptionLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    descriptionLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: descriptionLabel];
    
    double descriptionFieldTop = descriptionTop + 25;
    
    UITextField* descriptionPlace = [[UITextField alloc] initWithFrame:CGRectMake(20, descriptionFieldTop, width - 40, 75)];
    [descriptionPlace setBorderStyle:UITextBorderStyleRoundedRect];
    [scrollingView addSubview:descriptionPlace];
    
    UITextView* descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(20, descriptionFieldTop, width - 40, 75)];
    descriptionField.editable = TRUE;
    descriptionField.backgroundColor = [UIColor clearColor];
    [descriptionField setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    descriptionField.delegate = self;
    [scrollingView addSubview:descriptionField];
    
    [self.view addSubview:scrollingView];
    
    // Navigation Bar
    UINavigationBar* navBar = [[UINavigationBar alloc] init];
    navBar.frame = CGRectMake(0, 0, width, 50);
    navBar.backgroundColor = green;
    navBar.translucent = FALSE;
    [self.view addSubview:navBar];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"5CNotify"];
    navigItem.rightBarButtonItem = doneItem;
    navigItem.leftBarButtonItem = cancelItem;
    navBar.items = [NSArray arrayWithObjects: navigItem,nil];
    
    self.view.backgroundColor = green;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
