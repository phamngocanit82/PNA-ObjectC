#import <Foundation/Foundation.h>
@interface SQLiteService : NSObject
+(void)initDatabase;

+(void)createTable:(NSString*)strTable Fields:(NSString*)strFields DBName:(NSString*)strDbName;

+(BOOL)isExist:(NSString*)strTable DBName:(NSString*)strDbName;

+(BOOL)isExistQueryData:(NSString*)sqlQuery DBName:(NSString*)strDbName;

+(void)update:(NSString*)strTable Data:(NSDictionary*)data DBName:(NSString*)strDbName;

+(void)updateParam:(NSString*)strTable Data:(NSDictionary*)data DBName:(NSString*)strDbName;

+(void)insert:(NSString*)strTable Data:(NSDictionary*)data Fields:(NSString*)strFields DBName:(NSString*)strDbName;

+(void)deleteData:(NSString*)strTable DBName:(NSString*)strDbName;

+(void)deleteDataWithFilter:(NSString*)strTable contestId:(NSString*)contestIdStr DBName:(NSString*)strDbName;

+(BOOL)isTableExist:(NSString*)strTable DBName:(NSString*)strDbName;

+(void)getData:(NSString*)strTable Data:(NSMutableArray **)data Fields:(NSString*)strFields DBName:(NSString*)strDbName;

+(void)getQueryData:(NSMutableArray **)data Fields:(NSString*)strFields Query:(NSString*)sqlQuery DBName:(NSString*)strDbName;

+(NSString*)getContentData:(NSString*)sqlQuery DBName:(NSString*)strDbName;
@end
