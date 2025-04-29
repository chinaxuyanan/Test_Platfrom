//
//  LogShare.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import "LogShare.h"

@implementation LogShare

- (instancetype) initLogShare:(NSString *) baseFolderName {
    if (self = [super init]) {
        self.baseFolderName = baseFolderName;
    }
    return self;
}

- (void) writeLog:(NSString *)message type:(logType)type {
    NSString *logFolderName;
    NSString *logFileName;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy_MM_dd";
    NSString *timestampFile = [formatter stringFromDate:[NSDate date]];
    
    switch (type) {
        case LogTypeUI:
            logFolderName = [NSString stringWithFormat:@"%@ UILog", timestampFile];
            logFileName = @"UI.log";
            break;
        case LogTypeTest:
            logFolderName = [NSString stringWithFormat:@"%@ TestLog", timestampFile];
            logFileName = @"Test.log";
            break;
        default:
            break;
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if (!appName) {
        appName = @"XN_Testing";
    }
    
    NSString *logDirectory;
    if (self.baseFolderName) {
        NSString *baseDirectory = [[documentsPath stringByAppendingPathComponent:appName] stringByAppendingPathComponent:self.baseFolderName];
        logDirectory = [baseDirectory stringByAppendingPathComponent:logFolderName];
    } else {
        logDirectory = [[documentsPath stringByAppendingPathComponent:appName] stringByAppendingPathComponent:logFolderName];
    }
    NSString *logPath = [logDirectory stringByAppendingPathComponent:logFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDirectory]) {
        [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    formatter.dateFormat = @"yyyy_MM_dd HH:mm:sss";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    NSString *fullLog = [NSString stringWithFormat:@"[%@] %@ \n", timestamp, message];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    if (!fileHandle) {
        [fullLog writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[fullLog dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

@end
