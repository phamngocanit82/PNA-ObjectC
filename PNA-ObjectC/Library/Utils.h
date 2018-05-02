#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
@interface Utils : NSObject{
    AVPlayer *player;
    AVPlayerLayer *layer;
}
+(instancetype)sharedInstance;

-(void)playVideoInView:(UIView*)view;

-(void)closeVideo;

+(void)removeAllSubviews:(UIView *)view;

+(CGRect)resizeLabel:(UILabel *)label;

+(CGFloat)resizeWidthLabel:(UILabel*)lbl;

+(UIView*)getViewFromXibFile:(NSString *)xibFile RestorationIdentifier:(NSString*)restorationIdentifier;

+(void)setTextFromDate:(UILabel*)label Date:(NSDate*)date;

+(void)setTextDMYFromDate:(UILabel*)label Date:(NSDate*)date;

+(NSString*)getTextDMFromDate:(NSDate*)date;

+(NSString*)encodeStringToBase64:(NSString*)fromString;

+(NSString *)identifierForAdvertising;

+(void)pushTA:(NSDictionary*)dic;

+(BOOL)checkEmail:(NSString*)strEmail;

+(NSString *)strongPassword:(NSString *)strPass MaxLength:(NSInteger)maxLength;

+(BOOL)checkNumeric:(NSString *)strText;

+(NSString*)getNumberFormatter:(NSNumber*)value;

+(void)log:(NSString *)strText;
@end
