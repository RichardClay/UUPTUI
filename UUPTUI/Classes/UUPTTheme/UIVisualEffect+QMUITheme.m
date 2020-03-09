/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/
//
//  UIVisualEffect+UUPTTheme.m
//  UUPTKit
//
//  Created by MoLice on 2019/7/20.
//

#import "UIVisualEffect+QMUITheme.h"
#import "UUPTThemeManager.h"
#import "UUPTThemeManagerCenter.h"
#import "UUPTThemePrivate.h"
#import "NSMethodSignature+QMUI.h"
#import "UUPTCore.h"

@implementation UUPTThemeVisualEffect

- (id)copyWithZone:(NSZone *)zone {
    UUPTThemeVisualEffect *effect = [[self class] allocWithZone:zone];
    effect.managerName = self.managerName;
    effect.themeProvider = self.themeProvider;
    return effect;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) {
        return result;
    }
    
    result = [self.UUPT_rawEffect methodSignatureForSelector:aSelector];
    if (result && [self.UUPT_rawEffect respondsToSelector:aSelector]) {
        return result;
    }
    
    return [NSMethodSignature UUPT_avoidExceptionSignature];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;
    if ([self.UUPT_rawEffect respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.UUPT_rawEffect];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [self.UUPT_rawEffect respondsToSelector:aSelector];
}

- (BOOL)isKindOfClass:(Class)aClass {
    if (aClass == UUPTThemeVisualEffect.class) return YES;
    return [self.UUPT_rawEffect isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    if (aClass == UUPTThemeVisualEffect.class) return YES;
    return [self.UUPT_rawEffect isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self.UUPT_rawEffect conformsToProtocol:aProtocol];
}

- (NSUInteger)hash {
    return (NSUInteger)self.themeProvider;
}

- (BOOL)isEqual:(id)object {
    return NO;
}

#pragma mark - <UUPTDynamicEffectProtocol>

- (UIVisualEffect *)UUPT_rawEffect {
    UUPTThemeManager *manager = [UUPTThemeManagerCenter themeManagerWithName:self.managerName];
    return self.themeProvider(manager, manager.currentThemeIdentifier, manager.currentTheme).UUPT_rawEffect;
}

- (BOOL)UUPT_isDynamicEffect {
    return YES;
}

@end

@implementation UIVisualEffect (UUPTTheme)

+ (UIVisualEffect *)UUPT_effectWithThemeProvider:(UIVisualEffect * _Nonnull (^)(__kindof UUPTThemeManager * _Nonnull, __kindof NSObject<NSCopying> * _Nullable, __kindof NSObject * _Nullable))provider {
    return [UIVisualEffect UUPT_effectWithThemeManagerName:UUPTThemeManagerNameDefault provider:provider];
}

+ (UIVisualEffect *)UUPT_effectWithThemeManagerName:(__kindof NSObject<NSCopying> *)name provider:(UIVisualEffect * _Nonnull (^)(__kindof UUPTThemeManager * _Nonnull, __kindof NSObject<NSCopying> * _Nullable, __kindof NSObject * _Nullable))provider {
    UUPTThemeVisualEffect *effect = [[UUPTThemeVisualEffect alloc] init];
    effect.managerName = name;
    effect.themeProvider = provider;
    return (UIVisualEffect *)effect;
}

#pragma mark - <UUPTDynamicEffectProtocol>

- (UIVisualEffect *)UUPT_rawEffect {
    return self;
}

- (BOOL)UUPT_isDynamicEffect {
    return NO;
}

@end
