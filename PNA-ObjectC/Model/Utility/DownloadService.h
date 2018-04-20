#import <Foundation/Foundation.h>
@interface DownloadService : NSObject<NSURLSessionDelegate>
@property (copy) NSString *strUrlRequest;
@property (copy) NSString *strMethod;
@property (assign) BOOL isRequesting;
@property (copy, nonatomic) void (^ callbackProgress)(CGFloat progress);
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackError)(void);

-(void)postDataToServer:(NSDictionary*)dic withProgress:(void(^) (CGFloat progress))callProgress withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;

-(void)cancel;
@end
