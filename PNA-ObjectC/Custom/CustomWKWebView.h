#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface CustomWKWebView : WKWebView
@property(copy, nonatomic)IBInspectable NSString *keyLang;

-(void)setHTML:(NSString*)str;

-(void)clear;
@end
