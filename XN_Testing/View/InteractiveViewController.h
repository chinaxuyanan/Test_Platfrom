//
//  InteractiveViewController.h
//  XN_Testing
//
//  Created by 徐亚南 on 2025/5/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface InteractiveViewController : NSViewController<NSTextFieldDelegate> {
    NSInteger _currentIndex;
    NSArray<NSView *> *_readOnlyFields;
}

@property (weak) IBOutlet NSTextField *loopCountTextField;
@property (weak) IBOutlet NSButton *selectAllSlot;

@property (weak) IBOutlet NSTextField *inputSNTextField;
@property (weak) IBOutlet NSView *slot1View;
@property (weak) IBOutlet NSView *slot2View;
@property (weak) IBOutlet NSView *slot3View;
@property (weak) IBOutlet NSView *slot4View;

@end

NS_ASSUME_NONNULL_END
