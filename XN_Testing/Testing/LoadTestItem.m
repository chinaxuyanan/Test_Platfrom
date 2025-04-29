//
//  LoadTestItem.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/16.
//

#import "LoadTestItem.h"


@implementation LoadTestItem

#pragma mark - Update Parse CSV File Code

- (void) parseCSVFileAtPath:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
    if (!fileName) {
//        [LogShare writeLog:[NSString stringWithFormat:@"❌ 找不到CSV文件: %@", fileName] type:LogTypeUI];
        
        return;
    }
    
    CHCSVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVURL:[NSURL fileURLWithPath:filePath]];
    parser.delegate = self;
    parser.sanitizesFields = YES;
    parser.trimsWhitespace = YES;
    self.parsedData = [NSMutableArray array];
    self.testItems = [NSMutableArray array];
    
    [parser parse];
    [self getGressInfo];
}

- (void) getGressInfo {
    NSArray *headers = self.parsedData[0];
    for(NSInteger i = 1; i < self.parsedData.count; i++) {
        NSArray *rowdatas = self.parsedData[i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for(int j = 0; j < headers.count; j++) {
            NSString *key = [headers[j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *value = [rowdatas[j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(key.length > 0) { dict[key] = value; }
        }
        [self.testItems addObject:dict];
    }
}

#pragma mark - CHCSVParserDelegate

- (void) parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    self.currentLine = [NSMutableArray array];
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    [self.currentLine addObject:field];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [self.parsedData addObject:self.currentLine];
}

- (void) parserDidEndDocument:(CHCSVParser *)parser {
    NSLog(@"最终数据量: %ld 行", self.parsedData.count);
}

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"解析错误原因: %@", error);
}




#pragma mark - Old Parse CSV File Code

+ (NSArray <NSString *> *)loadCSVLinesFromResource:(NSString *)filename
{
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"csv"];
    if (!filename) {
//        [LogShare writeLog:[NSString stringWithFormat:@"❌ 找不到CSV文件: %@", filename] type:LogTypeUI];
        return result;
    }
    
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
//        [LogShare writeLog:[NSString stringWithFormat:@"❌ 读取CSV失败: %@", error] type:LogTypeUI]; return result;
    }
    
    NSArray<NSString *> *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSInteger i = 1; i < lines.count; i++) {
        NSString *line = [lines[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (line.length > 0) {
            [result addObject:line];
        }
    }
    return result;
}

@end
