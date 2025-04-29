//
//  LoadTestItem.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import <Foundation/Foundation.h>
#import <CHCSVParser/CHCSVParser.h>
#import "LogShare.h"
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoadTestItem : NSObject<CHCSVParserDelegate>

@property (nonatomic, strong) NSMutableArray<NSArray<NSString *> *> *parsedData;
@property (nonatomic, strong) NSMutableArray<NSString *> *currentLine;
@property (nonatomic, strong) NSMutableArray *testItems;

- (void) parseCSVFileAtPath:(NSString *)fileName;
+ (NSArray <NSString *> *)loadCSVLinesFromResource:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
