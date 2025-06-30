//
//  InteractiveViewController.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/5/9.
//

#import "InteractiveViewController.h"

@interface InteractiveViewController ()

@end

@implementation InteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.inputSNTextField.delegate = self;
    
    _currentIndex = 0;
    _readOnlyFields = @[self.slot1View, self.slot2View, self.slot3View, self.slot4View];
    
    self.slot1View.wantsLayer = YES;
    self.slot1View.layer.backgroundColor = [NSColor greenColor].CGColor;
    
    self.slot2View.wantsLayer = YES;
    self.slot2View.layer.backgroundColor = [NSColor redColor].CGColor;
    
    self.slot3View.wantsLayer = YES;
    self.slot3View.layer.backgroundColor = [NSColor systemPinkColor].CGColor;
    
    self.slot4View.wantsLayer = YES;
    self.slot4View.layer.backgroundColor = [NSColor cyanColor].CGColor;
}

#pragma mark - Input SN Set

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if(control == self.inputSNTextField && commandSelector == @selector(insertNewline:)) {
        [self handleEnterPressed];
        return YES;
    }
    return NO;
}

- (void) handleEnterPressed {
    NSString *inputText = [self.inputSNTextField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (inputText.length > 0) {
        NSTextField *label = [NSTextField labelWithString:inputText];
        [label setFont:[NSFont systemFontOfSize:12]];
        [label setTextColor:[NSColor labelColor]];
        
        [label setFrame:NSMakeRect(10, 10, 100, 15)];
        
        [label setEditable:NO];
        [label setBezeled:NO];
        [label setBackgroundColor:[NSColor clearColor]];
        [_readOnlyFields[_currentIndex] addSubview:label];
    }
    _currentIndex ++;
    self.inputSNTextField.stringValue = @"";
    [self.inputSNTextField becomeFirstResponder];
}

@end
