#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomTextField : UITextField
@property(copy)IBInspectable NSString *keyPlaceHolder;
@property(copy) NSString *trimming;
@end
