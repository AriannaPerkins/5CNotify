//
//  Event.m
//  5CNotify
//
//  Created by Paige Garratt on 3/9/14.
//
//

#import "Event.h"

@implementation Event

-(id)initWith:(NSString*)eventName andLoc: (NSString*) eventLoc andStart: (NSDate*) startTime andEnd: (NSDate*) endTime andDesciption: (NSString*) descript{
    if (self=[super init]) {
        _name = eventName;
        _location = eventLoc;
        _start = startTime;
        _end = endTime;
        _description = descript;
    }
    return self;
}

@end
