//
//  UIPlaceHolderTextView.h
//  5CNotify
//
//  Created by Macbook 23 on 3/29/14.
// Taken from Jason George stackoverflow
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
