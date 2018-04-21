#import <UIKit/UIKit.h>
@class UIVideoControl;
@protocol UIVideoControlDelegate <NSObject>
-(void)webViewDidFinishLoad:(UIVideoControl *)video;
-(void)youTubePlayed:(UIVideoControl *)video;
@end

@interface UIVideoControl : UIView<WKNavigationDelegate, WKUIDelegate>
@property (weak) IBOutlet id<UIVideoControlDelegate> delegate;
@property (assign) BOOL closeVideo;

-(void)initVideo;

-(void)play:(NSString*)youtubeId;

-(void)clear;
@end
