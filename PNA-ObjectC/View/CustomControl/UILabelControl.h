#import <UIKit/UIKit.h>
@interface UILabelControl : UILabel
@property(copy, nonatomic)IBInspectable NSString *keyLang;

@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(assign, nonatomic)IBInspectable NSInteger borderWidth;
@property(assign, nonatomic)IBInspectable CGFloat cornerRadius;

@property IBInspectable BOOL drawBorder;
@property IBInspectable BOOL drawOutline;
@property IBInspectable BOOL drawGradient;
@end
