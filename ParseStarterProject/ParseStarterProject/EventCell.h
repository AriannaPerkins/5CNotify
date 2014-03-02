//
//  EventCell.h
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property(nonatomic, retain)  NSString *eventName;
@property(nonatomic, retain)  NSString *location;
@property(nonatomic, retain)  NSDate *startTime;
@property(nonatomic, retain)  NSDate *endTime;
@property(nonatomic, retain)  UIImage *checkMark;
@property(nonatomic, retain)  UIColor *textColoring;
@property(nonatomic, retain)  UIColor *cellBackgroundColor;
@property(nonatomic, retain)  NSString *description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (id)initLongWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



@end
