#import <AdSupport/ASIdentifierManager.h>
#import "TAGDataLayer.h"
#import "TAGManager.h"
@implementation Utils
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)playVideoInView:(UIView*)view{
    if (!player){
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *moviePath = [bundle pathForResource:VIDEO_MOV ofType:@"mov"];
        player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
        layer = [AVPlayerLayer layer];
        layer.player = player;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        [self performSelector:@selector(waitPlayvideo:) withObject:view afterDelay:0.01];
    }
}
-(void)waitPlayvideo:(UIView*)view{
    if(view){
        [layer setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [layer removeFromSuperlayer];
        [view.layer addSublayer:layer];
        [player play];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    }
}
-(void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
-(void)closeVideo{
    if(player){
        [player pause];
        [layer removeFromSuperlayer];
        layer = nil;
        player = nil;
    }
}
+(void)removeAllSubviews:(UIView *)view{
    if (!view)
        return;
    while ([[view subviews] count]) {
        [[[view subviews] objectAtIndex:0] removeFromSuperview];
    }
}
+(CGRect)resizeLabel:(UILabel *)label{
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    CGSize constraint = CGSizeMake(label.frame.size.width , 3000.0);
    CGSize size;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        if([label.attributedText length]==0)
            return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
        NSRange range = NSMakeRange(0, [label.attributedText length]);
        NSDictionary *attributes = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
        CGSize boundingBox = [label.text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else{
        size = [label.text sizeWithFont:label.font constrainedToSize:constraint lineBreakMode:label.lineBreakMode];
    }
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height);
}
+(CGFloat)resizeWidthLabel:(UILabel*)label{
    label.numberOfLines = 1;
    CGSize constraint = CGSizeMake(label.frame.size.width , label.frame.size.height);
    CGSize size;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        if([label.attributedText length]==0)
            return 0;
        NSRange range = NSMakeRange(0, [label.attributedText length]);
        NSDictionary *attributes = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
        CGSize boundingBox = [label.text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }else{
        size = [label.text sizeWithFont:label.font constrainedToSize:constraint lineBreakMode:label.lineBreakMode];
    }
    return size.width;
}
+(UIView*)getViewFromXibFile:(NSString *)xibFile RestorationIdentifier:(NSString*)restorationIdentifier{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:xibFile owner:nil options:nil];
    UIView *view;
    for (NSInteger i=0; i<[nibViews count]; i++) {
        view = [nibViews objectAtIndex:i];
        if ([view.restorationIdentifier isEqualToString:restorationIdentifier]) {
            return view;
        }
    }
    return nil;
}
+(NSString*)encodeStringToBase64:(NSString*)fromString{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    return base64String;
}
+(NSString *)identifierForAdvertising{
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        return [IDFA UUIDString];
    }
    return @"";
}
+(void)pushTA:(NSDictionary*)dic{
    
}
+(BOOL)checkEmail:(NSString*)strEmail{
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?:[a-zA-Z0-9!#$%\&'*+/=?\^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%\&'*+/=?\^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"];
    if(![regExPredicate evaluateWithObject:strEmail]){
        return FALSE;
    }
    return TRUE;
}
+(BOOL)checkNumeric:(NSString *)strText{
    for (int i = 0; i < [strText length]; i++) {
        char c = [strText characterAtIndex:i];
        if (c == ','||c == '.') {
            return YES;
        }
        if (!((c >= '0' && c <= '9'))) {
            return NO;
        }
    }
    return YES;
}
+(NSString*)strongPassword:(NSString *)strPass MaxLength:(NSInteger)maxLength{
    NSInteger resultLevel = 0;
    if ([strPass length] >= maxLength){
        int i = 0;
        while (i < [strPass length]){
            NSString* character = [strPass substringWithRange:NSMakeRange(i, 1)];
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                          initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
            NSUInteger matches = [regex numberOfMatchesInString:character options:0
                                                          range:NSMakeRange(0, [character length])];
            if (matches > 0){
                if ([character isEqualToString:[character uppercaseString]]) {
                    resultLevel++;
                    break;
                }
            }
            i++;
        }
        i = 0;
        while (i < [strPass length]){
            NSString* character = [strPass substringWithRange:NSMakeRange(i, 1)];
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                          initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
            NSUInteger matches = [regex numberOfMatchesInString:character options:0
                                                          range:NSMakeRange(0, [character length])];
            if (matches > 0){
                if ([character isEqualToString:[character lowercaseString]]) {
                    resultLevel++;
                    break;
                }
            }
            i++;
        }
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
        if([strPass rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location != NSNotFound){
            if([strPass rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789"]].location == NSNotFound||[strPass rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"]].location == NSNotFound){
                resultLevel++;
            }
        }
        if ([strPass rangeOfCharacterFromSet:set].location != NSNotFound){
            resultLevel++;
        }
    }
    else{
        resultLevel = 1;
    }
    return [NSString stringWithFormat:@"1;%@", [[NSNumber numberWithInteger:resultLevel] stringValue]];
}
+(NSString*)getNumberFormatter:(NSNumber*)value{
    NSNumberFormatter *formatterCurrency = [[NSNumberFormatter alloc] init];
    formatterCurrency.numberStyle = NSNumberFormatterDecimalStyle;
    [formatterCurrency setMaximumFractionDigits:DecimalDigit];
    if(CFNumberIsFloatType((CFNumberRef)value))
    return [NSString stringWithFormat:@"%@",[formatterCurrency stringFromNumber:@([value floatValue])]];
    else
    return [NSString stringWithFormat:@"%@",[formatterCurrency stringFromNumber:@([value integerValue])]];
}
@end
