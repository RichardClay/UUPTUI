/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/
//
//  UITraitCollection+UUPT.m
//  UUPTKit
//
//  Created by ziezheng on 2019/7/19.
//

#import "UITraitCollection+QMUI.h"
#import "UUPTCore.h"

NSNotificationName const UUPTUserInterfaceStyleWillChangeNotification = @"UUPTUserInterfaceStyleWillChangeNotification";

@implementation UIWindow (UUPTUserInterfaceStyleWillChangeNotification)

#ifdef IOS13_SDK_ALLOWED
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
            static UIUserInterfaceStyle UUPT_lastNotifiedUserInterfaceStyle;
            UUPT_lastNotifiedUserInterfaceStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
            OverrideImplementation([UIWindow class] , @selector(traitCollection), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UITraitCollection *(UIWindow *selfObject) {
                    
                    id (*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (id (*)(id, SEL))originalIMPProvider();
                    UITraitCollection *traitCollection = originSelectorIMP(selfObject, originCMD);
                    
                    BOOL snapshotFinishedOnBackground = traitCollection.userInterfaceLevel == UIUserInterfaceLevelElevated && UIApplication.sharedApplication.applicationState == UIApplicationStateBackground;
                     // 进入后台且完成截图了就不继续去响应 style 变化（实测 iOS 13.0 iPad 进入后台并完成截图后，仍会多次改变 style，但是系统并没有调用界面的相关刷新方法）
                    if (selfObject.windowScene && !snapshotFinishedOnBackground) {
                        NSPointerArray *windows = [[selfObject windowScene] valueForKeyPath:@"_contextBinder._attachedBindables"];
                        // 系统会按照这个数组的顺序去更新 window 的 traitCollection，找出最先响应样式更新的 window
                        UIWindow *firstValidatedWindow = nil;
                        for (NSUInteger i = 0, count = windows.count; i < count; i++) {
                            UIWindow *window = [windows pointerAtIndex:i];
                            // 由于 Keyboard 可以通过 keyboardAppearance 来控制 userInterfaceStyle 的 Dark/Light，不一定和系统一样，这里要过滤掉
                            if ([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")] || [window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
                                continue;
                            }
                            if (window.overrideUserInterfaceStyle != UIUserInterfaceStyleUnspecified) {

                                continue;
                            }
                            firstValidatedWindow = window;
                            break;
                        }
                        if (selfObject == firstValidatedWindow) {
                            if (UUPT_lastNotifiedUserInterfaceStyle != traitCollection.userInterfaceStyle) {
                                UUPT_lastNotifiedUserInterfaceStyle = traitCollection.userInterfaceStyle;
                                [[NSNotificationCenter defaultCenter] postNotificationName:UUPTUserInterfaceStyleWillChangeNotification object:traitCollection];
                            }
                        }
                    }
                    return traitCollection;
                    
                };
            });
        }
    });
}
#endif

@end
