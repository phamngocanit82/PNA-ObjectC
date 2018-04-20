@implementation LanguageService
+(NSString *)language:(NSString*)key{
    return [LanguageService language:key Text:@""];
}
+(NSString *)language:(NSString*)key Text:(NSString*)text{
    NSArray* arrKey = [key componentsSeparatedByString:@"_"];
    NSString *fileName = [arrKey objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/Caches/language/%@.json", [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0], fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString * json_data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:json_data error:nil];
    key = [NSString stringWithFormat:@"%@_%@", LANGUAGE, key];
    
    if([dic valueForKey:key])
        text = [dic valueForKey:key];
    
    dic = nil;
    json_data = nil;
    data = nil;
    return text;
}
@end
