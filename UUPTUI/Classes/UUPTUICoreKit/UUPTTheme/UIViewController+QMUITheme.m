/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/
//
//  UIViewController+UUPTTheme.m
//  UUPTKit
//
//  Created by MoLice on 2019/6/26.
//

#import "UIViewController+QMUITheme.h"


@implementation UIViewController (UUPTTheme)

- (void)UUPT_themeDidChangeByManager:(UUPTThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull childViewController, NSUInteger idx, BOOL * _Nonnull stop) {
        [childViewController UUPT_themeDidChangeByManager:manager identifier:identifier theme:theme];
    }];
    if (self.presentedViewController && self.presentedViewController.presentingViewController == self) {
        [self.presentedViewController UUPT_themeDidChangeByManager:manager identifier:identifier theme:theme];
    }
}

@end

