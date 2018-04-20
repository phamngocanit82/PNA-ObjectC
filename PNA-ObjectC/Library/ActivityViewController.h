#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIActivityViewController (Private)
-(BOOL)_shouldExcludeActivityType:(UIActivity*)activity;
@end
@interface ActivityViewController : UIActivityViewController
@end
