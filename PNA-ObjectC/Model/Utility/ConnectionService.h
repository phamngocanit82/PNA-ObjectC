#import <Foundation/Foundation.h>
@interface ConnectionService : NSObject<NSURLSessionDelegate>
@property (strong, nonatomic) NSMutableDictionary *response;
@property (copy) NSString *strUrlRequest;
@property (copy) NSString *strParam;
@property (copy) NSString *strMethod;
@property (copy) NSString *strAction;
@property (copy) NSString *strTable;
@property (assign) BOOL isRequesting;
@property (copy, nonatomic) void (^ callbackLocalDatabase)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackError)(void);

-(void)postDataToServer:(NSDictionary*)dic localDatabase:(BOOL)flag withLocalDatabase:(void(^) (NSMutableDictionary* response))callLocalDatabase withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;

-(void)cancel;
@end
