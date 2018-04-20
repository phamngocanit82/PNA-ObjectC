#import <AdSupport/ASIdentifierManager.h>
#import "PDKeychainBindings.h"
@implementation UtilsCache
//set key
+(void)clearWithKey:(NSString*)strKey{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:nil forKey:strKey];
}
+(void)setKeyWithBool:(NSString*)strKey Value:(BOOL)boolValue{
    strKey = [NSString stringWithFormat:@"Bool%@", strKey];
    NSString * str = [AESCrypt encrypt:[[NSNumber numberWithBool:boolValue] stringValue] password:PASS_AES_CRYPT];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:str forKey:strKey];
}
+(void)setKeyWithInt:(NSString*)strKey Value:(NSInteger)intValue{
    strKey = [NSString stringWithFormat:@"Int%@", strKey];
    NSString * str = [AESCrypt encrypt:[[NSNumber numberWithInteger:intValue] stringValue] password:PASS_AES_CRYPT];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:str forKey:strKey];
}
+(void)setKeyWithFloat:(NSString*)strKey Value:(CGFloat)floatValue{
    strKey = [NSString stringWithFormat:@"Float%@", strKey];
    NSString * str = [AESCrypt encrypt:[[NSNumber numberWithFloat:floatValue] stringValue] password:PASS_AES_CRYPT];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:str forKey:strKey];
}
+(void)setKeyWithDouble:(NSString*)strKey Value:(double)doubleValue{
    strKey = [NSString stringWithFormat:@"Double%@", strKey];
    NSString * str = [AESCrypt encrypt:[[NSNumber numberWithDouble:doubleValue] stringValue] password:PASS_AES_CRYPT];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:str forKey:strKey];
}
+(void)setKeyWithString:(NSString*)strKey Value:(NSString*)strValue{
    strKey = [NSString stringWithFormat:@"String%@", strKey];
    NSString * str = [AESCrypt encrypt:strValue password:PASS_AES_CRYPT];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:str forKey:strKey];
}
+(void)setKeyWithDictionary:(NSString*)strKey Value:(NSMutableDictionary*)dicValue{
    strKey = [NSString stringWithFormat:@"Dictionary%@", strKey];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dicValue options:0 error:&err];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str = [AESCrypt encrypt:str password:PASS_AES_CRYPT];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:str forKey:strKey];
}
//get key
+(BOOL)getKeyWithBool:(NSString*)strKey{
    strKey = [NSString stringWithFormat:@"Bool%@", strKey];
    if([[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey]!=nil){
        NSString *str = [AESCrypt decrypt:[[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey] password:PASS_AES_CRYPT];
        return [str boolValue];
    }
    return FALSE;
}
+(NSInteger)getKeyWithInt:(NSString*)strKey{
    strKey = [NSString stringWithFormat:@"Int%@", strKey];
    if([[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey]!=nil){
        NSString *str = [AESCrypt decrypt:[[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey] password:PASS_AES_CRYPT];
        return [str integerValue];
    }
    return -1;
}
+(CGFloat)getKeyWithFloat:(NSString*)strKey{
    strKey = [NSString stringWithFormat:@"Float%@", strKey];
    if([[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey]!=nil){
        NSString *str = [AESCrypt decrypt:[[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey] password:PASS_AES_CRYPT];
        return [str floatValue];
    }
    return -1;
}
+(double)getKeyWithDouble:(NSString*)strKey{
    strKey = [NSString stringWithFormat:@"Double%@", strKey];
    if([[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey]!=nil){
        NSString *str = [AESCrypt decrypt:[[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey] password:PASS_AES_CRYPT];
        return [str doubleValue];
    }
    return -1;
}
+(NSString*)getKeyWithString:(NSString*)strKey{
    strKey = [NSString stringWithFormat:@"String%@", strKey];
    if ([[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey]!=nil){
        return [AESCrypt decrypt:[[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey] password:PASS_AES_CRYPT];
    }
    return @"";
}
+(NSMutableDictionary*)getKeyWithDictionary:(NSString*)strKey{
    strKey = [NSString stringWithFormat:@"Dictionary%@", strKey];
    NSString *jsondata = [AESCrypt decrypt:[[PDKeychainBindings sharedKeychainBindings] objectForKey:strKey] password:PASS_AES_CRYPT];
    NSMutableDictionary *dic = [NSDictionary dictionaryWithJSONString:jsondata error:nil];
    return dic;
}

+(void)destroyNetworkCache{
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
    NSString *appID = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
    NSString *path = [NSString stringWithFormat:@"%@/%@/Cache.db-wal", caches, appID];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    path = [NSString stringWithFormat:@"%@/%@/Cache.db", caches, appID];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    path = [NSString stringWithFormat:@"%@/%@/Cache.db-shm", caches, appID];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
@end
