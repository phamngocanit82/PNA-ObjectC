#import <sqlite3.h>
@implementation SQLiteService
+(void)initDatabase{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString * json_data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:json_data error:nil];
    NSMutableArray *list = [dic valueForKey:@"list"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    for (int i=0; i<[list count]; i++) {
        NSString *strPath = [NSString stringWithFormat:@"%@/Caches/%@_%@", [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0], LANGUAGE, [[list objectAtIndex:i] valueForKey:@"name"]];
        BOOL success = [fileManager fileExistsAtPath:strPath];
        if(!success) {
            NSString *file = [[NSBundle mainBundle] pathForResource:DATABASE_NAME ofType:nil];
            if (file){
                [[NSFileManager defaultManager] copyItemAtPath:file toPath:strPath error:&error];
            }
        }
        NSString *strDBName = [[list objectAtIndex:i] valueForKey:@"name"];
        NSMutableArray *tables = [[list objectAtIndex:i] valueForKey:@"tables"];
        for (int j=0; j<[tables count]; j++) {
            if (![self isTableExist:[[tables objectAtIndex:j] valueForKey:@"table"] DBName:strDBName]){
                [self createTable:[[tables objectAtIndex:j] valueForKey:@"table"] Fields:[[tables objectAtIndex:j] valueForKey:@"field"] DBName:strDBName];
            }
        }
    }
}
+(NSString*)getPathDB:(NSString*)strDbName{
    NSString *strPath = [NSString stringWithFormat:@"%@/Caches/%@_%@", [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0], LANGUAGE, strDbName];
    return strPath;
}
+(void)createTable:(NSString*)strTable Fields:(NSString*)strFields DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        char *errMsg;
        NSString *sqlQuery = [NSString stringWithFormat:@"create table if not exists %@(%@)",strTable,strFields];
        sqlite3_exec(database, [sqlQuery UTF8String], NULL, NULL, &errMsg);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(BOOL)isExist:(NSString*)strTable DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    BOOL check=FALSE;
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"select count(issued_date) from %@",strTable];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_ROW) {
                if(sqlite3_column_int(statement, 0)>0)
                    check = TRUE;
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return check;
}
+(void)deleteData:(NSString*)strTable DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"delete from %@",strTable];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)deleteDataWithFilter:(NSString*)strTable contestId:(NSString*)contestIdStr DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"delete from %@ where %@",strTable,contestIdStr];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(BOOL)isExistQueryData:(NSString*)sqlQuery DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    BOOL flag = FALSE;
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if(sqlite3_step(statement) == SQLITE_ROW) {
                flag = TRUE;
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return flag;
}
+(void)update:(NSString*)strTable Data:(NSDictionary*)data DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET content = ? ", strTable];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_bind_text(statement, 1, [[data valueForKey:@"content"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)updateParam:(NSString*)strTable Data:(NSDictionary*)data DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET content = ? WHERE param='%@'", strTable, [data valueForKey:@"param"]];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_bind_text(statement, 1, [[data valueForKey:@"content"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)insert:(NSString*)strTable Data:(NSDictionary*)data Fields:(NSString*)strFields DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    strFields = [strFields stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into %@(%@) ",strTable,strFields];
        NSArray *arrString = [strFields componentsSeparatedByString:@","];
        NSString *values=@"";
        for (int i=0; i<[arrString count]; i++) {
            if ([values length]==0){
                values = @"?";
            }else{
                values = [NSString stringWithFormat:@"%@,?",values];
            }
        }
        values = [NSString stringWithFormat:@"values(%@)",values];
        sqlQuery = [NSString stringWithFormat:@"%@%@",sqlQuery,values];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        int column = 0;
        for (; column<[arrString count]; column++){
            sqlite3_bind_text(statement,column+1,[[data objectForKey:[arrString objectAtIndex:column]]UTF8String],-1,SQLITE_TRANSIENT);
        }
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(BOOL)isTableExist:(NSString *)strTable DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    int count = 0;
    BOOL result = FALSE;
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'",strTable];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while( sqlite3_step(statement) == SQLITE_ROW ){
                count = sqlite3_column_int(statement, 0);
                if(count>0){
                    result = TRUE;
                }
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return result;
}
+(void)getData:(NSString*)strTable Data:(NSMutableArray **)data Fields:(NSString*)strFields DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    strFields = [strFields stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"select %@ from %@",strFields,strTable];
        NSArray *arrString = [strFields componentsSeparatedByString:@","];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *currentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                int column = 0;
                for (; column<[arrString count]; column++) {
                    [currentDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, column)] forKey:[arrString objectAtIndex:column]];
                }
                [*data addObject:currentDic];
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}
+(void)getQueryData:(NSMutableArray **)data Fields:(NSString*)strFields Query:(NSString*)sqlQuery DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    strFields = [strFields stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSArray *arrString = [strFields componentsSeparatedByString:@","];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *currentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                int column = 0;
                for (; column<[arrString count]; column++) {
                    [currentDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, column)] forKey:[arrString objectAtIndex:column]];
                }
                [*data addObject:currentDic];
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}
+(NSString*)getContentData:(NSString*)sqlQuery DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    NSString *strData = @"";
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [PASS_SQL UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if(sqlite3_step(statement) == SQLITE_ROW) {
                strData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return strData;
}
@end
