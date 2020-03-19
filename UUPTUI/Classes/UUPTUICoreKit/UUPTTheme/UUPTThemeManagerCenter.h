/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/
//
//  UUPTThemeManagerCenter.h
//  UUPTKit
//
//  Created by MoLice on 2019/S/4.
//

#import <Foundation/Foundation.h>
#import "UUPTThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const UUPTThemeManagerNameDefault;
extern NSString *const UUPTSelectedThemeIdentifier;
extern NSString *const UUPTThemeIdentifierDefault;
extern NSString *const UUPTThemeIdentifierDark;

/**
 用于获取 UUPTThemeManager，具体使用请查看 UUPTThemeManager 的注释。
 */
@interface UUPTThemeManagerCenter : NSObject

@property(class, nonatomic, strong, readonly) UUPTThemeManager *defaultThemeManager;
@property(class, nonatomic, copy, readonly) NSArray<UUPTThemeManager *> *themeManagers;
+ (nullable UUPTThemeManager *)themeManagerWithName:(__kindof NSObject<NSCopying> *)name;
@end

NS_ASSUME_NONNULL_END
