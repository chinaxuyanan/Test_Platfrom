//
//  LogShare.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import <Foundation/Foundation.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, logType){
//    LogTypeUI,
//    LogTypeTest
//};

@interface LogShare : NSObject

@property (strong, nonatomic) NSString *baseFolderName;

- (instancetype) initLogShare:(NSString *) baseFolderName;
- (void) writeLog:(NSString *)message type:(logType)type;
@end

NS_ASSUME_NONNULL_END
