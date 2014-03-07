//
//  EventCell.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "EventCell.h"

@implementation EventCell
UIColor* green;
UIColor* lightGreen;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        green = [UIColor colorWithRed: 95.0/ 255.0
                                green:(float) 190.0/ 255.0
                                 blue:(float) 20.0/ 255.0
                                alpha:1.0];
        lightGreen = [UIColor colorWithRed: 200.0/255.0
                                     green: 240.0/255.0
                                      blue: 160.0/255.0
                                     alpha: 1.0];
        
        
        CGFloat width = self.viewForBaselineLayout.frame.size.width;
        CGFloat height = self.viewForBaselineLayout.frame.size.height;
        
        self.textColoring = [UIColor blackColor];
        
        self.backgroundColor = self.cellBackgroundColor;
        
        // Format how the date looks
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        // make label for the event
        self.eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.05, width, height*0.5)];
        //self.eventNameLabel.text = [NSString stringWithFormat:@"Sample Party"];
        self.eventNameLabel.textColor = self.textColoring;
        self.eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.eventNameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        // make label for the location of the event
        self.locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.55,width,height*0.35)];
        //_locationLabel.text = [NSString stringWithFormat:@"%@",location];
        _locationLabel.textColor = self.textColoring;
        _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        
        // make label for the time of the event
        _timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(5, height*0.9,width, height*0.35)];
        
        //timeLabel.text = [NSString stringWithFormat:@"%@ to %@",startDateString,endDateString];
        _timeLabel.textColor = self.textColoring;
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
        _descriptionLabel = [[UITextView alloc] initWithFrame: CGRectMake(5, height*1.25, width, height*0.35)];
        _descriptionLabel.textColor = self.textColoring;
        _descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        
        // add these labels to the view
        [self addSubview:_eventNameLabel];
        [self addSubview:_locationLabel];
        [self addSubview:_timeLabel];
        [self addSubview:_descriptionLabel];
    }
    return self;
}

//- (id)initLongWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//        green = [UIColor colorWithRed: 95.0/ 255.0
//                                green:(float) 190.0/ 255.0
//                                 blue:(float) 20.0/ 255.0
//                                alpha:1.0];
//        lightGreen = [UIColor colorWithRed: 200.0/255.0
//                                     green: 240.0/255.0
//                                      blue: 160.0/255.0
//                                     alpha: 1.0];
//        
//        CGRect frame = self.viewForBaselineLayout.frame;
//        self.textColoring = [UIColor blackColor];
//        
//        self.backgroundColor = self.cellBackgroundColor;
//        
//        
//        // make label for the event
//        _eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.3)];
//        //_eventNameLabel.text = [NSString stringWithFormat:@"Sample LONG Party"];
//        _eventNameLabel.textColor = self.textColoring;
//        _eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
//        _eventNameLabel.textAlignment = NSTextAlignmentLeft;
//        
//        // make label for the location of the event
//       _locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.35, frame.size.width, frame.size.height*0.25)];
//        //_locationLabel.text = [NSString stringWithFormat:@"%@",location];
//        _locationLabel.textColor = self.textColoring;
//        _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
//        _locationLabel.textAlignment = NSTextAlignmentLeft;
//        
//        // make label for the time of the event
//        _timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.7, frame.size.width, frame.size.height*0.25)];
//        //timeLabel.text = [NSString stringWithFormat:@"%@",time];
//        _timeLabel.textColor = self.textColoring;
//        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
//        _timeLabel.textAlignment = NSTextAlignmentLeft;
//        
//        // add these labels to the view
//        [self addSubview:_eventNameLabel];
//        [self addSubview:_locationLabel];
//        [self addSubview:_timeLabel];    }
//    return self;
//}
//

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:YES];

    // Configure the view for the selected state
}

@end
