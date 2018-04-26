#import <UIKit/UIKit.h>
@class CustomVideo;
@protocol CustomVideoDelegate <NSObject>
-(void)webViewDidFinishLoad:(CustomVideo *)video;
-(void)youTubePlayed:(CustomVideo *)video;
@end

@interface CustomVideo : UIView<WKNavigationDelegate, WKUIDelegate>
@property (weak) IBOutlet id<CustomVideoDelegate> delegate;
@property (assign) BOOL closeVideo;

-(void)initVideo;

-(void)play:(NSString*)youtubeId;

-(void)clear;
@end
