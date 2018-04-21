#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@interface RefreshTableHeaderController : UIViewController<EGORefreshTableHeaderDelegate>
@property (strong, nonatomic) EGORefreshTableHeaderView *egoRefreshTableHeaderView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign) BOOL reloading;

-(void)reloadTable;

-(void)doneLoadingTableViewData;

-(void)scrollViewDidScroll;
@end
