//
//  WebViewController.h
//  iOSWebInteractionDemo
//
//  Created by wuleslie on 2020/8/31.
//  Copyright © 2020 wuleslie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController

/**
 * 活动链接
 */
@property (nonatomic, copy) NSString *urlString;
/**
 * 页面标题，如果没有，内部会自行获取处理
 */
@property (nonatomic, copy) NSString *pageTitle;

@end

NS_ASSUME_NONNULL_END
