//
//  MainViewController.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/15.
//

#import <Cocoa/Cocoa.h>
#import "Common.h"
#import "CreateTest.h"
#import "LogShare.h"
#import "SlotModel.h"
#import "LoadTestItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate> {
    NSInteger _currentIndex;
    NSArray<NSTextField *>* _readOnlyFields;
}

@property (strong) NSString *stationName;
@property (strong) NSString *productName;
@property (strong) NSString *versionIndo;

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *inputSNTextField;
@property (weak) IBOutlet NSTextField *slot1SNTextField;
@property (weak) IBOutlet NSTextField *slot2SNTextField;
@property (weak) IBOutlet NSTextField *slot3SNTextField;
@property (weak) IBOutlet NSTextField *slot4SNTextField;

@property (nonatomic, strong) NSMutableArray<SlotModel *> *slotModels;
@property (nonatomic, strong) NSMutableArray<CreateTest *> *testControllers;

@property (weak) IBOutlet NSTextField *loopTextField;
@property (nonatomic) int loopCount;

@end

NS_ASSUME_NONNULL_END
