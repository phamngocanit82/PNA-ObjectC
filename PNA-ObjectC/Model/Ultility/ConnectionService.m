@interface ConnectionService(){
@private
    NSMutableData *responseData;
    NSURLSessionDataTask * dataTask;
    NSURLSession *defaultSession;
}
@end
@implementation ConnectionService
-(id)init {
    if (self = [super init]) {
        self.strMethod = @"POST";
        self.strTable = @"";
        self.strParam = @"";
        self.strUrlRequest = @"";
    }
    return self;
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
    if(self.response){
        self.response = nil;
    }
}
-(void)postDataToServer:(NSDictionary*)dic localDatabase:(BOOL)flag withLocalDatabase:(void(^) (NSMutableDictionary* response))callLocalDatabase withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.callbackLocalDatabase = callLocalDatabase;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    [self cancel];
    self.isRequesting = YES;
    if (flag==TRUE)
        [self localDatabase];
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
        json_data = [json_data stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[json_data length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[json_data dataUsingEncoding:NSUTF8StringEncoding]];
    }
   
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 40;
    defaultConfigObject.timeoutIntervalForResource = 65;
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    dataTask = [defaultSession dataTaskWithRequest:request];
    [dataTask resume];
}
-(void)localDatabase{
    if(!self.response)
        self.response = [[NSMutableDictionary alloc] init];
    if ([self.strTable isEqualToString:@"table_setting_items"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *strQuery = [NSString stringWithFormat:@"SELECT content FROM %@",self.strTable];
            __block NSString *responseString = [SQLiteService getContentData:strQuery DBName:@"PNA1.db"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([responseString length]>0&&self.response) {
                    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:responseString error:nil];
                    self.response = [NSMutableDictionary dictionaryWithDictionary: dic];
                    if(self.isRequesting == YES)
                        self.callbackLocalDatabase(self.response);
                    strQuery = nil;
                    responseString = nil;
                }
            });
        });
    }else if([self.strTable isEqualToString:@"table_dashboard"]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *strQuery = [NSString stringWithFormat:@"SELECT content FROM %@ WHERE param='%@'",self.strTable,self.strParam];
            __block NSString *responseString = [SQLiteService getContentData:strQuery DBName:@"PNA2.db"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([responseString length]>0&&self.response) {
                    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:responseString error:nil];
                    self.response = [NSMutableDictionary dictionaryWithDictionary: dic];
                    if(self.isRequesting == YES)
                        self.callbackLocalDatabase(self.response);
                    strQuery = nil;
                    responseString = nil;
                }
            });
        });
    }
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
    if(!responseData)
        responseData = [[NSMutableData alloc] init];
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    if(!responseData)
        responseData = [[NSMutableData alloc] init];
    [responseData appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error == nil&&responseData){
        if(dataTask){
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSDictionary dictionaryWithJSONString:responseString error:nil];
            if(dic){
                if([[dic valueForKey:@"status"] integerValue] == -200){
                    self.callbackError();
                    return;
                }
                [self parseString:responseString];
            }else
                [self failConnection];
            responseString = nil;
        }
    }else{
        if(error.code==-1009||error.code==-1001||error.code==-1003){
            [self failConnection];
        }
    }
}
-(void)failConnection{
    if(dataTask){
        self.isRequesting = YES;
        self.callbackError();
        [CacheService destroyNetworkCache];
    }
}
-(void)parseString:(NSString*)responseString{
    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:responseString error:nil];
    self.isRequesting = NO;
    if(!self.response)
        self.response = [[NSMutableDictionary alloc] init];
    
    if ([self.strTable isEqualToString:@"table_setting_items"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@",self.strTable];
            if (![SQLiteService isExistQueryData:strQuery DBName:@"PNA1.db"]) {
                [SQLiteService insert:self.strTable Data:[NSDictionary dictionaryWithObjectsAndKeys:responseString, @"content",nil] Fields:@"content" DBName:@"PNA1.db"];
            }else{
                [SQLiteService update:self.strTable Data:[NSDictionary dictionaryWithObjectsAndKeys:responseString, @"content",nil] DBName:@"PNA1.db"];
            }
            strQuery = nil;
        });
    }else if([self.strTable isEqualToString:@"table_dashboard"]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE param='%@'",self.strTable,self.strParam];
            if (![SQLiteService isExistQueryData:strQuery DBName:@"PNA2.db"]) {
                [SQLiteService insert:self.strTable Data:[NSDictionary dictionaryWithObjectsAndKeys:self.strParam, @"param", responseString, @"content",nil] Fields:@"param,content" DBName:@"PNA2.db"];
            }else{
                [SQLiteService updateParam:self.strTable Data:[NSDictionary dictionaryWithObjectsAndKeys:self.strParam, @"param", responseString, @"content",nil] DBName:@"PNA2.db"];
            }
            strQuery = nil;
        });
    }
    self.response = [NSMutableDictionary dictionaryWithDictionary: dic];
    self.callbackComplete(self.response);
    [CacheService destroyNetworkCache];
    responseString = nil;
}
@end
