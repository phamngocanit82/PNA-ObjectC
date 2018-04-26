#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomLabel : UILabel
@property(copy)IBInspectable NSString *keyLang;
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(assign)IBInspectable NSInteger borderWidth;
@property(assign)IBInspectable CGFloat cornerRadius;
@property IBInspectable BOOL drawBorder;
@property IBInspectable BOOL drawOutline;
@property IBInspectable BOOL drawGradient;
@property(copy) NSString *trimming;
@end
