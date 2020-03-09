/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/

//
//  UIView+UUPT.m
//  UUPT
//
//  Created by UUPT Team on 15/7/20.
//

#import "UIView+QMUI.h"
#import "UUPTCore.h"
#import "CALayer+QMUI.h"
#import "UIColor+QMUI.h"
#import "NSObject+QMUI.h"
#import "UIImage+QMUI.h"
#import "NSNumber+QMUI.h"
#import "UUPTLab.h"
#import <objc/runtime.h>

@interface UIView ()

/// UUPT_Debug
@property(nonatomic, assign, readwrite) BOOL UUPT_hasDebugColor;

/// UUPT_Border
@property(nonatomic, strong, readwrite) CAShapeLayer *UUPT_borderLayer;

@end


@implementation UIView (UUPT)

UUPTSynthesizeBOOLProperty(UUPT_tintColorCustomized, setUUPT_tintColorCustomized)
UUPTSynthesizeIdCopyProperty(UUPT_frameWillChangeBlock, setUUPT_frameWillChangeBlock)
UUPTSynthesizeIdCopyProperty(UUPT_frameDidChangeBlock, setUUPT_frameDidChangeBlock)
UUPTSynthesizeIdCopyProperty(UUPT_tintColorDidChangeBlock, setUUPT_tintColorDidChangeBlock)
UUPTSynthesizeIdCopyProperty(UUPT_hitTestBlock, setUUPT_hitTestBlock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(setTintColor:), UIColor *, ^(UIView *selfObject, UIColor *tintColor) {
            selfObject.UUPT_tintColorCustomized = !!tintColor;
        });
        
        ExtendImplementationOfVoidMethodWithoutArguments([UIView class], @selector(tintColorDidChange), ^(UIView *selfObject) {
            if (selfObject.UUPT_tintColorDidChangeBlock) {
                selfObject.UUPT_tintColorDidChangeBlock(selfObject);
            }
        });
        
        ExtendImplementationOfNonVoidMethodWithTwoArguments([UIView class], @selector(hitTest:withEvent:), CGPoint, UIEvent *, UIView *, ^UIView *(UIView *selfObject, CGPoint point, UIEvent *event, UIView *originReturnValue) {
            if (selfObject.UUPT_hitTestBlock) {
                UIView *view = selfObject.UUPT_hitTestBlock(point, event, originReturnValue);
                return view;
            }
            return originReturnValue;
        });
        
        // 这个私有方法在 view 被调用 becomeFirstResponder 并且处于 window 上时，才会被调用，所以比 becomeFirstResponder 更适合用来检测
        ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], NSSelectorFromString(@"_didChangeToFirstResponder:"), id, ^(UIView *selfObject, id firstArgv) {
            if (selfObject == firstArgv && [selfObject conformsToProtocol:@protocol(UITextInput)]) {
                // 像 UUPTModalPresentationViewController 那种以 window 的形式展示浮层，浮层里的输入框 becomeFirstResponder 的场景，[window makeKeyAndVisible] 被调用后，就会立即走到这里，但此时该 window 尚不是 keyWindow，所以这里延迟到下一个 runloop 里再去判断
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (IS_DEBUG && ![selfObject isKindOfClass:[UIWindow class]] && selfObject.window && !selfObject.window.keyWindow) {
                        [selfObject UUPTSymbolicUIViewBecomeFirstResponderWithoutKeyWindow];
                    }
                });
            }
        });
        
        OverrideImplementation([UIView class], @selector(addSubview:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, UIView *view) {
                if (view == selfObject) {
                    [selfObject printLogForAddSubviewToSelf];
                    return;
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIView *);
                originSelectorIMP = (void (*)(id, SEL, UIView *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, view);
            };
        });
        
        OverrideImplementation([UIView class], @selector(insertSubview:atIndex:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, UIView *view, NSInteger index) {
                if (view == selfObject) {
                    [selfObject printLogForAddSubviewToSelf];
                    return;
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIView *, NSInteger);
                originSelectorIMP = (void (*)(id, SEL, UIView *, NSInteger))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, view, index);
            };
        });
        
        OverrideImplementation([UIView class], @selector(insertSubview:aboveSubview:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, UIView *view, UIView *siblingSubview) {
                if (view == self) {
                    [selfObject printLogForAddSubviewToSelf];
                    return;
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIView *, UIView *);
                originSelectorIMP = (void (*)(id, SEL, UIView *, UIView *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, view, siblingSubview);
            };
        });
        
        OverrideImplementation([UIView class], @selector(insertSubview:belowSubview:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, UIView *view, UIView *siblingSubview) {
                if (view == self) {
                    [selfObject printLogForAddSubviewToSelf];
                    return;
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIView *, UIView *);
                originSelectorIMP = (void (*)(id, SEL, UIView *, UIView *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, view, siblingSubview);
            };
        });
        
        OverrideImplementation([UIView class], @selector(convertPoint:toView:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGPoint(UIView *selfObject, CGPoint point, UIView *view) {
                
                [selfObject alertConvertValueWithView:view];
                
                // call super
                CGPoint (*originSelectorIMP)(id, SEL, CGPoint, UIView *);
                originSelectorIMP = (CGPoint (*)(id, SEL, CGPoint, UIView *))originalIMPProvider();
                CGPoint result = originSelectorIMP(selfObject, originCMD, point, view);
                
                return result;
            };
        });
        
        OverrideImplementation([UIView class], @selector(convertPoint:fromView:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGPoint(UIView *selfObject, CGPoint point, UIView *view) {
                
                [selfObject alertConvertValueWithView:view];
                
                // call super
                CGPoint (*originSelectorIMP)(id, SEL, CGPoint, UIView *);
                originSelectorIMP = (CGPoint (*)(id, SEL, CGPoint, UIView *))originalIMPProvider();
                CGPoint result = originSelectorIMP(selfObject, originCMD, point, view);
                
                return result;
            };
        });
        
        OverrideImplementation([UIView class], @selector(convertRect:toView:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGRect(UIView *selfObject, CGRect rect, UIView *view) {
                
                [selfObject alertConvertValueWithView:view];
                
                // call super
                CGRect (*originSelectorIMP)(id, SEL, CGRect, UIView *);
                originSelectorIMP = (CGRect (*)(id, SEL, CGRect, UIView *))originalIMPProvider();
                CGRect result = originSelectorIMP(selfObject, originCMD, rect, view);
                
                return result;
            };
        });
        
        OverrideImplementation([UIView class], @selector(convertRect:fromView:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGRect(UIView *selfObject, CGRect rect, UIView *view) {
                
                [selfObject alertConvertValueWithView:view];
                
                // call super
                CGRect (*originSelectorIMP)(id, SEL, CGRect, UIView *);
                originSelectorIMP = (CGRect (*)(id, SEL, CGRect, UIView *))originalIMPProvider();
                CGRect result = originSelectorIMP(selfObject, originCMD, rect, view);
                
                return result;
            };
        });
        
    });
}

- (instancetype)UUPT_initWithSize:(CGSize)size {
    return [self initWithFrame:CGRectMakeWithSize(size)];
}

- (void)setUUPT_frameApplyTransform:(CGRect)UUPT_frameApplyTransform {
    self.frame = CGRectApplyAffineTransformWithAnchorPoint(UUPT_frameApplyTransform, self.transform, self.layer.anchorPoint);
}

- (CGRect)UUPT_frameApplyTransform {
    return self.frame;
}

- (UIEdgeInsets)UUPT_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (void)UUPT_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (CGPoint)UUPT_convertPoint:(CGPoint)point toView:(nullable UIView *)view {
    if (view) {
        return [view UUPT_convertPoint:point fromView:view];
    }
    return [self convertPoint:point toView:view];
}

- (CGPoint)UUPT_convertPoint:(CGPoint)point fromView:(nullable UIView *)view {
    UIWindow *selfWindow = [self isKindOfClass:[UIWindow class]] ? (UIWindow *)self : self.window;
    UIWindow *fromWindow = [view isKindOfClass:[UIWindow class]] ? (UIWindow *)view : view.window;
    if (selfWindow && fromWindow && selfWindow != fromWindow) {
        CGPoint pointInFromWindow = fromWindow == view ? point : [view convertPoint:point toView:nil];
        CGPoint pointInSelfWindow = [selfWindow convertPoint:pointInFromWindow fromWindow:fromWindow];
        CGPoint pointInSelf = selfWindow == self ? pointInSelfWindow : [self convertPoint:pointInSelfWindow fromView:nil];
        return pointInSelf;
    }
    return [self convertPoint:point fromView:view];
}

- (CGRect)UUPT_convertRect:(CGRect)rect toView:(nullable UIView *)view {
    if (view) {
        return [view UUPT_convertRect:rect fromView:self];
    }
    return [self convertRect:rect toView:view];
}

- (CGRect)UUPT_convertRect:(CGRect)rect fromView:(nullable UIView *)view {
    UIWindow *selfWindow = [self isKindOfClass:[UIWindow class]] ? (UIWindow *)self : self.window;
    UIWindow *fromWindow = [view isKindOfClass:[UIWindow class]] ? (UIWindow *)view : view.window;
    if (selfWindow && fromWindow && selfWindow != fromWindow) {
        CGRect rectInFromWindow = fromWindow == view ? rect : [view convertRect:rect toView:nil];
        CGRect rectInSelfWindow = [selfWindow convertRect:rectInFromWindow fromWindow:fromWindow];
        CGRect rectInSelf = selfWindow == self ? rectInSelfWindow : [self convertRect:rectInSelfWindow fromView:nil];
        return rectInSelf;
    }
    return [self convertRect:rect fromView:view];
}

+ (void)UUPT_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

+ (void)UUPT_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration animations:(void (^ __nullable)(void))animations completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

+ (void)UUPT_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration animations:(void (^ __nullable)(void))animations {
    if (animated) {
        [UIView animateWithDuration:duration animations:animations];
    } else {
        if (animations) {
            animations();
        }
    }
}

+ (void)UUPT_animateWithAnimated:(BOOL)animated duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:options animations:animations completion:completion];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

- (void)printLogForAddSubviewToSelf {

}

- (void)UUPTSymbolicUIViewBecomeFirstResponderWithoutKeyWindow {
}

- (BOOL)hasSharedAncestorViewWithView:(UIView *)view {
    UIView *sharedAncestorView = self;
    if (!view) {
        return YES;
    }
    while (sharedAncestorView && ![view isDescendantOfView:sharedAncestorView]) {
        sharedAncestorView = sharedAncestorView.superview;
    }
    return !!sharedAncestorView;
}

- (BOOL)isUIKitPrivateView {
    // 系统有些东西本身也存在不合理，但我们不关心这种，所以过滤掉
    if ([self isKindOfClass:[UIWindow class]]) return YES;
    
    __block BOOL isPrivate = NO;
    NSString *classString = NSStringFromClass(self.class);
    [@[@"LayoutContainer", @"NavigationItemButton", @"NavigationItemView", @"SelectionGrabber", @"InputViewContent", @"InputSetContainer", @"TextFieldContentView", @"KeyboardImpl"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([classString hasPrefix:@"UI"] || [classString hasPrefix:@"_UI"]) && [classString containsString:obj]) {
            isPrivate = YES;
            *stop = YES;
        }
    }];
    return isPrivate;
}

- (void)alertConvertValueWithView:(UIView *)view {
    if (IS_DEBUG && ![self isUIKitPrivateView] && ![self hasSharedAncestorViewWithView:view]) {
    }
}

@end

@implementation UIView (UUPT_ViewController)

UUPTSynthesizeBOOLProperty(UUPT_isControllerRootView, setUUPT_isControllerRootView)

- (BOOL)UUPT_visible {
    if (self.hidden || self.alpha <= 0.01) {
        return NO;
    }
    if (self.window) {
        return YES;
    }
    if ([self isKindOfClass:UIWindow.class]) {
        if (@available(iOS 13.0, *)) {
            return !!((UIWindow *)self).windowScene;
        } else {
            return YES;
        }
    }
    return NO;
}

static char kAssociatedObjectKey_viewController;
- (void)setUUPT_viewController:(__kindof UIViewController * _Nullable)UUPT_viewController {

    
    self.UUPT_isControllerRootView = !!UUPT_viewController;
}

- (__kindof UIViewController *)UUPT_viewController {
  
    return self.superview.UUPT_viewController;
}

@end

@interface UIViewController (UUPT_View)

@end

@implementation UIViewController (UUPT_View)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments([UIViewController class], @selector(viewDidLoad), ^(UIViewController *selfObject) {
            if (@available(iOS 11.0, *)) {
                selfObject.view.UUPT_viewController = selfObject;
            } else {
                // 临时修复 iOS 10.0.2 上在输入框内切换输入法可能引发死循环的 bug，待查
                // https://github.com/Tencent/UUPT_iOS/issues/471
                ((UIView *)[selfObject UUPT_valueForKey:@"_view"]).UUPT_viewController = selfObject;
            }
        });
    });
}

@end


@implementation UIView (UUPT_Runtime)

- (BOOL)UUPT_hasOverrideUIKitMethod:(SEL)selector {
    // 排序依照 Xcode Interface Builder 里的控件排序，但保证子类在父类前面
    NSMutableArray<Class> *viewSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                               [UIStackView class],
                                               [UILabel class],
                                               [UIButton class],
                                               [UISegmentedControl class],
                                               [UITextField class],
                                               [UISlider class],
                                               [UISwitch class],
                                               [UIActivityIndicatorView class],
                                               [UIProgressView class],
                                               [UIPageControl class],
                                               [UIStepper class],
                                               [UITableView class],
                                               [UITableViewCell class],
                                               [UIImageView class],
                                               [UICollectionView class],
                                               [UICollectionViewCell class],
                                               [UICollectionReusableView class],
                                               [UITextView class],
                                               [UIScrollView class],
                                               [UIDatePicker class],
                                               [UIPickerView class],
                                               [UIVisualEffectView class],
                                               // Apple 不再接受使用了 UIWebView 的 App 提交，所以这里去掉 UIWebView
                                               // https://github.com/Tencent/UUPT_iOS/issues/741
//                                               [UIWebView class],
                                               [UIWindow class],
                                               [UINavigationBar class],
                                               [UIToolbar class],
                                               [UITabBar class],
                                               [UISearchBar class],
                                               [UIControl class],
                                               [UIView class],
                                               nil];
    
    for (NSInteger i = 0, l = viewSuperclasses.count; i < l; i++) {
        Class superclass = viewSuperclasses[i];
        if ([self UUPT_hasOverrideMethod:selector ofSuperclass:superclass]) {
            return YES;
        }
    }
    return NO;
}

@end


@implementation UIView (UUPT_Border)

UUPTSynthesizeIdStrongProperty(UUPT_borderLayer, setUUPT_borderLayer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithFrame:), CGRect, UIView *, ^UIView *(UIView *selfObject, CGRect frame, UIView *originReturnValue) {
            [selfObject setDefaultStyle];
            return originReturnValue;
        });
        
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithCoder:), NSCoder *, UIView *, ^UIView *(UIView *selfObject, NSCoder *aDecoder, UIView *originReturnValue) {
            [selfObject setDefaultStyle];
            return originReturnValue;
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(layoutSublayersOfLayer:), CALayer *, ^(UIView *selfObject, CALayer *layer) {
            if ((!selfObject.UUPT_borderLayer && selfObject.UUPT_borderPosition == UUPTViewBorderPositionNone) || (!selfObject.UUPT_borderLayer && selfObject.UUPT_borderWidth == 0)) {
                return;
            }
            
            if (selfObject.UUPT_borderLayer && selfObject.UUPT_borderPosition == UUPTViewBorderPositionNone && !selfObject.UUPT_borderLayer.path) {
                return;
            }
            
            if (selfObject.UUPT_borderLayer && selfObject.UUPT_borderWidth == 0 && selfObject.UUPT_borderLayer.lineWidth == 0) {
                return;
            }
            
            if (!selfObject.UUPT_borderLayer) {
                selfObject.UUPT_borderLayer = [CAShapeLayer layer];
                selfObject.UUPT_borderLayer.fillColor = UIColorClear.CGColor;
                [selfObject.UUPT_borderLayer UUPT_removeDefaultAnimations];
                [selfObject.layer addSublayer:selfObject.UUPT_borderLayer];
            }
            selfObject.UUPT_borderLayer.frame = selfObject.bounds;
            
            CGFloat borderWidth = selfObject.UUPT_borderWidth;
            selfObject.UUPT_borderLayer.lineWidth = borderWidth;
            selfObject.UUPT_borderLayer.strokeColor = selfObject.UUPT_borderColor.CGColor;
            selfObject.UUPT_borderLayer.lineDashPhase = selfObject.UUPT_dashPhase;
            selfObject.UUPT_borderLayer.lineDashPattern = selfObject.UUPT_dashPattern;
            
            UIBezierPath *path = nil;
            
            if (selfObject.UUPT_borderPosition != UUPTViewBorderPositionNone) {
                path = [UIBezierPath bezierPath];
            }
            
            CGFloat (^adjustsLocation)(CGFloat, CGFloat, CGFloat) = ^CGFloat(CGFloat inside, CGFloat center, CGFloat outside) {
                return selfObject.UUPT_borderLocation == UUPTViewBorderLocationInside ? inside : (selfObject.UUPT_borderLocation == UUPTViewBorderLocationCenter ? center : outside);
            };
            
            CGFloat lineOffset = adjustsLocation(borderWidth / 2.0, 0, -borderWidth / 2.0); // 为了像素对齐而做的偏移
            CGFloat lineCapOffset = adjustsLocation(0, borderWidth / 2.0, borderWidth); // 两条相邻的边框连接的位置
            
            BOOL shouldShowTopBorder = (selfObject.UUPT_borderPosition & UUPTViewBorderPositionTop) == UUPTViewBorderPositionTop;
            BOOL shouldShowLeftBorder = (selfObject.UUPT_borderPosition & UUPTViewBorderPositionLeft) == UUPTViewBorderPositionLeft;
            BOOL shouldShowBottomBorder = (selfObject.UUPT_borderPosition & UUPTViewBorderPositionBottom) == UUPTViewBorderPositionBottom;
            BOOL shouldShowRightBorder = (selfObject.UUPT_borderPosition & UUPTViewBorderPositionRight) == UUPTViewBorderPositionRight;
            
            UIBezierPath *topPath = [UIBezierPath bezierPath];
            UIBezierPath *leftPath = [UIBezierPath bezierPath];
            UIBezierPath *bottomPath = [UIBezierPath bezierPath];
            UIBezierPath *rightPath = [UIBezierPath bezierPath];
            
            if (selfObject.layer.UUPT_originCornerRadius > 0) {
                
                CGFloat cornerRadius = selfObject.layer.UUPT_originCornerRadius;
                
                if (selfObject.layer.UUPT_maskedCorners) {
                    if ((selfObject.layer.UUPT_maskedCorners & UUPTLayerMinXMinYCorner) == UUPTLayerMinXMinYCorner) {
                        [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                        [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    } else {
                        [topPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, lineOffset)];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                        [leftPath moveToPoint:CGPointMake(lineOffset, shouldShowTopBorder ? -lineCapOffset : 0)];
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    }
                    if ((selfObject.layer.UUPT_maskedCorners & UUPTLayerMinXMaxYCorner) == UUPTLayerMinXMaxYCorner) {
                        [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
                        [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - lineOffset)];
                    } else {
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                        CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                        [bottomPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, y)];
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, y)];
                    }
                    if ((selfObject.layer.UUPT_maskedCorners & UUPTLayerMaxXMaxYCorner) == UUPTLayerMaxXMaxYCorner) {
                        [bottomPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
                        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
                        [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - lineOffset, cornerRadius)];
                    } else {
                        CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), y)];
                        CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                        [rightPath moveToPoint:CGPointMake(x, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                        [rightPath addLineToPoint:CGPointMake(x, cornerRadius)];
                    }
                    if ((selfObject.layer.UUPT_maskedCorners & UUPTLayerMaxXMinYCorner) == UUPTLayerMaxXMinYCorner) {
                        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
                        [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
                    } else {
                        CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                        [rightPath addLineToPoint:CGPointMake(x, shouldShowTopBorder ? -lineCapOffset : 0)];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), lineOffset)];
                    }
                } else {
                    [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
                    [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                    [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
                    
                    [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
                    [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
                    
                    [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                    [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - lineOffset)];
                    [bottomPath addArcWithCenter:CGPointMake(CGRectGetHeight(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
                    
                    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
                    [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - lineOffset, cornerRadius)];
                    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
                }
                
            } else {
                [topPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, lineOffset)];
                [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), lineOffset)];
                
                [leftPath moveToPoint:CGPointMake(lineOffset, shouldShowTopBorder ? -lineCapOffset : 0)];
                [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                
                CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                [bottomPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, y)];
                [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), y)];
                
                CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                [rightPath moveToPoint:CGPointMake(x, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                [rightPath addLineToPoint:CGPointMake(x, shouldShowTopBorder ? -lineCapOffset : 0)];
            }
            
            if (shouldShowTopBorder && ![topPath isEmpty]) {
                [path appendPath:topPath];
            }
            if (shouldShowLeftBorder && ![leftPath isEmpty]) {
                [path appendPath:leftPath];
            }
            if (shouldShowBottomBorder && ![bottomPath isEmpty]) {
                [path appendPath:bottomPath];
            }
            if (shouldShowRightBorder && ![rightPath isEmpty]) {
                [path appendPath:rightPath];
            }
            
            selfObject.UUPT_borderLayer.path = path.CGPath;
        });
    });
}

- (void)setDefaultStyle {
    self.UUPT_borderWidth = PixelOne;
    self.UUPT_borderColor = UIColorSeparator;
}

static char kAssociatedObjectKey_borderLocation;
- (void)setUUPT_borderLocation:(UUPTViewBorderLocation)UUPT_borderLocation {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderLocation, @(UUPT_borderLocation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UUPTViewBorderLocation)UUPT_borderLocation {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderLocation)) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderPosition;
- (void)setUUPT_borderPosition:(UUPTViewBorderPosition)UUPT_borderPosition {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderPosition, @(UUPT_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UUPTViewBorderPosition)UUPT_borderPosition {
    return (UUPTViewBorderPosition)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderPosition) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderWidth;
- (void)setUUPT_borderWidth:(CGFloat)UUPT_borderWidth {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderWidth, @(UUPT_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)UUPT_borderWidth {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderWidth)) UUPT_CGFloatValue];
}

static char kAssociatedObjectKey_borderColor;
- (void)setUUPT_borderColor:(UIColor *)UUPT_borderColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderColor, UUPT_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UIColor *)UUPT_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderColor);
}

static char kAssociatedObjectKey_dashPhase;
- (void)setUUPT_dashPhase:(CGFloat)UUPT_dashPhase {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPhase, @(UUPT_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)UUPT_dashPhase {
    return [(NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPhase) UUPT_CGFloatValue];
}

static char kAssociatedObjectKey_dashPattern;
- (void)setUUPT_dashPattern:(NSArray<NSNumber *> *)UUPT_dashPattern {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPattern, UUPT_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (NSArray *)UUPT_dashPattern {
    return (NSArray<NSNumber *> *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPattern);
}

@end


const CGFloat UUPTViewSelfSizingHeight = INFINITY;

@implementation UIView (UUPT_Layout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UIView class], @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGRect frame) {
                
                // UUPTViewSelfSizingHeight 的功能
                if (CGRectGetWidth(frame) > 0 && isinf(CGRectGetHeight(frame))) {
                    CGFloat height = flat([selfObject sizeThatFits:CGSizeMake(CGRectGetWidth(frame), CGFLOAT_MAX)].height);
                    frame = CGRectSetHeight(frame, height);
                }
                
                // 对非法的 frame，Debug 下中 assert，Release 下会将其中的 NaN 改为 0，避免 crash
                if (CGRectIsNaN(frame)) {
                    if (UUPTCMIActivated && !ShouldPrintUUPTWarnLogToConsole) {
                        NSAssert(NO, @"UIView setFrame: 出现 NaN");
                    }
                    if (!IS_DEBUG) {
                        frame = CGRectSafeValue(frame);
                    }
                }
                
                CGRect precedingFrame = selfObject.frame;
                BOOL valueChange = !CGRectEqualToRect(frame, precedingFrame);
                if (selfObject.UUPT_frameWillChangeBlock && valueChange) {
                    frame = selfObject.UUPT_frameWillChangeBlock(selfObject, frame);
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, frame);
                
                if (selfObject.UUPT_frameDidChangeBlock && valueChange) {
                    selfObject.UUPT_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
        OverrideImplementation([UIView class], @selector(setBounds:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGRect bounds) {
                
                CGRect precedingFrame = selfObject.frame;
                CGRect precedingBounds = selfObject.bounds;
                BOOL valueChange = !CGSizeEqualToSize(bounds.size, precedingBounds.size);// bounds 只有 size 发生变化才会影响 frame
                if (selfObject.UUPT_frameWillChangeBlock && valueChange) {
                    CGRect followingFrame = CGRectMake(CGRectGetMinX(precedingFrame) + CGFloatGetCenter(CGRectGetWidth(bounds), CGRectGetWidth(precedingFrame)), CGRectGetMinY(precedingFrame) + CGFloatGetCenter(CGRectGetHeight(bounds), CGRectGetHeight(precedingFrame)), bounds.size.width, bounds.size.height);
                    followingFrame = selfObject.UUPT_frameWillChangeBlock(selfObject, followingFrame);
                    bounds = CGRectSetSize(bounds, followingFrame.size);
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, bounds);
                
                if (selfObject.UUPT_frameDidChangeBlock && valueChange) {
                    selfObject.UUPT_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
        OverrideImplementation([UIView class], @selector(setCenter:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGPoint center) {
                
                CGRect precedingFrame = selfObject.frame;
                CGPoint precedingCenter = selfObject.center;
                BOOL valueChange = !CGPointEqualToPoint(center, precedingCenter);
                if (selfObject.UUPT_frameWillChangeBlock && valueChange) {
                    CGRect followingFrame = CGRectSetXY(precedingFrame, center.x - CGRectGetWidth(selfObject.frame) / 2, center.y - CGRectGetHeight(selfObject.frame) / 2);
                    followingFrame = selfObject.UUPT_frameWillChangeBlock(selfObject, followingFrame);
                    center = CGPointMake(CGRectGetMidX(followingFrame), CGRectGetMidY(followingFrame));
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGPoint);
                originSelectorIMP = (void (*)(id, SEL, CGPoint))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, center);
                
                if (selfObject.UUPT_frameDidChangeBlock && valueChange) {
                    selfObject.UUPT_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
        
        OverrideImplementation([UIView class], @selector(setTransform:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGAffineTransform transform) {
                
                CGRect precedingFrame = selfObject.frame;
                CGAffineTransform precedingTransform = selfObject.transform;
                BOOL valueChange = !CGAffineTransformEqualToTransform(transform, precedingTransform);
                if (selfObject.UUPT_frameWillChangeBlock && valueChange) {
                    CGRect followingFrame = CGRectApplyAffineTransformWithAnchorPoint(precedingFrame, transform, selfObject.layer.anchorPoint);
                    selfObject.UUPT_frameWillChangeBlock(selfObject, followingFrame);// 对于 CGAffineTransform，无法根据修改后的 rect 来算出新的 transform，所以就不修改 transform 的值了
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGAffineTransform);
                originSelectorIMP = (void (*)(id, SEL, CGAffineTransform))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, transform);
                
                if (selfObject.UUPT_frameDidChangeBlock && valueChange) {
                    selfObject.UUPT_frameDidChangeBlock(selfObject, precedingFrame);
                }
            };
        });
    });
}

- (CGFloat)UUPT_top {
    return CGRectGetMinY(self.frame);
}

- (void)setUUPT_top:(CGFloat)top {
    self.frame = CGRectSetY(self.frame, top);
}

- (CGFloat)UUPT_left {
    return CGRectGetMinX(self.frame);
}

- (void)setUUPT_left:(CGFloat)left {
    self.frame = CGRectSetX(self.frame, left);
}

- (CGFloat)UUPT_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setUUPT_bottom:(CGFloat)bottom {
    self.frame = CGRectSetY(self.frame, bottom - CGRectGetHeight(self.frame));
}

- (CGFloat)UUPT_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setUUPT_right:(CGFloat)right {
    self.frame = CGRectSetX(self.frame, right - CGRectGetWidth(self.frame));
}

- (CGFloat)UUPT_width {
    return CGRectGetWidth(self.frame);
}

- (void)setUUPT_width:(CGFloat)width {
    self.frame = CGRectSetWidth(self.frame, width);
}

- (CGFloat)UUPT_height {
    return CGRectGetHeight(self.frame);
}

- (void)setUUPT_height:(CGFloat)height {
    self.frame = CGRectSetHeight(self.frame, height);
}

- (CGFloat)UUPT_extendToTop {
    return self.UUPT_top;
}

- (void)setUUPT_extendToTop:(CGFloat)UUPT_extendToTop {
    self.UUPT_height = self.UUPT_bottom - UUPT_extendToTop;
    self.UUPT_top = UUPT_extendToTop;
}

- (CGFloat)UUPT_extendToLeft {
    return self.UUPT_left;
}

- (void)setUUPT_extendToLeft:(CGFloat)UUPT_extendToLeft {
    self.UUPT_width = self.UUPT_right - UUPT_extendToLeft;
    self.UUPT_left = UUPT_extendToLeft;
}

- (CGFloat)UUPT_extendToBottom {
    return self.UUPT_bottom;
}

- (void)setUUPT_extendToBottom:(CGFloat)UUPT_extendToBottom {
    self.UUPT_height = UUPT_extendToBottom - self.UUPT_top;
    self.UUPT_bottom = UUPT_extendToBottom;
}

- (CGFloat)UUPT_extendToRight {
    return self.UUPT_right;
}

- (void)setUUPT_extendToRight:(CGFloat)UUPT_extendToRight {
    self.UUPT_width = UUPT_extendToRight - self.UUPT_left;
    self.UUPT_right = UUPT_extendToRight;
}

- (CGFloat)UUPT_leftWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)UUPT_topWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}

@end


@implementation UIView (CGAffineTransform)

- (CGFloat)UUPT_scaleX {
    return self.transform.a;
}

- (CGFloat)UUPT_scaleY {
    return self.transform.d;
}

- (CGFloat)UUPT_translationX {
    return self.transform.tx;
}

- (CGFloat)UUPT_translationY {
    return self.transform.ty;
}

@end


@implementation UIView (UUPT_Snapshotting)

- (UIImage *)UUPT_snapshotLayerImage {
    return [UIImage UUPT_imageWithView:self];
}

- (UIImage *)UUPT_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates {
    return [UIImage UUPT_imageWithView:self afterScreenUpdates:afterScreenUpdates];
}

@end


@implementation UIView (UUPT_Debug)

UUPTSynthesizeBOOLProperty(UUPT_needsDifferentDebugColor, setUUPT_needsDifferentDebugColor)
UUPTSynthesizeBOOLProperty(UUPT_hasDebugColor, setUUPT_hasDebugColor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments([UIView class], @selector(layoutSubviews), ^(UIView *selfObject) {
            if (selfObject.UUPT_shouldShowDebugColor) {
                selfObject.UUPT_hasDebugColor = YES;
                selfObject.backgroundColor = [selfObject debugColor];
                [selfObject renderColorWithSubviews:selfObject.subviews];
            }
        });
    });
}

static char kAssociatedObjectKey_shouldShowDebugColor;
- (void)setUUPT_shouldShowDebugColor:(BOOL)UUPT_shouldShowDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor, @(UUPT_shouldShowDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (UUPT_shouldShowDebugColor) {
        [self setNeedsLayout];
    }
}
- (BOOL)UUPT_shouldShowDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor) boolValue];
    return flag;
}

static char kAssociatedObjectKey_layoutSubviewsBlock;
static NSMutableSet * UUPT_registeredLayoutSubviewsBlockClasses;
- (void)setUUPT_layoutSubviewsBlock:(void (^)(__kindof UIView * _Nonnull))UUPT_layoutSubviewsBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_layoutSubviewsBlock, UUPT_layoutSubviewsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!UUPT_registeredLayoutSubviewsBlockClasses) UUPT_registeredLayoutSubviewsBlockClasses = [NSMutableSet set];
    if (UUPT_layoutSubviewsBlock) {
        Class viewClass = self.class;
        if (![UUPT_registeredLayoutSubviewsBlockClasses containsObject:viewClass]) {
            // Extend 每个实例对象的类是为了保证比子类的 layoutSubviews 逻辑要更晚调用
            ExtendImplementationOfVoidMethodWithoutArguments(viewClass, @selector(layoutSubviews), ^(__kindof UIView *selfObject) {
                if (selfObject.UUPT_layoutSubviewsBlock && [selfObject isMemberOfClass:viewClass]) {
                    selfObject.UUPT_layoutSubviewsBlock(selfObject);
                }
            });
            [UUPT_registeredLayoutSubviewsBlockClasses addObject:viewClass];
        }
    }
}

- (void (^)(UIView * _Nonnull))UUPT_layoutSubviewsBlock {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_layoutSubviewsBlock);
}

- (void)renderColorWithSubviews:(NSArray *)subviews {
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIStackView class]]) {
            UIStackView *stackView = (UIStackView *)view;
            [self renderColorWithSubviews:stackView.arrangedSubviews];
        }
        view.UUPT_hasDebugColor = YES;
        view.UUPT_shouldShowDebugColor = self.UUPT_shouldShowDebugColor;
        view.UUPT_needsDifferentDebugColor = self.UUPT_needsDifferentDebugColor;
        view.backgroundColor = [self debugColor];
    }
}

- (UIColor *)debugColor {
    if (!self.UUPT_needsDifferentDebugColor) {
        return UIColorTestRed;
    } else {
        return [[UIColor UUPT_randomColor] colorWithAlphaComponent:.3];
    }
}

@end
