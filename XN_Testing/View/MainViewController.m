//
//  MainViewController.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/15.
//

#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 24.0;
    self.inputSNTextField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.slotModels = [NSMutableArray array];

    //SN输入框设置
    _currentIndex = 0;
    _readOnlyFields = @[self.slot1SNTextField, self.slot2SNTextField, self.slot3SNTextField, self.slot4SNTextField];
    
//    init tableview
    [self initTableViewData];
    
//    创建test thread
    [self setupTestControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeUpdate:) name:TimeDidUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProgressUpdate:) name:CSVDidUpdateNotification object:nil];
}

- (void) initTableViewData {
    for (int i = 0; i < 4; i++) {
        SlotModel *model = [[SlotModel alloc] init];
        model.index = i;
        model.slot = [NSString stringWithFormat:@"slot%d", i + 1];
        [self.slotModels addObject:model];
    }
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTableViewHeight];
    });
}

- (void)setupTestControllers {
    self.testControllers = [NSMutableArray array];
    for (SlotModel *model in self.slotModels) {
        CreateTest *controller = [[CreateTest alloc] initWithSlotModel:model];
        [self.testControllers addObject:controller];
    }
}

- (void) handleTimeUpdate:(NSNotification *) notification {
    SlotModel *model = notification.object;
    NSInteger row = [self.testControllers indexOfObjectPassingTest:^BOOL(CreateTest *obj, NSUInteger idx, BOOL *stop) {
       return obj.slotModel == model;
    }];
    
    if (row != NSNotFound) {
        [self refreshTableViewForRow:row columns:@[@6]];
    }
}

- (void) handleProgressUpdate:(NSNotification *) notification {
    NSDictionary *info = notification.object;
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;
    CreateTest *test = info[@"sourceTest"];
    if (!test) return;
    NSInteger row = [self.testControllers indexOfObject:test];
    if (row == NSNotFound) return;
    test.slotModel.gress = info[@"gress"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTableViewForRow:row columns:@[@7]];
    });
}

#pragma mark - Set Tableview Height
- (CGFloat) calculateIdealTableViewHeight {
    CGFloat headerHeight = self.tableView.headerView.frame.size.height;
    NSInteger rowCount = self.slotModels.count;
    CGFloat idealHeight = rowCount * self.tableView.rowHeight;
    
    CGFloat totalHeight = idealHeight + headerHeight;
    return MIN(totalHeight, 200);
}

- (void) updateTableViewHeight {
    CGFloat idealHeight = [self calculateIdealTableViewHeight];
    NSScrollView *scrollView = self.tableView.enclosingScrollView;
    for (NSLayoutConstraint *constraint in scrollView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = idealHeight;
            break;
        }
    }
    [self.view layoutSubtreeIfNeeded];
}

#pragma mark - NSTableViewDataSource

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return self.slotModels.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    SlotModel *model = self.slotModels[row];
    NSString *identifier = tableColumn.identifier;
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    switch (ColumnTypeForIdentifier(identifier)) {
        case TableViewColumnIndex:
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld", (long)model.index];
            break;
        case TableViewColumnSlot:
            cellView.textField.stringValue = model.slot; break;
        case TableViewColumnSN:
            cellView.textField.stringValue = model.sn; break;
        case TableViewColumnStatus:
            cellView.textField.stringValue = model.statusString;
            switch (model.status) {
                case TestStatusNotStarted:
                    cellView.textField.textColor = [NSColor grayColor]; break;
                case TestStatusPassed:
                    cellView.textField.textColor = [NSColor greenColor]; break;
                case TestStatusFailed:
                    cellView.textField.textColor = [NSColor redColor]; break;
                default: cellView.textField.textColor = [NSColor grayColor]; break;
            }
            break;
        case TableViewColumnLogFile:
            cellView.textField.stringValue = model.logFile; break;
        case TableViewColumnLog:
            cellView.textField.stringValue = model.log;; break;
        case TableViewColumnTime:
            cellView.textField.stringValue = model.formattedDuration;; break;
        case TableViewColumnGress:
            cellView.textField.stringValue = model.gress; break;
        default:
            break;
    }
    return cellView;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    NSTableRowView *rowView = [tableView makeViewWithIdentifier:@"RowView" owner:self];
    if (!rowView) {
        rowView = [[NSTableRowView alloc] init];
        rowView.identifier = @"RowView";
        rowView.wantsLayer = YES;
    }
    
    [self applyAlternatingColorToRowView:rowView atRow:row];
    return rowView;
}

- (void) applyAlternatingColorToRowView:(NSTableRowView *)rowView atRow:(NSInteger)row {
    if (!rowView.selected) {
        rowView.layer.backgroundColor = (row % 2 == 0) ? DarkBlueColor().CGColor : DarkGreenColor().CGColor;
    }
}

#pragma mark - Input SN Set

- (BOOL) control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (control == self.inputSNTextField && commandSelector == @selector(insertNewline:)) {
        [self handleEnterPressed];
        return YES;
    }
    return NO;
}

- (void) handleEnterPressed {
    NSString *inputText = [self.inputSNTextField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (inputText.length > 0) {
        _readOnlyFields[_currentIndex].stringValue = inputText;
    }
    _currentIndex ++;
    self.inputSNTextField.stringValue = @"";
    [self.inputSNTextField becomeFirstResponder];
}

- (void) refreshTableViewForRow:(NSInteger) row columns:(NSArray<NSNumber *> *) columnIndexes {
    NSIndexSet *rowIndex = [NSIndexSet indexSetWithIndex:row];
    NSMutableIndexSet *columns = [NSMutableIndexSet indexSet];
    
    for (NSNumber *index in columnIndexes) {
        [columns addIndex:index.integerValue];
    }
    [self.tableView reloadDataForRowIndexes:rowIndex columnIndexes:columns];
}

#pragma mark - Start Button Set

- (IBAction)startExecuteTest:(id)sender {
//    加载测试的csv文件
    LoadTestItem *load = [[LoadTestItem alloc] init];
    [load parseCSVFileAtPath:@"Test"];
    
//    刷新SN
    for (int i = 0; i < MIN(_readOnlyFields.count, self.testControllers.count); i++) {
        self.testControllers[i].slotModel.sn = _readOnlyFields[i].stringValue;;
        [self refreshTableViewForRow:i columns:@[@2]];
    }
    
    if (self.loopTextField.intValue > 0) {
        for (int i = 0; i < self.loopTextField.intValue; i++) {
            for (CreateTest *test in self.testControllers) {
                test.testItems = load.testItems;
                [test startTestWithCompletion:^(BOOL isPassed) {
                    NSInteger row = [self.testControllers indexOfObject:test];
                    [self refreshTableViewForRow:row columns:@[@3, @6, @7]];
                }];
            }
        }
    } else {
//        刷新测试状态、结果、以及持续测试时间
        for (CreateTest *test in self.testControllers) {
            test.testItems = load.testItems;
            [test startTestWithCompletion:^(BOOL isPassed) {
                NSInteger row = [self.testControllers indexOfObject:test];
                [self refreshTableViewForRow:row columns:@[@3, @6, @7]];
            }];
        }
    }
    _currentIndex = 0;
}

- (IBAction)stopAllTests:(id)sender {
    for (CreateTest *test in self.testControllers) {
        [test cancelTest];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
