//
//  CreateTest.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import "CreateTest.h"

@implementation CreateTest

- (instancetype) initWithSlotModel:(SlotModel *)model {
    if (self = [super init]) {
        _slotModel = model;
        _testQueue = dispatch_queue_create("com.test.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void) startTestWithCompletion:(void (^)(BOOL isPassed)) completion {
    if (self.isRunning) return;
    self.isRunning = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_slotModel startTiming];
        self->_slotModel.status = TestStatusTesting;
        if (completion) completion(NO);
    });
    
    TestFunction *engine = [[TestFunction alloc] initWithTestFunction:[TestFunction new]];
    
    dispatch_async(_testQueue, ^{
        //模拟测试过程
        LogShare *logger = [[LogShare alloc] initLogShare:self->_slotModel.sn];
        for (NSInteger i = 0; i < self.testItems.count; i++) {
            if (!self.isRunning) break;
            NSMutableDictionary *item = [self.testItems[i] mutableCopy];    item[@"_RowIndex"] = @(i);
            self->_slotModel.gress = [NSString stringWithFormat:@"%@,%@,%@",
                                      item[@"Test"],
                                      item[@"SubTest"],
                                      item[@"SubSubTest"]
            ];
            
            NSString *message = [NSString stringWithFormat:@"%@ | %@ | %@ | %@", self->_slotModel.slot, item[@"Test"], item[@"SubTest"], item[@"SubSubTest"]];
            [logger writeLog:message type:LogTypeTest];
            
            id result = [engine executeTestItem:item];
            
            NSString *resultMes = [NSString stringWithFormat:
                                @"┌──────────────────────────────────────┐\n"
                                @"│ %-12s: %-15@ │\n"
                                @"│ %-12s: %-15@ │\n"
                                @"│ %-12s: %-15@ │\n"
                                @"└──────────────────────────────────────┘",
                                "Function", item[@"Function"],
                                "Input", item[@"Input"],
                                "RESULT", result
            ];
            [logger writeLog:resultMes type:LogTypeTest];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CSVDidUpdateNotification object:@{
                @"sourceTest": self,
                @"gress": self->_slotModel.gress
            }];
        }
        //测试结果
        BOOL isPassed = self.isRunning && (arc4random_uniform(2) == 1);
        
//        回掉结果
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_slotModel.status = isPassed ? TestStatusPassed : TestStatusFailed;
            [self->_slotModel stopTiming];
            if (completion) completion(isPassed);
            self.isRunning = NO;
        });
    });
}

- (void) cancelTest {
    self.isRunning = NO;
    [self.slotModel stopTiming];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Check Test Function



@end
