//
//  EventCell.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "EventCell.h"

@implementation EventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textColoring = [UIColor blackColor];
        
        self.backgroundColor = [UIColor blackColor];
        
        _cellView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, self.viewForBaselineLayout.frame.size.width-4, 55)];
        _cellView.layer.cornerRadius = 5;
        _cellView.layer.masksToBounds = YES;
        
        CGFloat width = _cellView.frame.size.width;
        CGFloat height = _cellView.frame.size.height;
        
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
        [self addSubview:_cellView];
        [_cellView addSubview:_eventNameLabel];
        [_cellView addSubview:_locationLabel];
        [_cellView addSubview:_timeLabel];
        
    }
    return self;
}

-(void)returnToNormalView{
    
    _cellView.frame = CGRectMake(2, 2, self.viewForBaselineLayout.frame.size.width-4, 55);
    
    CGFloat width = _cellView.frame.size.width;
    CGFloat height = _cellView.frame.size.height;
    
    // make label for the event
    self.eventNameLabel.frame = CGRectMake(5, height*0.05, width, height*0.4);
    
    
    // make label for the location of the event
    self.locationLabel.frame = CGRectMake(5, height*0.42,width,height*0.3);
    
    // make label for the time of the event
    _timeLabel.frame = CGRectMake(5, height*0.7,width, height*0.3);
    
    [_descriptionLabel removeFromSuperview];
}

-(void) longView:(CGFloat) height{
    
    _cellView.frame = CGRectMake(2, 2, self.viewForBaselineLayout.frame.size.width-4, height-5);
    
    CGFloat width = _cellView.frame.size.width;
    CGFloat theHeight = _cellView.frame.size.height;
    
    // make label for the event
    self.eventNameLabel.frame =CGRectMake(5, theHeight*0.05, width, theHeight*0.2);
    
    // make label for the location of the event
    self.locationLabel.frame = CGRectMake(5, theHeight*0.25,width,theHeight*0.15);
    
    // make label for the time of the event
    _timeLabel.frame = CGRectMake(5, theHeight*0.42,width, theHeight*0.15);
    
    _descriptionLabel = [[UITextView alloc] initWithFrame: CGRectMake(0, _cellView.frame.size.height*0.5, _cellView.frame.size.width, _cellView.frame.size.height*0.55)];
    _descriptionLabel.textColor = self.textColoring;
    _descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.editable = NO;
    [_cellView addSubview:_descriptionLabel];
}

@end
