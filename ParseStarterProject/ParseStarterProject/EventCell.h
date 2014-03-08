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
@property(nonatomic, retain)  UIImage *checkMark;
@property(nonatomic, retain)  UIColor *textColoring;
@property(nonatomic, retain)  UIColor *cellBackgroundColor;
@property(nonatomic, retain)  UITextView *descriptionLabel;
@property(nonatomic, retain)  UIView *cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void) returnToNormalView;
-(void) longView:(CGFloat) height;

@end
