//
//  UITextField+xibSet.h
//  app
//
//  Created by lz on 2019/10/7.
//  Copyright © 2019 UU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (xibSet)

@property (nonatomic,assign)IBInspectable UIColor *placeHolderColor;

@property (nonatomic,assign)IBInspectable UIFont  *placeHolderFont;


@end

NS_ASSUME_NONNULL_END
