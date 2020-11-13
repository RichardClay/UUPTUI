//
//  UUCopyLable.m
//  Masonry
//
//  Created by uu on 2020/11/13.
//

#import "UUCopyLable.h"

@interface UUCopyLable()

@property (nonatomic, strong) UIPasteboard *pasteboard;

@end

@implementation UUCopyLable

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.numberOfLines = 0;
    [self attachLongPress];
    self.pasteboard = [UIPasteboard generalPasteboard];
}

- (void)attachLongPress{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
     /// 防止长按之后连续触发该事件
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];;
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, nil]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
    }
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    return NO;
}

- (void)copyAction:(id)sender {
    self.pasteboard.string = self.text;

}



@end
