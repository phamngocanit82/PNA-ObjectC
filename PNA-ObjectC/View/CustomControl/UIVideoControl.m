#import <AVFoundation/AVFoundation.h>
@interface UIVideoControl (){
@private
    WKWebViewControl *videoWKWebView;
    UIActivityIndicatorView *activityIndicatorView;
}
@end
@implementation UIVideoControl
-(void)initVideo{
    self.backgroundColor = [UIColor blackColor];
    videoWKWebView = [[WKWebViewControl alloc] initWithFrame:self.frame];
    [self addSubview:videoWKWebView];
    
    [videoWKWebView setBackgroundColor:[UIColor clearColor]];
    [videoWKWebView setOpaque:NO];
    [videoWKWebView setNavigationDelegate:self];
    [videoWKWebView setUIDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubePlayed:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.frame = CGRectMake((self.frame.size.width-activityIndicatorView.frame.size.width)/2, (self.frame.size.height-activityIndicatorView.frame.size.height)/2, activityIndicatorView.frame.size.width, activityIndicatorView.frame.size.height);
    [activityIndicatorView startAnimating];
    [self addSubview:activityIndicatorView];
}
-(void)play:(NSString*)youtubeId{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
     NSString *html = @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"><html><head><META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/> <meta name=\"viewport\" content=\"initial-scale=1.0\"/> <style>body{background-color:transparent;margin:0px;font-family: '%@'; font-size: 14px;}</style></head><body><script type=\"text/javascript\" src=\"http://www.youtube.com/iframe_api\"></script><script type=\"text/javascript\">var ytplayer;function onYouTubeIframeAPIReady() {ytplayer = new YT.Player('playerId', {events: {'onStateChange': onPlayerStateChange}});}function onPlayerStateChange(event) {if (event.data == YT.PlayerState.ENDED) {endedMovie();} function endedMovie() {document.location.href=\"milourlscheme://video-ended\";}}</script><iframe id=\"playerId\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/%@?enablejsapi=1&rel=0&controls=0&playsinline=1&autohide=1&vq=hd1080\" frameborder=\"0\" allowfullscreen=\"true\"> </body> </html>";
    html = [NSString stringWithFormat:html, [UtilsFont fontName], videoWKWebView.frame.size.width, videoWKWebView.frame.size.height, youtubeId];
    [videoWKWebView loadHTMLString:html baseURL:nil];
}
-(void)clear{
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
    activityIndicatorView = nil;
    
    [videoWKWebView evaluateJavaScript:@"ytplayer.stopVideo()" completionHandler:nil];
    [videoWKWebView loadHTMLString:@"" baseURL:nil];
    [videoWKWebView stopLoading];
    [videoWKWebView setNavigationDelegate:nil];
    [videoWKWebView setUIDelegate:nil];
    [videoWKWebView removeFromSuperview];
    videoWKWebView = nil;
    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    appDelegate.fullScreenYouTube = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)youTubeStarted:(NSNotification *)notification{
    appDelegate.fullScreenYouTube = YES;
}
-(void)youTubeFinished:(NSNotification *)notification{
    appDelegate.fullScreenYouTube = NO;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(youTubePlayed:)]) {
        [self.delegate youTubePlayed:self];
    }
}
-(void)youTubePlayed:(NSNotification *)notification{
    if (self.delegate && [self.delegate respondsToSelector:@selector(youTubePlayed:)]) {
        [self.delegate youTubePlayed:self];
    }
}
- (void) webView: (WKWebView *) webView didFailNavigation: (WKNavigation *) navigation withError: (NSError *) error{
}
- (void) webView: (WKWebView *) webView didFinishNavigation: (WKNavigation *) navigation{
    activityIndicatorView.hidden = YES;
    [videoWKWebView evaluateJavaScript:@"ytplayer.playVideo()" completionHandler:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}
- (void) webView: (WKWebView *) webView decidePolicyForNavigationAction: (WKNavigationAction *) navigationAction decisionHandler: (void (^)(WKNavigationActionPolicy)) decisionHandler{
    if ([[[navigationAction request].URL absoluteString] rangeOfString:@"milourlscheme://video-ended"].location != NSNotFound){
        if (self.delegate && [self.delegate respondsToSelector:@selector(youTubePlayed:)]) {
            [self.delegate youTubePlayed:self];
        }
    }
    if ([[[navigationAction request].URL absoluteString] rangeOfString:@"youtube.com/watch?time_continue"].location != NSNotFound||[[[navigationAction request].URL absoluteString] rangeOfString:@"youtube.com/watch?v="].location != NSNotFound){
        decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
    }
    decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
}
- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request{
    return YES;
}
@end
