//
//  Event.m
//  5CNotify
//
//  Created by Paige Garratt on 3/9/14.
//
//

#import "Event.h"

@implementation Event

-(id)initWith:(NSString*)eventName andLoc: (NSString*) eventLoc andStart: (NSDate*) startTime andEnd: (NSDate*) endTime andDescription: (NSString*) descript andOpenTo: (NSMutableArray*) openTo{
    if (self=[super init]) {
        _name = eventName;
        _location = eventLoc;
        _start = startTime;
        _end = endTime;
        _description = descript;
        _openToArray = openTo;
    }
    return self;
}

@end
