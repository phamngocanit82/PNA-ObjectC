#import <Foundation/Foundation.h>
@interface UtilsCache : NSObject
+(void)clearWithKey:(NSString*)strKey;

+(void)setKeyWithBool:(NSString*)strKey Value:(BOOL)boolValue;

+(void)setKeyWithInt:(NSString*)strKey Value:(NSInteger)intValue;

+(void)setKeyWithFloat:(NSString*)strKey Value:(CGFloat)floatValue;

+(void)setKeyWithDouble:(NSString*)strKey Value:(double)doubleValue;

+(void)setKeyWithString:(NSString*)strKey Value:(NSString*)strValue;

+(void)setKeyWithDictionary:(NSString*)strKey Value:(NSMutableDictionary*)dicValue;

+(BOOL)getKeyWithBool:(NSString*)strKey;

+(NSInteger)getKeyWithInt:(NSString*)strKey;

+(CGFloat)getKeyWithFloat:(NSString*)strKey;

+(double)getKeyWithDouble:(NSString*)strKey;

+(NSString*)getKeyWithString:(NSString*)strKey;

+(NSMutableDictionary*)getKeyWithDictionary:(NSString*)strKey;

+(void)destroyNetworkCache;
@end
