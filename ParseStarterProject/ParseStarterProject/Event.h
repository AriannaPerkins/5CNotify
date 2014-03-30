//
//  Event.h
//  5CNotify
//
//  Created by Paige Garratt on 3/9/14.
//
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* location;
@property(nonatomic,retain) NSDate* start;
@property(nonatomic,retain) NSDate* end;
@property(nonatomic,retain) NSString* description;
@property(nonatomic,retain) NSMutableArray* openToArray;

-(id)initWith:(NSString*)eventName andLoc: (NSString*) eventLoc andStart: (NSDate*) startTime andEnd: (NSDate*) endTime andDescription: (NSString*) descript andOpenTo: (NSMutableArray*)openTo;

@end
