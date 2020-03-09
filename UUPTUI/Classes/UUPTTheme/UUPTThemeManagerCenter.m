/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/
//
//  UUPTThemeManagerCenter.m
//  UUPTKit
//
//  Created by MoLice on 2019/S/4.
//

#import "UUPTThemeManagerCenter.h"

NSString *const UUPTThemeManagerNameDefault = @"Default";
NSString *const UUPTSelectedThemeIdentifier = @"selectedThemeIdentifier";
NSString *const UUPTThemeIdentifierDefault = @"Default";
NSString *const UUPTThemeIdentifierDark = @"Dark";

@interface UUPTThemeManager ()

// 这个方法的实现在 UUPTThemeManager.m 里，这里只是为了内部使用而显式声明一次
- (instancetype)initWithName:(__kindof NSObject<NSCopying> *)name;
@end

@interface UUPTThemeManagerCenter ()

@property(nonatomic, strong) NSMutableArray<UUPTThemeManager *> *allManagers;
@end

@implementation UUPTThemeManagerCenter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static UUPTThemeManagerCenter *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.allManagers = NSMutableArray.new;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+ (UUPTThemeManager *)themeManagerWithName:(__kindof NSObject<NSCopying> *)name {
    UUPTThemeManagerCenter *center = [UUPTThemeManagerCenter sharedInstance];
    for (UUPTThemeManager *manager in center.allManagers) {
        if ([manager.name isEqual:name]) return manager;
    }
    UUPTThemeManager *manager = [[UUPTThemeManager alloc] initWithName:name];
    [center.allManagers addObject:manager];
    return manager;
}

+ (UUPTThemeManager *)defaultThemeManager {
    return [UUPTThemeManagerCenter themeManagerWithName:UUPTThemeManagerNameDefault];
}

+ (NSArray<UUPTThemeManager *> *)themeManagers {
    return [UUPTThemeManagerCenter sharedInstance].allManagers.copy;
}

@end
