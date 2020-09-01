//
//  UIApplication+TATBase.m
//  TATMediaSDK
//
//  Created by wuleslie on 2020/4/9.
//  Copyright © 2020 wuleslie. All rights reserved.
//

#import "UIApplication+TATBase.h"

@implementation UIApplication (TATBase)

+ (UIWindow *)tat_keyWindow {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}

@end
