#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WKWebViewControl : WKWebView
@property(copy, nonatomic)IBInspectable NSString *keyLang;

-(void)setHTML:(NSString*)str;

-(void)clear;
@end
