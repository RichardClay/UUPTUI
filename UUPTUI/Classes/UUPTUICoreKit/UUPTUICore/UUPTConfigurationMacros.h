/*****
 * Tencent is pleased to support the open source community by making UUPT_iOS available.
 * Copyright (C) 2016-2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/

//
//  UUPTConfigurationMacros.h
//  UUPT
//
//  Created by UUPT Team on 14-7-2.
//

#import "UUPTConfiguration.h"


/**
 *  提供一系列方便书写的宏，以便在代码里读取配置表的各种属性。
 *  @warning 请不要在 + load 方法里调用 UUPTConfigurationTemplate 或 UUPTConfigurationMacros 提供的宏，那个时机太早，可能导致 crash
 *  @waining 维护时，如果需要增加一个宏，则需要定义一个新的 UUPTConfiguration 属性。
 */


// 单例的宏

#define UUPTCMI ({[[UUPTConfiguration sharedInstance] applyInitialTemplate];[UUPTConfiguration sharedInstance];})

/// 标志当前项目是否正使用配置表功能
#define UUPTCMIActivated            [UUPTCMI active]

#pragma mark - Global Color

// 基础颜色
#define UIColorClear                [UUPTCMI clearColor]
#define UIColorWhite                [UUPTCMI whiteColor]
#define UIColorBlack                [UUPTCMI blackColor]
#define UIColorGray                 [UUPTCMI grayColor]
#define UIColorGrayDarken           [UUPTCMI grayDarkenColor]
#define UIColorGrayLighten          [UUPTCMI grayLightenColor]
#define UIColorRed                  [UUPTCMI redColor]
#define UIColorGreen                [UUPTCMI greenColor]
#define UIColorBlue                 [UUPTCMI blueColor]
#define UIColorYellow               [UUPTCMI yellowColor]

// 功能颜色
#define UIColorLink                 [UUPTCMI linkColor]                       // 全局统一文字链接颜色
#define UIColorDisabled             [UUPTCMI disabledColor]                   // 全局统一文字disabled颜色
#define UIColorForBackground        [UUPTCMI backgroundColor]                 // 全局统一的背景色
#define UIColorMask                 [UUPTCMI maskDarkColor]                   // 全局统一的mask背景色
#define UIColorMaskWhite            [UUPTCMI maskLightColor]                  // 全局统一的mask背景色，白色
#define UIColorSeparator            [UUPTCMI separatorColor]                  // 全局分隔线颜色
#define UIColorSeparatorDashed      [UUPTCMI separatorDashedColor]            // 全局分隔线颜色（虚线）
#define UIColorPlaceholder          [UUPTCMI placeholderColor]                // 全局的输入框的placeholder颜色

// 测试用的颜色
#define UIColorTestRed              [UUPTCMI testColorRed]
#define UIColorTestGreen            [UUPTCMI testColorGreen]
#define UIColorTestBlue             [UUPTCMI testColorBlue]

// 可操作的控件
#pragma mark - UIControl

#define UIControlHighlightedAlpha       [UUPTCMI controlHighlightedAlpha]          // 一般control的Highlighted透明值
#define UIControlDisabledAlpha          [UUPTCMI controlDisabledAlpha]             // 一般control的Disable透明值

// 按钮
#pragma mark - UIButton
#define ButtonHighlightedAlpha          [UUPTCMI buttonHighlightedAlpha]           // 按钮Highlighted状态的透明度
#define ButtonDisabledAlpha             [UUPTCMI buttonDisabledAlpha]              // 按钮Disabled状态的透明度
#define ButtonTintColor                 [UUPTCMI buttonTintColor]                  // 普通按钮的颜色

#define GhostButtonColorBlue            [UUPTCMI ghostButtonColorBlue]              // UUPTGhostButtonColorBlue的颜色
#define GhostButtonColorRed             [UUPTCMI ghostButtonColorRed]               // UUPTGhostButtonColorRed的颜色
#define GhostButtonColorGreen           [UUPTCMI ghostButtonColorGreen]             // UUPTGhostButtonColorGreen的颜色
#define GhostButtonColorGray            [UUPTCMI ghostButtonColorGray]              // UUPTGhostButtonColorGray的颜色
#define GhostButtonColorWhite           [UUPTCMI ghostButtonColorWhite]             // UUPTGhostButtonColorWhite的颜色

#define FillButtonColorBlue             [UUPTCMI fillButtonColorBlue]              // UUPTFillButtonColorBlue的颜色
#define FillButtonColorRed              [UUPTCMI fillButtonColorRed]               // UUPTFillButtonColorRed的颜色
#define FillButtonColorGreen            [UUPTCMI fillButtonColorGreen]             // UUPTFillButtonColorGreen的颜色
#define FillButtonColorGray             [UUPTCMI fillButtonColorGray]              // UUPTFillButtonColorGray的颜色
#define FillButtonColorWhite            [UUPTCMI fillButtonColorWhite]             // UUPTFillButtonColorWhite的颜色

#pragma mark - TextInput
#define TextFieldTintColor              [UUPTCMI textFieldTintColor]               // 全局UITextField、UITextView的tintColor
#define TextFieldTextInsets             [UUPTCMI textFieldTextInsets]              // UUPTTextField的内边距
#define KeyboardAppearance              [UUPTCMI keyboardAppearance]

#pragma mark - UISwitch
#define SwitchOnTintColor               [UUPTCMI switchOnTintColor]                 // UISwitch 打开时的背景色（除了圆点外的其他颜色）
#define SwitchOffTintColor              [UUPTCMI switchOffTintColor]                // UISwitch 关闭时的背景色（除了圆点外的其他颜色）
#define SwitchTintColor                 [UUPTCMI switchTintColor]                   // UISwitch 关闭时的周围边框颜色
#define SwitchThumbTintColor            [UUPTCMI switchThumbTintColor]              // UISwitch 中间的操控圆点的颜色

#pragma mark - NavigationBar

#define NavBarHighlightedAlpha                          [UUPTCMI navBarHighlightedAlpha]
#define NavBarDisabledAlpha                             [UUPTCMI navBarDisabledAlpha]
#define NavBarButtonFont                                [UUPTCMI navBarButtonFont]
#define NavBarButtonFontBold                            [UUPTCMI navBarButtonFontBold]
#define NavBarBackgroundImage                           [UUPTCMI navBarBackgroundImage]
#define NavBarShadowImage                               [UUPTCMI navBarShadowImage]
#define NavBarShadowImageColor                          [UUPTCMI navBarShadowImageColor]
#define NavBarBarTintColor                              [UUPTCMI navBarBarTintColor]
#define NavBarStyle                                     [UUPTCMI navBarStyle]
#define NavBarTintColor                                 [UUPTCMI navBarTintColor]
#define NavBarTitleColor                                [UUPTCMI navBarTitleColor]
#define NavBarTitleFont                                 [UUPTCMI navBarTitleFont]
#define NavBarLargeTitleColor                           [UUPTCMI navBarLargeTitleColor]
#define NavBarLargeTitleFont                            [UUPTCMI navBarLargeTitleFont]
#define NavBarBarBackButtonTitlePositionAdjustment      [UUPTCMI navBarBackButtonTitlePositionAdjustment]
#define NavBarBackIndicatorImage                        [UUPTCMI navBarBackIndicatorImage]
#define SizeNavBarBackIndicatorImageAutomatically       [UUPTCMI sizeNavBarBackIndicatorImageAutomatically]
#define NavBarCloseButtonImage                          [UUPTCMI navBarCloseButtonImage]

#define NavBarLoadingMarginRight                        [UUPTCMI navBarLoadingMarginRight]                          // titleView里左边的loading的右边距
#define NavBarAccessoryViewMarginLeft                   [UUPTCMI navBarAccessoryViewMarginLeft]                     // titleView里的accessoryView的左边距
#define NavBarActivityIndicatorViewStyle                [UUPTCMI navBarActivityIndicatorViewStyle]                  // titleView loading 的style
#define NavBarAccessoryViewTypeDisclosureIndicatorImage [UUPTCMI navBarAccessoryViewTypeDisclosureIndicatorImage]   // titleView上倒三角的默认图片


#pragma mark - TabBar

#define TabBarBackgroundImage                           [UUPTCMI tabBarBackgroundImage]
#define TabBarBarTintColor                              [UUPTCMI tabBarBarTintColor]
#define TabBarShadowImageColor                          [UUPTCMI tabBarShadowImageColor]
#define TabBarStyle                                     [UUPTCMI tabBarStyle]
#define TabBarItemTitleFont                             [UUPTCMI tabBarItemTitleFont]
#define TabBarItemTitleColor                            [UUPTCMI tabBarItemTitleColor]
#define TabBarItemTitleColorSelected                    [UUPTCMI tabBarItemTitleColorSelected]
#define TabBarItemImageColor                            [UUPTCMI tabBarItemImageColor]
#define TabBarItemImageColorSelected                    [UUPTCMI tabBarItemImageColorSelected]

#pragma mark - Toolbar

#define ToolBarHighlightedAlpha                         [UUPTCMI toolBarHighlightedAlpha]
#define ToolBarDisabledAlpha                            [UUPTCMI toolBarDisabledAlpha]
#define ToolBarTintColor                                [UUPTCMI toolBarTintColor]
#define ToolBarTintColorHighlighted                     [UUPTCMI toolBarTintColorHighlighted]
#define ToolBarTintColorDisabled                        [UUPTCMI toolBarTintColorDisabled]
#define ToolBarBackgroundImage                          [UUPTCMI toolBarBackgroundImage]
#define ToolBarBarTintColor                             [UUPTCMI toolBarBarTintColor]
#define ToolBarShadowImageColor                         [UUPTCMI toolBarShadowImageColor]
#define ToolBarStyle                                    [UUPTCMI toolBarStyle]
#define ToolBarButtonFont                               [UUPTCMI toolBarButtonFont]


#pragma mark - SearchBar

#define SearchBarTextFieldBorderColor                   [UUPTCMI searchBarTextFieldBorderColor]
#define SearchBarTextFieldBackgroundImage               [UUPTCMI searchBarTextFieldBackgroundImage]
#define SearchBarBackgroundImage                        [UUPTCMI searchBarBackgroundImage]
#define SearchBarTintColor                              [UUPTCMI searchBarTintColor]
#define SearchBarTextColor                              [UUPTCMI searchBarTextColor]
#define SearchBarPlaceholderColor                       [UUPTCMI searchBarPlaceholderColor]
#define SearchBarFont                                   [UUPTCMI searchBarFont]
#define SearchBarSearchIconImage                        [UUPTCMI searchBarSearchIconImage]
#define SearchBarClearIconImage                         [UUPTCMI searchBarClearIconImage]
#define SearchBarTextFieldCornerRadius                  [UUPTCMI searchBarTextFieldCornerRadius]


#pragma mark - TableView / TableViewCell

#define TableViewEstimatedHeightEnabled                 [UUPTCMI tableViewEstimatedHeightEnabled]            // 是否要开启全局 UITableView 的 estimatedRow(Section/Footer)Height

#define TableViewBackgroundColor                        [UUPTCMI tableViewBackgroundColor]                   // 普通列表的背景色
#define TableSectionIndexColor                          [UUPTCMI tableSectionIndexColor]                     // 列表右边索引条的文字颜色
#define TableSectionIndexBackgroundColor                [UUPTCMI tableSectionIndexBackgroundColor]           // 列表右边索引条的背景色
#define TableSectionIndexTrackingBackgroundColor        [UUPTCMI tableSectionIndexTrackingBackgroundColor]   // 列表右边索引条按下时的背景色
#define TableViewSeparatorColor                         [UUPTCMI tableViewSeparatorColor]                    // 列表分隔线颜色
#define TableViewCellBackgroundColor                    [UUPTCMI tableViewCellBackgroundColor]               // 列表 cell 的背景色
#define TableViewCellSelectedBackgroundColor            [UUPTCMI tableViewCellSelectedBackgroundColor]       // 列表 cell 按下时的背景色
#define TableViewCellWarningBackgroundColor             [UUPTCMI tableViewCellWarningBackgroundColor]        // 列表 cell 在提醒状态下的背景色
#define TableViewCellNormalHeight                       [UUPTCMI tableViewCellNormalHeight]                  // UUPTTableView 的默认 cell 高度

#define TableViewCellDisclosureIndicatorImage           [UUPTCMI tableViewCellDisclosureIndicatorImage]      // 列表 cell 右边的箭头图片
#define TableViewCellCheckmarkImage                     [UUPTCMI tableViewCellCheckmarkImage]                // 列表 cell 右边的打钩checkmark
#define TableViewCellDetailButtonImage                  [UUPTCMI tableViewCellDetailButtonImage]             // 列表 cell 右边的 i 按钮
#define TableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator [UUPTCMI tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator]   // 列表 cell 右边的 i 按钮和向右箭头之间的间距（仅当两者都使用了自定义图片并且同时显示时才生效）

#define TableViewSectionHeaderBackgroundColor           [UUPTCMI tableViewSectionHeaderBackgroundColor]
#define TableViewSectionFooterBackgroundColor           [UUPTCMI tableViewSectionFooterBackgroundColor]
#define TableViewSectionHeaderFont                      [UUPTCMI tableViewSectionHeaderFont]
#define TableViewSectionFooterFont                      [UUPTCMI tableViewSectionFooterFont]
#define TableViewSectionHeaderTextColor                 [UUPTCMI tableViewSectionHeaderTextColor]
#define TableViewSectionFooterTextColor                 [UUPTCMI tableViewSectionFooterTextColor]
#define TableViewSectionHeaderAccessoryMargins          [UUPTCMI tableViewSectionHeaderAccessoryMargins]
#define TableViewSectionFooterAccessoryMargins          [UUPTCMI tableViewSectionFooterAccessoryMargins]
#define TableViewSectionHeaderContentInset              [UUPTCMI tableViewSectionHeaderContentInset]
#define TableViewSectionFooterContentInset              [UUPTCMI tableViewSectionFooterContentInset]

#define TableViewGroupedBackgroundColor                 [UUPTCMI tableViewGroupedBackgroundColor]               // Grouped 类型的 UUPTTableView 的背景色
#define TableViewGroupedCellTitleLabelColor             [UUPTCMI tableViewGroupedCellTitleLabelColor]           // Grouped 类型的列表的 UUPTTableViewCell 的标题颜色
#define TableViewGroupedCellDetailLabelColor            [UUPTCMI tableViewGroupedCellDetailLabelColor]          // Grouped 类型的列表的 UUPTTableViewCell 的副标题颜色
#define TableViewGroupedCellBackgroundColor             [UUPTCMI tableViewGroupedCellBackgroundColor]           // Grouped 类型的列表的 UUPTTableViewCell 的背景色
#define TableViewGroupedCellSelectedBackgroundColor     [UUPTCMI tableViewGroupedCellSelectedBackgroundColor]   // Grouped 类型的列表的 UUPTTableViewCell 点击时的背景色
#define TableViewGroupedCellWarningBackgroundColor      [UUPTCMI tableViewGroupedCellWarningBackgroundColor]    // Grouped 类型的列表的 UUPTTableViewCell 在提醒状态下的背景色
#define TableViewGroupedSectionHeaderFont               [UUPTCMI tableViewGroupedSectionHeaderFont]
#define TableViewGroupedSectionFooterFont               [UUPTCMI tableViewGroupedSectionFooterFont]
#define TableViewGroupedSectionHeaderTextColor          [UUPTCMI tableViewGroupedSectionHeaderTextColor]
#define TableViewGroupedSectionFooterTextColor          [UUPTCMI tableViewGroupedSectionFooterTextColor]
#define TableViewGroupedSectionHeaderAccessoryMargins   [UUPTCMI tableViewGroupedSectionHeaderAccessoryMargins]
#define TableViewGroupedSectionFooterAccessoryMargins   [UUPTCMI tableViewGroupedSectionFooterAccessoryMargins]
#define TableViewGroupedSectionHeaderDefaultHeight      [UUPTCMI tableViewGroupedSectionHeaderDefaultHeight]
#define TableViewGroupedSectionFooterDefaultHeight      [UUPTCMI tableViewGroupedSectionFooterDefaultHeight]
#define TableViewGroupedSectionHeaderContentInset       [UUPTCMI tableViewGroupedSectionHeaderContentInset]
#define TableViewGroupedSectionFooterContentInset       [UUPTCMI tableViewGroupedSectionFooterContentInset]

#define TableViewCellTitleLabelColor                    [UUPTCMI tableViewCellTitleLabelColor]               // cell的title颜色
#define TableViewCellDetailLabelColor                   [UUPTCMI tableViewCellDetailLabelColor]              // cell的detailTitle颜色

#pragma mark - UIWindowLevel
#define UIWindowLevelUUPTAlertView                      [UUPTCMI windowLevelUUPTAlertView]

#pragma mark - UUPTLog
#define ShouldPrintDefaultLog                           [UUPTCMI shouldPrintDefaultLog]
#define ShouldPrintInfoLog                              [UUPTCMI shouldPrintInfoLog]
#define ShouldPrintWarnLog                              [UUPTCMI shouldPrintWarnLog]

#pragma mark - UUPTBadge
#define BadgeBackgroundColor                            [UUPTCMI badgeBackgroundColor]
#define BadgeTextColor                                  [UUPTCMI badgeTextColor]
#define BadgeFont                                       [UUPTCMI badgeFont]
#define BadgeContentEdgeInsets                          [UUPTCMI badgeContentEdgeInsets]
#define BadgeCenterOffset                               [UUPTCMI badgeCenterOffset]
#define BadgeCenterOffsetLandscape                      [UUPTCMI badgeCenterOffsetLandscape]

#define UpdatesIndicatorColor                           [UUPTCMI updatesIndicatorColor]
#define UpdatesIndicatorSize                            [UUPTCMI updatesIndicatorSize]
#define UpdatesIndicatorCenterOffset                    [UUPTCMI updatesIndicatorCenterOffset]
#define UpdatesIndicatorCenterOffsetLandscape           [UUPTCMI updatesIndicatorCenterOffsetLandscape]

#pragma mark - Others

#define AutomaticCustomNavigationBarTransitionStyle [UUPTCMI automaticCustomNavigationBarTransitionStyle] // 界面 push/pop 时是否要自动根据两个界面的 barTintColor/backgroundImage/shadowImage 的样式差异来决定是否使用自定义的导航栏效果
#define SupportedOrientationMask                        [UUPTCMI supportedOrientationMask]          // 默认支持的横竖屏方向
#define AutomaticallyRotateDeviceOrientation            [UUPTCMI automaticallyRotateDeviceOrientation]  // 是否在界面切换或 viewController.supportedOrientationMask 发生变化时自动旋转屏幕，默认为 NO
#define StatusbarStyleLightInitially                    [UUPTCMI statusbarStyleLightInitially]      // 默认的状态栏内容是否使用白色，默认为NO，也即黑色
#define NeedsBackBarButtonItemTitle                     [UUPTCMI needsBackBarButtonItemTitle]       // 全局是否需要返回按钮的title，不需要则只显示一个返回image
#define HidesBottomBarWhenPushedInitially               [UUPTCMI hidesBottomBarWhenPushedInitially] // UUPTCommonViewController.hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
#define PreventConcurrentNavigationControllerTransitions [UUPTCMI preventConcurrentNavigationControllerTransitions] // PreventConcurrentNavigationControllerTransitions : 自动保护 UUPTNavigationController 在上一次 push/pop 尚未结束的时候就进行下一次 push/pop 的行为，避免产生 crash
#define NavigationBarHiddenInitially                    [UUPTCMI navigationBarHiddenInitially]      // preferredNavigationBarHidden 的初始值，默认为NO
#define ShouldFixTabBarTransitionBugInIPhoneX           [UUPTCMI shouldFixTabBarTransitionBugInIPhoneX] // 是否需要自动修复 iOS 11 下，iPhone X 的设备在 push 界面时，tabBar 会瞬间往上跳的 bug
#define ShouldFixTabBarButtonBugForAll                  [UUPTCMI shouldFixTabBarButtonBugForAll] // 是否要对 iOS 12.1.2 及以后的版本也修复手势返回时 tabBarButton 布局错误的 bug(issue #410)，默认为 NO
#define ShouldPrintUUPTWarnLogToConsole                 [UUPTCMI shouldPrintUUPTWarnLogToConsole] // 是否在出现 UUPTLogWarn 时自动把这些 log 以 UUPTConsole 的方式显示到设备屏幕上
#define SendAnalyticsToUUPTTeam                         [UUPTCMI sendAnalyticsToUUPTTeam] // 是否允许在 DEBUG 模式下上报 Bundle Identifier 和 Display Name 给 UUPT 统计用
#define DynamicPreferredValueForIPad                    [UUPTCMI dynamicPreferredValueForIPad] // 当 iPad 处于 Slide Over 或 Split View 分屏模式下，宏 `PreferredValueForXXX` 是否把 iPad 视为某种屏幕宽度近似的 iPhone 来取值。
#define IgnoreKVCAccessProhibited                       [UUPTCMI ignoreKVCAccessProhibited] // 是否全局忽略 iOS 13 对 KVC 访问 UIKit 私有属性的限制
#define AdjustScrollIndicatorInsetsByContentInsetAdjustment [UUPTCMI adjustScrollIndicatorInsetsByContentInsetAdjustment] // 当将 UIScrollView.contentInsetAdjustmentBehavior 设为 UIScrollViewContentInsetAdjustmentNever 时，是否自动将 UIScrollView.automaticallyAdjustsScrollIndicatorInsets 设为 NO，以保证原本在 iOS 12 下的代码不用修改就能在 iOS 13 下正常控制滚动条的位置。

