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
        _switchesLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
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
        
        UIImage* icon = [UIImage imageNamed:@"Icon-Small.png"];
        UIImage* profile = [UIImage imageNamed:@"profile_pic.png"];
        _checkMark = [[UIImageView alloc] initWithImage: [UIImage imageWithCGImage:[icon CGImage] scale:icon.scale*0.4 orientation:icon.imageOrientation] highlightedImage:[UIImage imageWithCGImage:[ profile CGImage] scale:profile.scale*0.2 orientation:profile.imageOrientation]];
        _checkMark.frame = CGRectMake(width*0.85, height*0.25, 35, 35);
        
        // add these labels to the view
        [self addSubview:_eventNameLabel];
        [self addSubview:_locationLabel];
        [self addSubview:_switchesLabel];
        [self addSubview:_timeLabel];
        [self addSubview:_checkMark];
        
    }
    return self;
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    
    CGFloat height = self.frame.size.height-5;
    
    _descriptionLabel.frame =  CGRectMake(0, height*.95, width, height);
    _descriptionLabel.hidden = NO;
}
@end
