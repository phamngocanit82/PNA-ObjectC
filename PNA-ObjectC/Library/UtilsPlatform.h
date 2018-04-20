#import <Foundation/Foundation.h>
@interface UtilsPlatform : NSObject
+(BOOL)is_iPad;

+(BOOL)is_Pad;

+(BOOL)is_Phone;

+(BOOL)is_iPad1;

+(BOOL)is_iPad2;

+(BOOL)is_iPad3;

+(BOOL)is_iPhone4;

+(BOOL)is_iPhone4S;

+(NSString*)platform;

+(NSString*)platformString;

+(CGFloat)getWidth;

+(CGFloat)getHeight;
@end
