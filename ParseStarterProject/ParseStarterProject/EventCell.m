//
//  EventCell.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "EventCell.h"

@implementation EventCell{
    CGFloat width;
    UIImage* unchecked;
    UIImage* checked;
    UILabel* rsvp;
    PFObject* thisEvent;
    NSString* schoolName;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //Set up view
        self.textColoring = [UIColor blackColor];
        
        self.backgroundColor = [UIColor greenColor];
        
        width =  self.viewForBaselineLayout.frame.size.width-4;
        CGFloat height = 55;
        
        // make label for the event
        self.eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.05, width, height*0.4)];
        self.eventNameLabel.textColor = self.textColoring;
        self.eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.eventNameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        // make label for the location of the event
        self.locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.42,width,height*0.3)];
        _locationLabel.textColor = self.textColoring;
        _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        
        //Label for array of switches
        _switchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, height*0.65,width, height*0.35)];
        _switchesLabel.textColor = self.textColoring;
        _switchesLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        _switchesLabel.textAlignment = NSTextAlignmentLeft;
        
        // make label for the time of the event
        _timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.9,width, height*0.35)];
        
        //timeLabel.text = [NSString stringWithFormat:@"%@ to %@",startDateString,endDateString];
        _timeLabel.textColor = self.textColoring;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
        //Set up description label
        _descriptionLabel = [[UITextView alloc] initWithFrame: CGRectMake(5, height*5, width, height*0.55)];
        _descriptionLabel.textColor = self.textColoring;
        _descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.editable = NO;
        _descriptionLabel.hidden = YES;
        
        self.selected = NO;
        
        //Make check mark image
        _checkMark = [[UIButton alloc] initWithFrame:CGRectMake(width*0.85, height*0.25, 35, 35)];
        [_checkMark addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage* bigChecked = [UIImage imageNamed:@"black_check.png"];
        checked = [UIImage imageWithCGImage:[ bigChecked CGImage] scale:bigChecked.scale*10 orientation:bigChecked.imageOrientation];
        UIImage* bigUnchecked = [UIImage imageNamed:@"black_plus.png"];
        unchecked = [UIImage imageWithCGImage:[bigUnchecked CGImage] scale:bigUnchecked.scale*10 orientation:bigUnchecked.imageOrientation];
        
        [_checkMark setImage:unchecked forState:UIControlStateNormal];
        
        _schoolInScope = YES;
        
        rsvp = [[UILabel alloc] initWithFrame:CGRectMake(width*0.78, height*0.9, width*0.2, height*.35)];
        rsvp.font = [UIFont fontWithName:@"Helvetica" size:12];
        rsvp.textAlignment = UIControlContentHorizontalAlignmentRight;


        
        // add these labels to the view
        [self.contentView addSubview:_eventNameLabel];
        [self.contentView addSubview:_locationLabel];
        [self.contentView addSubview:_switchesLabel];
        [self.contentView addSubview:_timeLabel];
        [self addSubview:_descriptionLabel];
        [self.contentView addSubview:_checkMark];
        [self.contentView addSubview:rsvp];
        
    }
    return self;
}

//Checks if user goes to school in openTo, and sets whether user can RSVP
-(void) setPartyScope {
    PFUser *curr = [PFUser currentUser];
    schoolName = [curr objectForKey:@"school"];
    
    if ([_openToArray containsObject:schoolName]) {
        _checkMark.alpha = 1.0;
        _schoolInScope = YES;
    } else {
        _checkMark.alpha = 0.2;
        _schoolInScope = NO;
    }
    
}

// This method sets an event cell's attendance checkmark to a check if a user created the event
-(void) setChecked {
    PFUser *curr = [PFUser currentUser];
    NSMutableArray* eventsCreated = [curr objectForKey:@"eventsCreated"];
    if ([eventsCreated containsObject:_objectid]) {
        [_checkMark setImage:checked forState:UIControlStateNormal];
    } // Otherwise, user did not create party and we don't need to do anything
}

//Queries for event to get RSVP value
-(void) setUpRSVP {
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
    [query getObjectInBackgroundWithId:_objectid block:^(PFObject *currentEvent, NSError *error) {
        if (!error) {
            thisEvent = currentEvent;
            [self updateRSVPText];
        }
    }];
    
}

//Makes image correct based on school in scope variable
-(void) setCheckMark {
    PFUser *curr = [PFUser currentUser];
    NSMutableArray* eventsAttending = [curr objectForKey:@"eventsAttending"];
    
    if ([eventsAttending containsObject:_objectid]) {
        [_checkMark setImage:checked forState:UIControlStateNormal];
    } else {
        [_checkMark setImage:unchecked forState:UIControlStateNormal];
    }
}

// Updates the RSVP text field
-(void) updateRSVPText {
    [thisEvent refreshInBackgroundWithBlock:^(PFObject* thisEvent, NSError* error){
        if (error)
            NSLog(@"Error: %@", error.localizedFailureReason);
    }];
    int attendees = [thisEvent[@"rsvpCount"] intValue];
    if (attendees == 1) {
        rsvp.text = [NSString stringWithFormat:@"%i attendee", attendees];
    } else {
        rsvp.text = [NSString stringWithFormat:@"%i attendees", attendees];
    }
}

// This method determines what to do when you try to attend an event
-(void) buttonPressed{
    if (_schoolInScope) {
        [thisEvent refresh];
        
        //If user hits button to mark attending, change button image and update parse
        if (_checkMark.imageView.image == unchecked){
            [_checkMark setImage:checked forState:UIControlStateNormal];
            [thisEvent incrementKey:@"rsvpCount"];
            PFUser *curr = [PFUser currentUser];
            NSMutableArray* eventsAttending = [curr objectForKey:@"eventsAttending"];
            
            if (eventsAttending) {
                [curr[@"eventsAttending"] addObject:thisEvent.objectId];
            } else {
                eventsAttending = [[NSMutableArray alloc] init];
                [eventsAttending addObject:thisEvent.objectId];
                [curr setObject:eventsAttending forKey:@"eventsAttending"];
            }
            [curr save];
            [_parseProjectViewController loadProfileView];
            [_parseProjectViewController loadTableView];

        }else{
            //If user hits to unattend event, change button image to unchecked and update parse
            [_checkMark setImage:unchecked forState:UIControlStateNormal];
            [thisEvent incrementKey:@"rsvpCount" byAmount:@-1];
            
            PFUser *curr = [PFUser currentUser];
            NSMutableArray* eventsAttending = [curr objectForKey:@"eventsAttending"];
            
            if (eventsAttending) {
                [curr[@"eventsAttending"] removeObject:thisEvent.objectId];
            } else {
                eventsAttending = [[NSMutableArray alloc] init];
                [curr setObject:eventsAttending forKey:@"eventsAttending"];
            }
            [curr save];
            [_parseProjectViewController loadProfileView];
            [_parseProjectViewController loadTableView];

        }
        [thisEvent saveInBackground];
        [self updateRSVPText];
    } else {
        NSString *title = [NSString stringWithFormat:@"Event not open to %@", schoolName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Consider contacting someone that can put you on the guest list directly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

//If the cell is pressed, expand the description label
-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    
    CGFloat height = self.frame.size.height-5;
    
    _descriptionLabel.frame =  CGRectMake(0, height*.95, width, height*1.25);
    _descriptionLabel.hidden = NO;
}
@end
