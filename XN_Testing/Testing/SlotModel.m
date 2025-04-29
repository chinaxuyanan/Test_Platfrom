//
//  SlotModel.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import "SlotModel.h"

@implementation SlotModel

- (instancetype) init {
    if (self = [super init]) {
        self.sn = @"";
        self.status = TestStatusNotStarted;
        self.logFile = @"Test File";
        self.log = @"Test.log";
        self.formattedDuration = @"";
        self.gress = @"";
    }
    return self;
}

- (NSString *)statusString {
    switch (_status) {
        case TestStatusTesting: return @"TESTING";
        case TestStatusPassed: return @"PASS";
        case TestStatusFailed: return @"FAIL";
        default: return @"NOTEST";
    }
}

- (void) startTiming {
    [self stopTiming];
    self.formattedDuration = @"00:00:00";
    self.startTime = [NSDate date];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void) stopTiming {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) resetTiming {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) updateTime {
    if (!self.startTime) {
        _formattedDuration = @"00:00:00";
        return;
    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.startTime];
    NSInteger hours = (NSInteger) interval / 3600;
    NSInteger minutes = ((NSInteger) interval % 3600) / 60;
    NSInteger seconds = (NSInteger) interval % 60;
    
    self.formattedDuration = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TimeDidUpdateNotification object:self];
}

- (void) dealloc {
    [self.timer invalidate];
}

@end
