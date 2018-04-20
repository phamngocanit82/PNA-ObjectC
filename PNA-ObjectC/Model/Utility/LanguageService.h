#import <Foundation/Foundation.h>
@interface LanguageService : NSObject
+(NSString *)language:(NSString*)key;
+(NSString *)language:(NSString*)key Text:(NSString*)text;
@end
