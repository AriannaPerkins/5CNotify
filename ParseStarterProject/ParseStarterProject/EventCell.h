//
//  EventCell.h
//  Notify
//
//  Created by Paige Garratt on 2/24/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseStarterProjectViewController.h"

@interface EventCell : UITableViewCell

@property(nonatomic, retain)  UILabel *eventNameLabel;
@property(nonatomic, retain)  UILabel *locationLabel;
@property(nonatomic, retain)  UILabel *timeLabel;
@property(nonatomic, retain)  UILabel *switchesLabel;
@property(nonatomic, retain) NSMutableArray* openToArray;
@property(nonatomic, retain)  UIButton*checkMark;
@property(nonatomic, retain)  UIColor *textColoring;
@property(nonatomic, retain)  UIColor *cellBackgroundColor;
@property(nonatomic, retain)  UITextView *descriptionLabel;
@property(nonatomic, retain) NSString *objectid;
@property(nonatomic) BOOL schoolInScope;
@property(retain) ParseStarterProjectViewController* parseProjectViewController;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void) setUpRSVP;
-(void) setCheckMark;
-(void) updateRSVPText;
-(void) setPartyScope;
-(void) setChecked;
@end
