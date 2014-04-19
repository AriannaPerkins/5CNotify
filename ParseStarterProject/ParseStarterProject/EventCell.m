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
        
        self.textColoring = [UIColor blackColor];
        
        self.backgroundColor = [UIColor greenColor];
        
        width =  self.viewForBaselineLayout.frame.size.width-4;
        CGFloat height = 55;
        
        // make label for the event
        self.eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.05, width, height*0.4)];
        //self.eventNameLabel.text = [NSString stringWithFormat:@"Sample Party"];
        self.eventNameLabel.textColor = self.textColoring;
        self.eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.eventNameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        // make label for the location of the event
        self.locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.42,width,height*0.3)];
        //_locationLabel.text = [NSString stringWithFormat:@"%@",location];
        _locationLabel.textColor = self.textColoring;
        _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        
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
        
        
        _descriptionLabel = [[UITextView alloc] initWithFrame: CGRectMake(5, height*5, width, height*0.55)];
        _descriptionLabel.textColor = self.textColoring;
        _descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.editable = NO;
        _descriptionLabel.hidden = YES;
        
        self.selected = NO;
        
        [self addSubview:_descriptionLabel];
        _checkMark = [[UIButton alloc] initWithFrame:CGRectMake(width*0.85, height*0.25, 35, 35)];
        [_checkMark addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage* bigChecked = [UIImage imageNamed:@"black_check.png"];
        checked = [UIImage imageWithCGImage:[ bigChecked CGImage] scale:bigChecked.scale*10 orientation:bigChecked.imageOrientation];
        UIImage* bigUnchecked = [UIImage imageNamed:@"black_plus.png"];
        unchecked = [UIImage imageWithCGImage:[bigUnchecked CGImage] scale:bigUnchecked.scale*10 orientation:bigUnchecked.imageOrientation];
        
        [_checkMark setImage:unchecked forState:UIControlStateNormal];
        
        _schoolInScope = YES;
        
        rsvp = [[UILabel alloc] initWithFrame:CGRectMake(width*0.65, height*0.9, width*0.5, height*.35)];
        rsvp.font = [UIFont fontWithName:@"Helvetica" size:12];
        
        
        // add these labels to the view
        [self addSubview:_eventNameLabel];
        [self addSubview:_locationLabel];
        [self addSubview:_switchesLabel];
        [self addSubview:_timeLabel];
        [self addSubview:_checkMark];
        [self addSubview:rsvp];
        
    }
    return self;
}

-(void) setPartyScope {
    PFUser *curr = [PFUser currentUser];
    schoolName = [curr objectForKey:@"school"];
    
    if ([_openToArray containsObject:schoolName]) {
        NSLog(@"School in scope");
        _checkMark.alpha = 1.0;
        _schoolInScope = YES;
    } else {
        NSLog(@"School not in scope");
        _checkMark.alpha = 0.2;
        _schoolInScope = NO;
    }
    
}

// This method sets an event cell's attendance checkmark to a check if a user created the event
-(void) setChecked {
    PFUser *curr = [PFUser currentUser];
    NSMutableArray* eventsCreated = [curr objectForKey:@"eventsCreated"];
    if ([eventsCreated containsObject:_objectid]) {
        NSLog(@"User created this party, so initially they are attending");
        [_checkMark setImage:checked forState:UIControlStateNormal];
    } // Otherwise, user did not create party and we don't need to do anything
}

-(void) setUpRSVP {
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserEvents"];
    [query getObjectInBackgroundWithId:_objectid block:^(PFObject *currentEvent, NSError *error) {
        if (!error) {
            // Do something with the returned PFObject in the gameScore variable.
            NSLog(@"Event grabbed successfully");
            thisEvent = currentEvent;
        }
        else {
            NSLog(@"Not successful");
        }
    }];
    
    [self updateRSVPText];    
}

// Called upon refresh and when someone says they're attending an event
-(void) updateRSVPText {
    [thisEvent refreshInBackgroundWithBlock:^(PFObject* thisEvent, NSError* error){
        if (error)
            NSLog(@"Error: %@", error.localizedFailureReason);
    }];
    int attendees = [thisEvent[@"rsvpCount"] intValue];
    if (attendees == 1) {
        rsvp.text = [NSString stringWithFormat:@"%i person is going", attendees];
    } else {
        rsvp.text = [NSString stringWithFormat:@"%i people are going", attendees];
    }
    
}

// This method determines what to do when you try to attend an event
-(void) buttonPressed{
    if (_schoolInScope) {
        [thisEvent refresh];
        if (_checkMark.imageView.image == unchecked){
            [_checkMark setImage:checked forState:UIControlStateNormal];
            [thisEvent incrementKey:@"rsvpCount"];
        }else{
            [_checkMark setImage:unchecked forState:UIControlStateNormal];
            [thisEvent incrementKey:@"rsvpCount" byAmount:@-1];
        }
        [thisEvent saveInBackground];
        [self updateRSVPText];
    } else {
        NSString *title = [NSString stringWithFormat:@"Event not open to %@", schoolName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Consider contacting someone that can put you on the guest list directly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}


-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    
    CGFloat height = self.frame.size.height-5;
    
    _descriptionLabel.frame =  CGRectMake(0, height*.95, width, height);
    _descriptionLabel.hidden = NO;
}
@end
