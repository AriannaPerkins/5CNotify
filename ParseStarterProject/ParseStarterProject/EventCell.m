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
        
        CGRect frame = self.viewForBaselineLayout.frame;
        self.textColoring = [UIColor blackColor];
        
        self.backgroundColor = self.cellBackgroundColor;
        
        // Format how the date looks
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        // make label for the event
        UILabel* eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.3)];
        eventNameLabel.text = [NSString stringWithFormat:@"Sample Party"];
        eventNameLabel.textColor = self.textColoring;
        eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        eventNameLabel.textAlignment = NSTextAlignmentLeft;
        self.eventName = @"Sample Party";
        
        // make label for the location of the event
        UILabel* locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.35, frame.size.width, frame.size.height*0.25)];
        NSString *location = @"Harvey Mudd College, North Dorm";
        locationLabel.text = [NSString stringWithFormat:@"%@",location];
        locationLabel.textColor = self.textColoring;
        locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        self.location = location;
        
        // make label for the time of the event
        UILabel* timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.7, frame.size.width, frame.size.height*0.25)];
        
        
        NSDate *startTime = [NSDate date];
        NSDate *endTime = [startTime dateByAddingTimeInterval:60*60*3];
        
        NSString *startDateString = [dateFormatter stringFromDate: startTime];
        NSString *endDateString   = [dateFormatter stringFromDate: endTime];
        
        timeLabel.text = [NSString stringWithFormat:@"%@ to %@",startDateString,endDateString];
        timeLabel.textColor = self.textColoring;
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        self.startTime = startTime;
        self.endTime = endTime;
        
        // add these labels to the view
        [self addSubview:eventNameLabel];
        [self addSubview:locationLabel];
        [self addSubview:timeLabel];    }
    return self;
}

- (id)initLongWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
        
        CGRect frame = self.viewForBaselineLayout.frame;
        self.textColoring = [UIColor blackColor];
        
        self.backgroundColor = self.cellBackgroundColor;
        
        
        // make label for the event
        UILabel* eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.3)];
        eventNameLabel.text = [NSString stringWithFormat:@"Sample LONG Party"];
        eventNameLabel.textColor = self.textColoring;
        eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        eventNameLabel.textAlignment = NSTextAlignmentLeft;
        self.eventName = @"Sample Party";
        
        // make label for the location of the event
        UILabel* locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.35, frame.size.width, frame.size.height*0.25)];
        NSString *location = @"Harvey Mudd College, North Dorm";
        locationLabel.text = [NSString stringWithFormat:@"%@",location];
        locationLabel.textColor = self.textColoring;
        locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        self.location = location;
        
        // make label for the time of the event
        UILabel* timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.7, frame.size.width, frame.size.height*0.25)];
        NSDate *time = [NSDate date];
        timeLabel.text = [NSString stringWithFormat:@"%@",time];
        timeLabel.textColor = self.textColoring;
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        self.startTime = time;
        
        // add these labels to the view
        [self addSubview:eventNameLabel];
        [self addSubview:locationLabel];
        [self addSubview:timeLabel];    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:YES];

    // Configure the view for the selected state
}

@end
