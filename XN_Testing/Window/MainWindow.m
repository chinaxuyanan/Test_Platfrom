//
//  MainWindow.m
//  XN_Testing
//
//  Created by 徐亚南 on 2025/4/15.
//

#import "MainWindow.h"

@implementation MainWindow

- (void) awakeFromNib
{
    [super awakeFromNib];
    NSRect frame = self.frame;
    frame.size.width = 800;
    frame.size.height = 500;
    [self setFrame:frame display:YES];
    
    self.backgroundColor = [NSColor windowBackgroundColor];
}

- (void) mouseDown:(NSEvent *)event
{
    [self performWindowDragWithEvent:event];
}

- (BOOL) canBecomeKeyWindow {
    return YES;
}

@end
