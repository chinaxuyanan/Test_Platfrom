//
//  TestFunction.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/29.
//

#import <Foundation/Foundation.h>
#import "LogShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestFunction : NSObject {
    TestFunction *_testFunction;
    NSInteger _currentRow;
}

- (instancetype) initWithTestFunction:(TestFunction *) testFunction;
//- (void) executeTestItem:(NSDictionary *) item;
- (id )executeTestItem:(NSDictionary *)item;

@end

NS_ASSUME_NONNULL_END
