//
//  EventCell.h
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property(nonatomic) int cellNum;
@property(nonatomic, retain)  UILabel *eventName;
@property(nonatomic, retain)  UILabel *location;
@property(nonatomic, retain)  UILabel *time;
@property(nonatomic, retain)  UIImage *checkMark;


@end
