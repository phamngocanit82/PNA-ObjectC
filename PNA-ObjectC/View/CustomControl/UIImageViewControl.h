#import <UIKit/UIKit.h>
@interface UIImageViewControl : UIImageView
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(assign)IBInspectable NSInteger borderWidth;
@property(assign)IBInspectable CGFloat cornerRadius;
@property IBInspectable BOOL drawBorder;

-(void)imageWithPath:(NSString*)strPath;

-(void)backgroundWithPath:(NSString*)strPath;
@end
