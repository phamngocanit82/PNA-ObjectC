#import <UIKit/UIKit.h>
@interface UIViewControl : UIView
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(strong, nonatomic)IBInspectable UIColor *gradientFromColor;
@property(strong, nonatomic)IBInspectable UIColor *gradientToColor;
@property(assign, nonatomic)IBInspectable NSInteger borderWidth;
@property(assign, nonatomic)IBInspectable CGFloat cornerRadius;
@property IBInspectable BOOL drawBorder;
@property IBInspectable BOOL drawGradient;
@end