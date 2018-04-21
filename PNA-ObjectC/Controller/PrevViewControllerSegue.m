#import "PrevViewControllerSegue.h"
@implementation PrevViewControllerSegue
-(void)perform{
    UIViewController *src = (UIViewController*)self.sourceViewController;
    if([self.identifier isEqualToString:@"actionNoAnimated"])
        [src.navigationController popViewControllerAnimated:NO];
    else
        [src.navigationController popViewControllerAnimated:YES];
}
@end
