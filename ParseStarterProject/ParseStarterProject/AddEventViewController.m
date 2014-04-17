//
//  AddEventViewController.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "AddEventViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface AddEventViewController ()

@property (nonatomic) UIView      *currentTextField;
@property (nonatomic) UITextField *addEventField;
@property (nonatomic) UITextField *startTimeField;
@property (nonatomic) UITextField *endTimeField;
@property (nonatomic) UITextField *locationField;
@property (nonatomic) UITextView  *descriptionView;
@property (nonatomic) BOOL         openToCmc;
@property (nonatomic) BOOL         openToHmc;
@property (nonatomic) BOOL         openToPo;
@property (nonatomic) BOOL         openToPz;
@property (nonatomic) BOOL         openToSc;
@property (nonatomic) BOOL         openToOther;

@end

@implementation AddEventViewController

PFObject *newEvent;
CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
NSArray* switches;
NSArray* switchObjects;

BOOL eventNameEmpty;
BOOL startEmpty;
BOOL endEmpty;
BOOL locationEmpty;
BOOL switchesEmpty;
BOOL descriptionEmpty;

UILabel* eventNameAsterisk;
UILabel* startAsterisk;
UILabel* endAsterisk;
UILabel* locationAsterisk;
UILabel* openToAsterisk;
UILabel* descriptionAsterisk;

UILabel* asteriskMessage;




- (id)init
{
    self = [super init];
    if (self) {
        // Create UserEvents class for Parse
        newEvent = [PFObject objectWithClassName:@"UserEvents"];
        switches = [[NSArray alloc] init];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 250) ? NO : YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 30) ? NO : YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    
    //Get bounds of text field
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    //Figure out portion of view to move upwards
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    //Perform animation
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.currentTextField = textView;
    
    //Get bounds of text field
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    //Figure out portion of view to move upwards
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    //Perform animation
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    // Make the place holder text in the description box disappear when clicked
    if ([textView.text isEqualToString:@"Be sure to include any information such as: \nWet/dry? Who can register guests? Is there a url to register guests?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    // Make the dates appear when user finishes editing
    if (self.currentTextField == self.startTimeField) {
        
        NSLog(@"Entered start time field");
        
        // For the start time field
        UIDatePicker *startPicker = (UIDatePicker*)self.startTimeField.inputView;
        //get date from picker
        NSDate *startDate = startPicker.date;
        
        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        [startDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
        NSString *prettyStart = [startDateFormat stringFromDate:startDate];
        
        NSLog(@"The start time is %@", prettyStart);
        
        self.startTimeField.text = prettyStart;
        
    } else if (self.currentTextField == self.endTimeField) {
        
        NSLog(@"Entered end time field");
        // For the end time field
        UIDatePicker *endPicker = (UIDatePicker*)self.endTimeField.inputView;
        //get date from picker
        NSDate *endDate = endPicker.date;
        
        NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
        [endDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
        NSString *prettyEnd = [endDateFormat stringFromDate:endDate];
        
        NSLog(@"The end time is %@", prettyEnd);
        
        self.endTimeField.text = prettyEnd;
    }
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextField *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Be sure to include any information such as: \nWet/dry? Who can register guests? Is there a url to register guests?";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)prevTextField {
    NSInteger nextTag = self.currentTextField.tag - 1;
    
    if ((nextTag > 5) || (nextTag < 1)) {
        [self.currentTextField resignFirstResponder];
        
    } else {
        // Try to find next responder
        UIView* nextResponder = [self.currentTextField.superview viewWithTag:nextTag];
        if (nextResponder) {
            // Found next responder, so set it.
            self.currentTextField = nextResponder;
            [nextResponder becomeFirstResponder];
        } else {
            // Not found, so remove keyboard.
            [self.currentTextField resignFirstResponder];
        }
    }

}

-(void)nextTextField {
    NSInteger nextTag = self.currentTextField.tag + 1;
    
    if ((nextTag > 5) || (nextTag < 1)) {
        NSLog(@"Out of bounds");
        [self.currentTextField resignFirstResponder];
        
    } else {
        // Try to find next responder
        NSLog(@"In the correct bounds");
        UIView* nextResponder = [self.currentTextField.superview viewWithTag:nextTag];
        if (nextResponder) {
            NSLog(@"Found next responder");
            // Found next responder, so set it.
            self.currentTextField = nextResponder;
            [nextResponder becomeFirstResponder];
        } else {
            NSLog(@"Did not find next responder, so remove keyboard");
            // Not found, so remove keyboard.
            [self.currentTextField resignFirstResponder];
        }
    }
    
}

-(void)doneWithKeyboard{
    [self.currentTextField resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Colors
    UIColor* green = [UIColor colorWithRed:(float) 95.0/ 255.0
                                     green:(float) 190.0/ 255.0
                                      blue:(float) 20.0/ 255.0 alpha:1.0]; //95,190,20
    
    UIColor* lightGreen = [UIColor colorWithRed:(float) 200.0/ 255.0
                                          green:(float) 240.0/ 255.0
                                           blue:(float) 160.0/ 255.0 alpha:1.0];
    
    UIColor* datePickerGreen = [UIColor colorWithRed:(float) 175.0/ 255.0
                                               green:(float) 216.0/ 255.0
                                                blue:(float) 154.0/ 255.0 alpha:1.0];
    
    // constants
    double height = self.view.frame.size.height;
    double width  = self.view.frame.size.width;
    
    UIScrollView* scrollingView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 2 * height)];
    scrollingView.contentSize = CGSizeMake(width, 2.5 * height);
    
    double top = 0;
    
    double eventsTop = top + 12;
    
    
    // The Event name field
    self.addEventField = [[UITextField alloc] initWithFrame:CGRectMake(20, eventsTop, width - 40, 30)];
    self.addEventField.tag = 1;
    self.addEventField.placeholder = @"Event Name";
    [self.addEventField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.addEventField setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    self.addEventField.delegate = self;
    
    // Initialize asterisk next to event name field (but does not show yet)
    eventNameAsterisk = [[UILabel alloc] initWithFrame:CGRectMake(5, top+18, 25, 30)];
    eventNameAsterisk.font = [UIFont fontWithName:@"Helvetica" size:30.0 ];
    eventNameAsterisk.text = @"*";
    eventNameAsterisk.textColor = green;
    [scrollingView addSubview:eventNameAsterisk];
    
    
    // The keyboard bar
    UIToolbar* inputToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    inputToolbar.barStyle = UIBarStyleBlackTranslucent;
    inputToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(prevTextField)],
                           [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard)],
                           nil];
    [inputToolbar sizeToFit];
    inputToolbar.backgroundColor = green;
    inputToolbar.tintColor = lightGreen;
    [self.addEventField setInputAccessoryView:inputToolbar];
    
    [scrollingView addSubview:self.addEventField];
    
    double timesTop = eventsTop + 30;
    
    // Start time
    UILabel* startTimeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, timesTop, (width/2) - 30, 30)];
    startTimeLabel.text=@"Start Time";
    startTimeLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    startTimeLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: startTimeLabel];
    
    UILabel* endTimeLabel = [ [UILabel alloc] initWithFrame:CGRectMake((width/2) + 14, timesTop, (width/2) - 30, 30)];
    endTimeLabel.text=@"End Time";
    endTimeLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    endTimeLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: endTimeLabel];
    
    // The start date picker
    UIDatePicker *startDatePicker = [[UIDatePicker alloc]
                                     initWithFrame:CGRectMake(0, 0, 250, 250)];
    startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    startDatePicker.backgroundColor = datePickerGreen;
    startDatePicker.tintColor = [UIColor whiteColor];
    
    //get date from picker
    NSDate *startDate = startDatePicker.date;
    
    NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
    [startDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
    NSString *prettyStart = [startDateFormat stringFromDate:startDate];
    
    
    double timeFieldsTop = timesTop + 25;
    
    // Create start time field
    self.startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(20, timeFieldsTop, (width/2) - 32, 30)];
    self.startTimeField.tag = 2;
    self.startTimeField.placeholder = prettyStart;
    [self.startTimeField setBorderStyle:UITextBorderStyleRoundedRect];
    self.startTimeField.delegate = self;
    [self.startTimeField setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    
    [self.startTimeField setInputView:startDatePicker];
    [self.startTimeField setInputAccessoryView:inputToolbar];
    
    // add the field to the view
    [scrollingView addSubview:self.startTimeField];
    
    // Initialize start asterisk (but does not show yet)
    startAsterisk = [[UILabel alloc] initWithFrame:CGRectMake(5, top+48, 25, 30)];
    startAsterisk.font = [UIFont fontWithName:@"Helvetica" size:30.0 ];
    startAsterisk.text = @"*";
    startAsterisk.textColor = green;
    [scrollingView addSubview:startAsterisk];
    
    // The end date picker
    UIDatePicker *endDatePicker = [[UIDatePicker alloc]
                                   initWithFrame:CGRectMake(0, 0, 250, 250)];
    endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    endDatePicker.backgroundColor = datePickerGreen;
    
    //get date from picker
    NSDate *endDate = endDatePicker.date;
    
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"MM/dd/yy, hh:mm aa"];
    NSString *prettyEnd = [startDateFormat stringFromDate:endDate];
    
    // Create the end time field
    self.endTimeField = [[UITextField alloc] initWithFrame:CGRectMake((width/2) + 12, timeFieldsTop, (width/2) - 32, 30)];
    self.endTimeField.tag = 3;
    self.endTimeField.placeholder = prettyEnd;
    [self.endTimeField setBorderStyle:UITextBorderStyleRoundedRect];
    self.endTimeField.delegate = self;
    [self.endTimeField setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    
    [self.endTimeField setInputView:endDatePicker];
    [self.endTimeField setInputAccessoryView:inputToolbar];
    [scrollingView addSubview:self.endTimeField];
    
    // Initialize end asterisk (but does not show yet)
    endAsterisk = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 3, top+48, 25, 30)];
    endAsterisk.font = [UIFont fontWithName:@"Helvetica" size:30.0 ];
    endAsterisk.text = @"*";
    endAsterisk.textColor = green;
    [scrollingView addSubview:endAsterisk];
    
    double locationTop = timeFieldsTop + 35;
    
    UILabel* locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, locationTop, width, 30)];
    locationLabel.text=@"Location";
    locationLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    locationLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: locationLabel];
    
    double locationFieldsTop = locationTop + 25;
    
    self.locationField = [[UITextField alloc] initWithFrame:CGRectMake(20, locationFieldsTop, width - 40, 30)];
    self.locationField.tag = 4;
    self.locationField.placeholder = @"College, Building, Room";
    [self.locationField setBorderStyle:UITextBorderStyleRoundedRect];
    self.locationField.delegate = self;
    [self.locationField setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [self.locationField setInputAccessoryView:inputToolbar];
    
    [scrollingView addSubview:self.locationField];
    
    // Initialize asterisk next to location field (but does not show yet)
    locationAsterisk = [[UILabel alloc] initWithFrame:CGRectMake(5, top+108, 25, 30)];
    locationAsterisk.font = [UIFont fontWithName:@"Helvetica" size:30.0 ];
    locationAsterisk.text = @"*";
    locationAsterisk.textColor = green;
    [scrollingView addSubview:locationAsterisk];
    
    double openTop = locationFieldsTop + 35;
    
    UILabel* openLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, openTop, width, 30)];
    openLabel.text=@"Open to";
    openLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    openLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: openLabel];
    
    // Initialize asterisk next to openTo label (but does not show yet)
    openToAsterisk = [[UILabel alloc] initWithFrame:CGRectMake(5, top+168, 25, 30)];
    openToAsterisk.font = [UIFont fontWithName:@"Helvetica" size:30.0 ];
    openToAsterisk.text = @"*";
    openToAsterisk.textColor = green;
    [scrollingView addSubview:openToAsterisk];
    
    double switchesTop = openTop + 25;
    
    // first column of switches
    UISwitch* cmcSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, switchesTop, (width/2) - 30, 10)];
    cmcSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    cmcSwitch.onTintColor = lightGreen;
    [scrollingView addSubview:cmcSwitch];
    cmcSwitch.tag = 0;
    [cmcSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

    UILabel* cmcLabel = [ [UILabel alloc] initWithFrame:CGRectMake(110, switchesTop, (width/2) - 30, 30)];
    cmcLabel.text=@"CMC";
    cmcLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    cmcLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: cmcLabel];
    
    
    UISwitch* hmcSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, switchesTop + 25, (width/2) - 30, 10)];
    hmcSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    hmcSwitch.onTintColor = lightGreen;
    [scrollingView addSubview:hmcSwitch];
    hmcSwitch.tag = 1;
    [hmcSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

    UILabel* hmcLabel = [ [UILabel alloc] initWithFrame:CGRectMake(110, switchesTop + 25, (width/2) - 30, 30)];
    hmcLabel.text=@"HMC";
    hmcLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    hmcLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: hmcLabel];
    
    
    UISwitch* poSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, switchesTop + 50, (width/2) - 30, 10)];
    poSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    poSwitch.onTintColor = lightGreen;
    [scrollingView addSubview:poSwitch];
    poSwitch.tag = 2;
    [poSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

    UILabel* poLabel = [ [UILabel alloc] initWithFrame:CGRectMake(110, switchesTop + 50, (width/2) - 30, 30)];
    poLabel.text=@"PO";
    poLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    poLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: poLabel];
    
    
    // second column of switches
    
    UISwitch* pzSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 150, switchesTop, (width/2) - 30, 10)];
    pzSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    pzSwitch.onTintColor = lightGreen;
    [scrollingView addSubview:pzSwitch];
    pzSwitch.tag = 3;
    [pzSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

    UILabel* pzLabel = [ [UILabel alloc] initWithFrame:CGRectMake(width - 90, switchesTop, (width/2) - 30, 30)];
    pzLabel.text=@"PZ";
    pzLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    pzLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: pzLabel];
    
    
    UISwitch* scSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 150, switchesTop + 25, (width/2) - 30, 10)];
    scSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    scSwitch.onTintColor = lightGreen;
    [scrollingView addSubview: scSwitch];
    scSwitch.tag = 4;
    [scSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    
    UILabel* scLabel = [ [UILabel alloc] initWithFrame:CGRectMake(width - 90, switchesTop + 25, (width/2) - 30, 30)];
    scLabel.text=@"SC";
    scLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    scLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: scLabel];
    
    UISwitch* otherSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 150, switchesTop + 50, (width/2) - 30, 10)];
    otherSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    otherSwitch.onTintColor = lightGreen;
    [scrollingView addSubview:otherSwitch];
    otherSwitch.tag = 5;
    [otherSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

    
    UILabel* otherLabel = [ [UILabel alloc] initWithFrame:CGRectMake(width - 90, switchesTop + 50, (width/2) - 30, 30)];
    otherLabel.text=@"Other";
    otherLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    otherLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: otherLabel];
    
    double descriptionTop = switchesTop + 80;
    
    UILabel* descriptionLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20, descriptionTop, width, 25)];
    descriptionLabel.text=@"Description";
    descriptionLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0 ];
    descriptionLabel.textColor = [UIColor whiteColor];
    [scrollingView addSubview: descriptionLabel];
    
    double descriptionFieldTop = descriptionTop + 25;
    
    self.descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(20, descriptionFieldTop, width -
        40, 85)];
    self.descriptionView.tag = 5;
    self.descriptionView.delegate = self;
    self.descriptionView.backgroundColor = [UIColor whiteColor];
    self.descriptionView.allowsEditingTextAttributes = YES;
    self.descriptionView.text = @"Be sure to include any information such as: \nWet/dry? Who can register guests? Is there a url to register guests?";
    self.descriptionView.textColor = [UIColor lightGrayColor];
    [self.descriptionView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    self.descriptionView.clipsToBounds = YES;
    self.descriptionView.layer.cornerRadius = 5.0f;
    [self.descriptionView setInputAccessoryView:inputToolbar];
    
    [scrollingView addSubview:self.descriptionView];
    [self.view addSubview:scrollingView];
    
    // Initialize asterisk next to description label (but does not show yet)
    descriptionAsterisk = [[UILabel alloc] initWithFrame:CGRectMake(5, top+272, 25, 30)];
    descriptionAsterisk.font = [UIFont fontWithName:@"Helvetica" size:30.0 ];
    descriptionAsterisk.text = @"*";
    descriptionAsterisk.textColor = green;
    [scrollingView addSubview:descriptionAsterisk];
    
    // Initialize (but do not display) warning at the bottom to fill in all fields
    asteriskMessage = [ [UILabel alloc] initWithFrame:CGRectMake(0, descriptionFieldTop+78, width, 50)];
    asteriskMessage.textAlignment = UITextAlignmentLeft;
    asteriskMessage.lineBreakMode = NSLineBreakByWordWrapping;
    asteriskMessage.numberOfLines = 0;
    asteriskMessage.font=[UIFont fontWithName:@"Helvetica" size:13.0 ];
    asteriskMessage.textColor = [UIColor blackColor];
    asteriskMessage.text = @"";
    [scrollingView addSubview:asteriskMessage];
    
    UILabel* notifyLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    notifyLabel.textAlignment = UITextAlignmentCenter;
    notifyLabel.text=@"Add an Event";
    notifyLabel.font=[UIFont fontWithName:@"Helvetica" size:25.0 ];
    notifyLabel.textColor = green;

    [self.navigationItem setTitleView:notifyLabel];
    
    self.view.backgroundColor = green;
    
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleBordered target:self action:@selector(createButtonPressed)];
//    createItem.tintColor = lightGreen;
//    self.navigationItem.backBarButtonItem.tintColor = lightGreen;
    
    self.navigationItem.rightBarButtonItem = createItem;
    
    switchObjects = [[NSArray alloc] initWithObjects:hmcSwitch, cmcSwitch, pzSwitch, poSwitch, scSwitch, otherSwitch, nil];

}

// Method that changes the states for the openTo schools switch conditions
- (void)setState:(UISwitch*)sender
{
    BOOL state = [sender isOn];
    int identifier = sender.tag;
    
    if (identifier == 0) {
        self.openToCmc = state == YES ? YES: NO;
    }
    if (identifier == 1) {
        self.openToHmc = state == YES ? YES: NO;
    }
    if (identifier == 2) {
        self.openToPo = state == YES ? YES: NO;
    }
    if (identifier == 3) {
        self.openToPz = state == YES ? YES: NO;
    }
    if (identifier == 4) {
        self.openToSc = state == YES ? YES: NO;
    }
    if (identifier == 5) {
        self.openToOther = state == YES ? YES: NO;
    }
}


- (IBAction)createButtonPressed {
    
    UIColor* green = [UIColor colorWithRed:(float) 95.0/ 255.0
                                     green:(float) 190.0/ 255.0
                                      blue:(float) 20.0/ 255.0 alpha:1.0];
    
    UIColor* orange = [UIColor colorWithRed:(float)255.0/255.0
                                      green:(float)100.0/255.0  blue:(float)40.0/255.0 alpha:1.0];
    
    // For the start time field
    UIDatePicker *startPicker = (UIDatePicker*)self.startTimeField.inputView;
    //get date from picker
    NSDate *startDate = startPicker.date;
    
    // For the end time field
    UIDatePicker *endPicker = (UIDatePicker*)self.endTimeField.inputView;
    //get date from picker
    NSDate *endDate = endPicker.date;
    
    // Create array of college names in string format to add to the array that will be pushed to parse
    NSArray* switchNames = [NSArray arrayWithObjects:@"CMC", @"HMC", @"Pomona", @"Pitzer", @"Scripps",
                            @"Other", nil];
    
    // Update bool array
    switches = [NSArray arrayWithObjects: [NSNumber numberWithBool:self.openToCmc], [NSNumber numberWithBool:self.openToHmc], [NSNumber numberWithBool:self.openToPo],[NSNumber numberWithBool:self.openToPz], [NSNumber numberWithBool:self.openToSc], [NSNumber numberWithBool:self.openToOther], nil];
    
    // Create (mutable) array for the switches (which school it's open to)
    NSMutableArray* openToSwitches = [[NSMutableArray alloc] init];
    
    // Add (in string format) all colleges that are allowed to array (this one will be pushed to parse)
    for (int index=0; index<6; ++index) {
        BOOL isItOpen = [[switches objectAtIndex:index] boolValue];
        if (isItOpen) {
            [openToSwitches addObject:switchNames[index]];
        }
    }
    
    // Next series of if-else statements check whether any add event fields have been left blank
    // If any of them have, a private bool variable is turned on and in viewDidLoad this prompts
    // a message to the user to edit all fields
    
    // create local count variable to check if user has edited all fields
    NSUInteger emptyFieldCount = 0;
    
    
    if ([self.addEventField.text length] == 0) {
        
        eventNameEmpty = YES;
        ++emptyFieldCount;
        
        // Add asterisk next to event name field
        eventNameAsterisk.textColor = [UIColor blackColor];
        
    } else {
        eventNameEmpty = NO;
        eventNameAsterisk.textColor = green;
    }
    
    // see if start and end date fields are empty by checking if the entered dates are
    // before the current date
    NSDate *currentDate = [[NSDate alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents *startDateComps = [calendar components:comps
                                                    fromDate: startDate];
    NSDateComponents *currentDateComps = [calendar components:comps
                                                    fromDate: currentDate];
    NSDateComponents *endDateComps = [calendar components:comps
                                                     fromDate: endDate];
    
    NSDate* startDay = [calendar dateFromComponents:startDateComps];
    currentDate = [calendar dateFromComponents:currentDateComps];
    endDate = [calendar dateFromComponents:endDateComps];
    
    if ([startDay compare:currentDate] == NSOrderedAscending) {
        
        startEmpty = YES;
        ++emptyFieldCount;
        
        // Add asterisk next to start time field
        startAsterisk.textColor = [UIColor blackColor];
        
    } else {
        startEmpty = NO;
        startAsterisk.textColor = green;
    }
    
    
    if ([endDate compare:currentDate] == NSOrderedAscending) {
        
        endEmpty = YES;
        ++emptyFieldCount;
        
        // Add asterisk next to end time field
        endAsterisk.textColor = [UIColor blackColor];
        
    } else {
        endEmpty = NO;
        endAsterisk.textColor = green;
    }
    
    
    if ([self.locationField.text length] == 0) {
        
        locationEmpty = YES;
        ++emptyFieldCount;
        
        // Add asterisk next to location field
        locationAsterisk.textColor = [UIColor blackColor];
        
    } else {
        locationEmpty = NO;
        locationAsterisk.textColor = green;
    }
    
    if ([openToSwitches count] == 0) {
        
        switchesEmpty = YES;
        ++emptyFieldCount;
        
        // Add asterisk next to openTo label
        openToAsterisk.textColor = [UIColor blackColor];
        
    } else {
        switchesEmpty = NO;
        openToAsterisk.textColor = green;
    }
    
    // Since the description text will remain as the placeholder (as written below) if the user leaves
    // it blank, we must check if the text in the box is the same as the placeholder text
    
    if ([self.descriptionView.text isEqualToString:@"Be sure to include any information such as: \nWet/dry? Who can register guests? Is there a url to register guests?"]) {
        
        descriptionEmpty = YES;
        ++emptyFieldCount;
        
        // Add asterisk next to description label
        descriptionAsterisk.textColor = [UIColor blackColor];
        
    } else {
        descriptionEmpty = NO;
        descriptionAsterisk.textColor = green;
    }
    
    NSLog(@"There are %lu fields that have not been filled out", (unsigned long)emptyFieldCount);
    
    // Only send info to parse and return to table view if all fields have been entered
    
    
    if (emptyFieldCount == 0) {
        
        asteriskMessage.text = @"";
        
        // Push event information to Parse
        newEvent[@"eventName"] = self.addEventField.text;
        newEvent[@"startTime"] = startDate;
        newEvent[@"endTime"] = endDate;
        newEvent[@"locationText"] = self.locationField.text;
        newEvent[@"description"] = self.descriptionView.text;
        newEvent[@"openTo"] = openToSwitches;
        newEvent[@"rsvpCount"] = @1; // When created, rsvp count is 1
        [newEvent saveInBackground];

//        // Add the event's objectId to the fields in the current PFUser which are (will be)
//        // NSMutableArray* eventsCreated and NSMutableArray* eventsAttending.
//        // Note: These need to be initialized somewhere.
//        PFUser *curr = [PFUser currentUser];
//        [curr[@"eventsCreated"] addObject:newEvent.objectId];
//        [curr[@"eventsAttending"] addObject:newEvent.objectId];
        
        //Reset all values of text fields
        _addEventField.text = nil;
        _startTimeField.text = nil;
        _endTimeField.text = nil;
        _locationField.text = nil;
        _descriptionView.text = nil;
        _openToCmc = NO;
        _openToHmc = NO;
        _openToOther = NO;
        _openToPo = NO;
        _openToPz = NO;
        _openToSc = NO;
        
        for (UISwitch* open in switchObjects){
            [self setState:open];
        }
        
        [_parseProjectViewController pop];
    } else {
        if (startEmpty || endEmpty){
            asteriskMessage.textAlignment = UITextAlignmentCenter;
            asteriskMessage.text=@"* Please fill in all fields. For the time field(s), make\nsure the entered date is not before today's date.";
        } else {
            asteriskMessage.textAlignment = UITextAlignmentLeft;
            asteriskMessage.text=@"    * Please fill in all fields.";
        }
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
