#import "RefreshTableHeaderController.h"
@implementation RefreshTableHeaderController
-(void)viewDidLoad{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self.view updateConstraints];
        [self.view updateConstraintsIfNeeded];
    }
    if (self.tableView && self.tableView.tag!=1000){
        if (self.egoRefreshTableHeaderView == nil) {
            self.egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            self.egoRefreshTableHeaderView.delegate = self;
            [self.tableView addSubview:self.egoRefreshTableHeaderView];
        }
        [self.egoRefreshTableHeaderView refreshLastUpdatedDate];
    }
}
-(void)reloadTableViewDataSource{
    self.reloading = YES;
}
-(void)doneLoadingTableViewData{
    self.reloading = NO;
    [self.egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
}
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if ([self respondsToSelector:@selector(scrollViewDidScroll)]){
        [self scrollViewDidScroll];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    if ([self respondsToSelector:@selector(reloadTable)]){
        [self reloadTable];
    }
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return self.reloading;
}
@end
