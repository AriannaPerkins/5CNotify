
@interface ParseStarterProjectViewController : UIViewController

-(void) loadAddEventView;
-(void) openAddEventView;
-(void) loadEditEventView;
-(void) loadEditEventViewWithArguments:(NSString*)objectid;
-(void) openEditEventView;
-(void) openTableView;
-(void) loadTableView;
-(void) openProfileView;
-(void) loadProfileView;
-(void) openLoginView;
-(void) pop;

@end
