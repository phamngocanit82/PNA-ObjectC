#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomImageView : UIImageView
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(assign)IBInspectable NSInteger borderWidth;
@property(assign)IBInspectable CGFloat cornerRadius;
@property IBInspectable BOOL drawBorder;

-(void)imageWithPath:(NSString*)strPath;

-(void)backgroundWithPath:(NSString*)strPath;
@end
