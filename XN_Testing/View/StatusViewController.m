//
//  StatusViewController.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/5/9.
//

#import "StatusViewController.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 24.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.slotModels = [NSMutableArray array];
    [self initTableViewData];
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
//        [self updateTableViewHeight];
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
    NSLog(@"idealHeight = %f", idealHeight);
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

@end
