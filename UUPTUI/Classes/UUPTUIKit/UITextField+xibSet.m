//
//  UITextField+xibSet.m
//  app
//
//  Created by lz on 2019/10/7.
//  Copyright © 2019 UU. All rights reserved.
//

#import "UITextField+xibSet.h"


@implementation UITextField (xibSet)
@dynamic placeHolderColor,placeHolderFont;

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:placeHolderColor
                        range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = placeholder;
}

- (void)setPlaceHolderFont:(UIFont *)placeHolderFont{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    [placeholder addAttribute:NSFontAttributeName
                       value:placeHolderFont
                       range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = placeholder;
}


@end
