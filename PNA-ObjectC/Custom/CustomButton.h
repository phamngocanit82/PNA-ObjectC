#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomButton: UIButton
@property(copy)IBInspectable NSString *keyLang;
@property(copy)IBInspectable NSString *openScreenGTM;
@property(copy)IBInspectable NSString *categoryGTM;
@property(copy)IBInspectable NSString *actionGTM;
@property(copy)IBInspectable NSString *labelGTM;
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(assign)IBInspectable NSInteger borderWidth;
@property(assign)IBInspectable CGFloat cornerRadius;
@property IBInspectable BOOL drawBorder;
@property IBInspectable BOOL underline;
@property IBInspectable BOOL pushGTM;
@property IBInspectable BOOL redraw;
@property IBInspectable BOOL redrawSmall;

-(void)clearDrawing;

-(void)reDrawing;

-(void)imageWithPath:(NSString*)strPath;

-(void)backgroundWithPath:(NSString*)strPath;
@end
