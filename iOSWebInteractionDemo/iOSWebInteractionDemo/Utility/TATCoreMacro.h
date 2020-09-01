//
//  TATCoreMacro.h
//  TATMediaSDK
//
//  Created by wuleslie on 2019/12/11.
//  Copyright © 2019 wuleslie. All rights reserved.
//
#import "TATCoreDevice.h"

#ifndef TATCoreMacro_h
#define TATCoreMacro_h

#define TAT_DEVICE_IS_IPHONEX   [TATCoreDevice isIPhoneXSeries]

#define TAT_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define TAT_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

#define TAT_NavigationBarHeight 44
#define TAT_StatusBarHeight (TAT_DEVICE_IS_IPHONEX ? 44.f : 20.f)
#define TAT_TabbBarHeight (TAT_DEVICE_IS_IPHONEX ? (49.f+34.f) : 49.f)
#define TAT_NavigationBarBottom (TAT_DEVICE_IS_IPHONEX ? 88.f : 64.f)

//#define TATSafeAreInsets (^{ if(@available(iOS 11.0, *)) {return [ApplicationKeyWindow safeAreaInsets];} else {return UIEdgeInsetsZero;}}())


#define TAT_OnePixel  1.0 / [UIScreen mainScreen].scale

#endif /* TATCoreMacro_h */
