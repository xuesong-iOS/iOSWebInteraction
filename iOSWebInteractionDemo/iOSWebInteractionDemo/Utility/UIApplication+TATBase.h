//
//  UIApplication+TATBase.h
//  TATMediaSDK
//
//  Created by wuleslie on 2020/4/9.
//  Copyright © 2020 wuleslie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (TATBase)

// keyWindow在iOS 13.0已经废弃，不能直接获取了
+ (UIWindow *)tat_keyWindow;

@end

NS_ASSUME_NONNULL_END
