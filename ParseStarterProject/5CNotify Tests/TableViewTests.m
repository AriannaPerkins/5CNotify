//
//  TableViewTests.m
//  5CNotify
//
//  Created by Paige Garratt on 4/22/14.
//
//

#import "TableViewTests.h"
#import "TableViewController.h"
#import "Event.h"

@implementation TableViewTests

-(void)eventTest{
    NSDate* start = [NSDate date];
    NSDate* end = [NSDate dateWithTimeIntervalSinceNow:NSDayCalendarUnit];
    NSMutableArray* openTo = [[NSMutableArray alloc] initWithArray:@[@"HMC"]];
    Event* event = [[Event alloc] initWith:@"Party" andLoc:@"Platt" andStart:start andEnd:end andDescription:@"Fun Party" andOpenTo:openTo andRSVPCount:1 andObjectID:@"blah"];
    XCTAssertEqual(start, event.start, @"Start Times should match");
    XCTAssertEqual(@"Party", event.name, @"Names should match");
    XCTAssertNotEqual(event.name, event.description, @"Name should not match description");
}

@end
