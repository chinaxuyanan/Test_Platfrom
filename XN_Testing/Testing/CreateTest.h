//
//  CreateTest.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import <Foundation/Foundation.h>
#import "SlotModel.h"
#import "TestFunction.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateTest : NSObject {
    dispatch_queue_t _testQueue;
    void (^_completionBlock)(BOOL);
}

@property (assign, nonatomic) BOOL isRunning;
@property (assign, nonatomic) NSInteger currentTestIndex;
@property (nonatomic, weak) SlotModel *slotModel;
@property (nonatomic, strong) NSArray <NSDictionary *> *testItems;

- (instancetype) initWithSlotModel:(SlotModel *)model;
- (void) startTestWithCompletion:(void (^)(BOOL isPassed)) completion;
- (void) cancelTest;

@end

NS_ASSUME_NONNULL_END
