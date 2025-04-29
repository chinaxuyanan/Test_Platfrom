//
//  SlotModel.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import <Foundation/Foundation.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kTimeDidUpdateNotification;

@interface SlotModel : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *slot;
@property (nonatomic, copy) NSString *sn;

@property (nonatomic, assign) TestStatus status;
@property (nonatomic, copy) NSString *statusString;


@property (nonatomic, copy) NSString *logFile;
@property (nonatomic, copy) NSString *log;

@property (nonatomic, copy) NSString *formattedDuration; //格式化持续时间
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *gress;

- (void) startTiming;
- (void) stopTiming;
//- (void) resetTiming;

@end

NS_ASSUME_NONNULL_END
