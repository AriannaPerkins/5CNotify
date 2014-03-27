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
        
        // make label for the time of the event
        _timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.7,width, height*0.3)];
        
        //timeLabel.text = [NSString stringWithFormat:@"%@ to %@",startDateString,endDateString];
        _timeLabel.textColor = self.textColoring;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
        
        // add these labels to the view
        [self addSubview:_eventNameLabel];
        [self addSubview:_locationLabel];
        [self addSubview:_timeLabel];
        
    }
    return self;
}

-(void)returnToNormalView{
    
    CGFloat height = 55;
    
    // make label for the event
    self.eventNameLabel.frame = CGRectMake(5, height*0.05, width, height*0.4);
    
    
    // make label for the location of the event
    self.locationLabel.frame = CGRectMake(5, height*0.42,width,height*0.3);
    
    // make label for the time of the event
    _timeLabel.frame = CGRectMake(5, height*0.7,width, height*0.3);
    
    [_descriptionLabel removeFromSuperview];
}

-(void) longView:(CGFloat) currHeight{
    
    CGFloat height = currHeight-5;
    
    // make label for the event
    self.eventNameLabel.frame =CGRectMake(5, height*0.04, width, height*0.3);
    
    // make label for the location of the event
    self.locationLabel.frame = CGRectMake(5, height*0.33,width,height*0.18);
    
    // make label for the time of the event
    _timeLabel.frame = CGRectMake(5, height*0.54,width,  height*0.15);
    
    _descriptionLabel = [[UITextView alloc] initWithFrame: CGRectMake(0, height*0.63, width, height*0.55)];
    _descriptionLabel.textColor = self.textColoring;
    _descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.editable = NO;
    
    [self addSubview:_descriptionLabel];
}

@end
