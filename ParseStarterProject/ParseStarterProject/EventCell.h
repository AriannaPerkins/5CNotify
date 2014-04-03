//
//  EventCell.h
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property(nonatomic, retain)  UILabel *eventNameLabel;
@property(nonatomic, retain)  UILabel *locationLabel;
@property(nonatomic, retain)  UILabel *timeLabel;
@property(nonatomic, retain)  UILabel *switchesLabel;
@property(nonatomic, retain)  UIImageView *checkMark;
@property(nonatomic, retain)  UIColor *textColoring;
@property(nonatomic, retain)  UIColor *cellBackgroundColor;
@property(nonatomic, retain)  UITextView *descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
