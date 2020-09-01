//
//  TATCoreDevice.m
//  TATMediaSDK
//
//  Created by wuleslie on 2019/12/11.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATCoreDevice.h"
#import <UIKit/UIKit.h>
#import "UIApplication+TATBase.h"

#define TAT_IS_IOS_11 (([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 10.5) ? YES : NO)

@implementation TATCoreDevice

+ (BOOL)isIPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }

    if (TAT_IS_IOS_11) {
        UIWindow *mainWindow = [UIApplication tat_keyWindow];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

@end
