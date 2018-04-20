#import "SSZipArchive.h"
@interface DownloadService(){
@private
    NSMutableData *responseData;
    NSURLSessionDataTask * dataTask;
    NSURLSession *defaultSession;
    CGFloat size;
}
@end
@implementation DownloadService
-(id)init {
    if (self = [super init]) {
        self.strMethod = @"POST";
    }
    return self;
}
-(void)postDataToServer:(NSDictionary*)dic withProgress:(void(^) (CGFloat progress))callProgress withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.callbackProgress = callProgress;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    [self cancel];
    self.isRequesting = YES;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.strUrlRequest] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setHTTPMethod:self.strMethod];
    NSString *strAuth = [NSString stringWithFormat:@"%@:%@", USERNAME, PASSWORD];
    NSData *authData = [strAuth dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    if (dic!=nil) {
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
        NSString * json_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        json_data = [NSString stringWithFormat:@"json_data=%@", json_data];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[json_data length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[json_data dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if(responseData){
        [responseData setData:[NSData dataWithBytes:NULL length:0]];
        [responseData setLength:0];
    }
    responseData = nil;
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 40;
    defaultConfigObject.timeoutIntervalForResource = 65;
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    dataTask = [defaultSession dataTaskWithRequest:request];
    [dataTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    size = [response expectedContentLength];
    completionHandler(NSURLSessionResponseAllow);
    if(!responseData)
        responseData = [[NSMutableData alloc] init];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    if(!responseData)
        responseData = [[NSMutableData alloc] init];
    [responseData appendData:data];
    CGFloat progress = (float)[responseData length] / size;
    self.callbackProgress(progress);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(error == nil&&responseData){
        if(dataTask){
            self.isRequesting = NO;
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Caches/language.zip",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]] error:NULL];
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Caches/language",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]] error:NULL];
            [responseData writeToFile:[NSString stringWithFormat:@"%@/Caches/language.zip",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]] atomically:YES];
            BOOL zip = [SSZipArchive unzipFileAtPath:[NSString stringWithFormat:@"%@/Caches/language.zip",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]]
                                       toDestination:[NSString stringWithFormat:@"%@/Caches/language",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]]];
            if(zip){
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Caches/language.zip",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]] error:NULL];
            }
            self.callbackComplete(nil);
            [CacheService destroyNetworkCache];
        }
    }else{
        if(error.code==-1009||error.code==-1001||error.code==-1003){
            if(dataTask){
                self.isRequesting = NO;
                self.callbackError();
                [CacheService destroyNetworkCache];
            }
        }
    }
}
-(void)cancel {
    if(dataTask){
        [dataTask cancel];
        [defaultSession finishTasksAndInvalidate];
        defaultSession = nil;
        dataTask = nil;
    }
    self.isRequesting = NO;
    if(responseData){
        [responseData setData:[NSData dataWithBytes:NULL length:0]];
        [responseData setLength:0];
        responseData = nil;
    }
}
@end
