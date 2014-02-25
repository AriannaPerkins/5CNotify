//
//  EventCell.m
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import "EventCell.h"

@implementation EventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCellNumber: (int) cellNum;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellNum = cellNum;
        
        CGRect frame = self.viewForBaselineLayout.frame;
        
        UIColor* green = [UIColor colorWithRed: 95.0/ 255.0
                                         green:(float) 190.0/ 255.0
                                          blue:(float) 20.0/ 255.0 alpha:1.0];
        UIColor* lightGreen = [UIColor colorWithRed: 200.0/255.0
                                              green:(float) 240.0/255.0
                                               blue:(float) 160.0/255.0 alpha:1.0];
        
        // Cells in the table alternate between green and light green
        if (self.cellNum % 2 == 0){
            self.backgroundColor = lightGreen;
        }
        else if (self.cellNum % 2 == 1) {
            self.backgroundColor = green;
        }
        
        // make label for the event
        UILabel* eventNameLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.3)];
        eventNameLabel.text = [NSString stringWithFormat:@"Foam Party"];
        eventNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        eventNameLabel.textAlignment = NSTextAlignmentLeft;
        self.eventName = eventNameLabel;
        
        // make label for the location of the event
        UILabel* locationLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.35, frame.size.width, frame.size.height*0.25)];
        locationLabel.text = [NSString stringWithFormat:@"Harvey Mudd College, North Dorm"];
        locationLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        self.location = locationLabel;
        
        // make label for the time of the event
        UILabel* timeLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.7, frame.size.width, frame.size.height*0.25)];
        timeLabel.text = [NSString stringWithFormat:@"9:00 PM - 1:00 AM"];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        self.time = timeLabel;
        
        // add these labels to the view
        [self addSubview:eventNameLabel];
        [self addSubview:locationLabel];
        [self addSubview:timeLabel];    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
