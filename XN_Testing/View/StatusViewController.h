//
//  StatusViewController.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/5/9.
//

#import <Cocoa/Cocoa.h>
#import "SlotModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic, strong) NSMutableArray<SlotModel *> *slotModels;

@end

NS_ASSUME_NONNULL_END
