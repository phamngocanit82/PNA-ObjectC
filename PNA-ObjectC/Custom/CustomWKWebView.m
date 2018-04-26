@implementation CustomWKWebView
-(void)setHTML:(NSString*)str{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.scrollEnabled = NO;
        }
    }
    NSString *html =[NSString stringWithFormat:@"<html><meta name=\"viewport\" content=\"initial-scale=1.0\"/><head>"
                     "<link rel=\"stylesheet\" type=\"text/css\" href=\"webView.css\"><body>"
                     "<h1>%@</h1></body></html>", str];
    [self loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"webView" ofType:@"css"]]];
}
-(void)clear{
    [self setNavigationDelegate:nil];
    [self setUIDelegate:nil];
    [self setNavigationDelegate:nil];
    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self removeFromSuperview];
}
@end
