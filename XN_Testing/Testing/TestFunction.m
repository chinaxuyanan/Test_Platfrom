//
//  TestFunction.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/29.
//

#import "TestFunction.h"

@implementation TestFunction

- (instancetype) initWithTestFunction:(TestFunction *) testFunction {
    if (self = [super init]) {
        _testFunction = testFunction;
    }
    return self;
}

- (id )executeTestItem:(NSDictionary *)item {
    _currentRow = [item[@"_RowIndex"] integerValue];
    NSString *functionName = item[@"Function"];
    __block id input = item[@"Input"];
//    id expectedOutput = item[@"Output"];
    
    if ([functionName isEqualToString:@"i2cRead"] && [input isKindOfClass:[NSString class]]) {
        NSData *jsonData = [input dataUsingEncoding:NSUTF8StringEncoding];
        input = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    }
    return [self executeFunction:functionName withInput:input];
}

- (id)executeFunction:(NSString *)functionName withInput:(id)input {
    if ([functionName isEqualToString:@"stationInfo"]) {
        return [_testFunction stationInfo:input];
    } else if ([functionName isEqualToString:@"getBoardInfo"]) {
        return [_testFunction getBoardInfo:input];
    } else if ([functionName isEqualToString:@"i2cRead"]) {
        return [_testFunction i2cRead:input];
    }
    return nil;
}

- (NSString *) stationInfo:(id) inputString {
    NSString *response = nil;
    if ([inputString isEqualToString:@"site"]) {
        response = @"GK_FCT";
    } else if([inputString isEqualToString:@"line_number"]) {
        response = @"Line_GK_FCT_02";
    } else if([inputString isEqualToString:@"station_id"]) {
        response = @"FCT_02";
    } else if([inputString isEqualToString:@"fixture_id"]) {
        response = @"CYG780H561067C";
    } else if([inputString isEqualToString:@"channel_id"]) {
        response = @"2";
    } else if([inputString isEqualToString:@"vendor_id"]) {
        response = @"CYG";
    } else if([inputString isEqualToString:@"macmini"]) {
        response = @"J174";
    } else if([inputString isEqualToString:@"xavier_sn"]) {
        response = @"SG780H561067C";
    } else if([inputString isEqualToString:@"mix_fw_version"]) {
        response = @"122";
    } else {
        return ERROR;
    }
    return response;
}

- (NSDictionary *) getBoardInfo:(id) inputString {
    NSDictionary *dict = [NSDictionary new];
    if ([inputString isEqualToString:@"MIX_WOLVERINE_EEPROM"]) {
        dict = @{@"sn" : @"WOLVERINE0506120"};
    } else if ([inputString isEqualToString:@"MIX_ARMOR_EEPROM"]) {
        dict = @{@"sn" : @"ARMOR0506120"};
    } else if ([inputString isEqualToString:@"STEL_EEPROM"]) {
        dict = @{@"sn" : @"STEL0506120", @"apn" : @"STEL_apn", @"config" : @"1000"};
    } else if ([inputString isEqualToString:@"LUNA_EEPROM"]) {
        dict = @{@"sn" : @"LUNA0506120", @"date" : @"2024512", @"apn" : @"STEL_apn", @"config" : @"1000"};
    } else if ([inputString isEqualToString:@"PLAT_EEPROM"]) {
        dict = @{@"sn" : @"PLAT0506120", @"date" : @"2024614", @"apn" : @"PLAT_apn", @"config" : @"500"};
    } else if ([inputString isEqualToString:@"SOCKET_EEPROM"]) {
        dict = @{@"sn" : @"SOCKET0506120", @"apn" : @"SOCKET_apn", @"counter" : @"300k"};
    } else {
        return @{@"mes" : ERROR};
    }
    return dict;
}

- (id) i2cRead:(id) args {
    id response;
    NSString *device = args[@"SOCKET_EEPROM"];
    NSString *registerValue = args[@"register"];
    NSString *length = args[@"length"];
    NSString *format = args[@"format"];
    if (registerValue && length) {
        response = @"SOCKET0506120";
    }
    return response;
}

@end
