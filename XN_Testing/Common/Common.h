//
//  Common.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/23.
//

#ifndef Common_h
#define Common_h

#import <AppKit/AppKit.h>

#define TimeDidUpdateNotification @"TimeDidUpdateNotification"
#define CSVDidUpdateNotification @"TestProgressUpdateNotification"
#define ResultUpdateNotification @"ResultDidUpdateNotification"

typedef NS_ENUM(NSUInteger, TableViewColumnType) {
    TableViewColumnIndex,
    TableViewColumnSlot,
    TableViewColumnSN,
    TableViewColumnStatus,
    TableViewColumnLogFile,
    TableViewColumnLog,
    TableViewColumnTime,
    TableViewColumnGress
};

typedef NS_ENUM(NSUInteger, TestStatus) {
    TestStatusNotStarted,
    TestStatusTesting,
    TestStatusPassed,
    TestStatusFailed
};

typedef NS_ENUM(NSInteger, logType){
    LogTypeUI,
    LogTypeTest
};

static inline TableViewColumnType ColumnTypeForIdentifier(NSString *identifier) {
    static NSDictionary *columnMapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        columnMapping = @{
            @"index": @(TableViewColumnIndex),
            @"slot": @(TableViewColumnSlot),
            @"sn": @(TableViewColumnSN),
            @"status": @(TableViewColumnStatus),
            @"logFile": @(TableViewColumnLogFile),
            @"log": @(TableViewColumnLog),
            @"time": @(TableViewColumnTime),
            @"gress": @(TableViewColumnGress)
        };
    });
    
    NSNumber *typeNumber = columnMapping[identifier];
    return typeNumber ? [typeNumber unsignedIntegerValue] : TableViewColumnIndex;
}

static NSColor *DarkBlueColor(void) {
    return [NSColor colorWithRed:0.0 green:0.2 blue:0.4 alpha:1.0];
}

static NSColor *DarkGreenColor(void) {
    return [NSColor colorWithRed:0.0 green:0.4 blue:0.2 alpha:1.0];
}

#endif /* Common_h */
