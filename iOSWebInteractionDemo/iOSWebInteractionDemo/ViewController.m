//
//  ViewController.m
//  iOSWebInteractionDemo
//
//  Created by wuleslie on 2020/8/28.
//  Copyright © 2020 wuleslie. All rights reserved.
//

#import "ViewController.h"
#import "TATCoreMacro.h"
#import "WebViewController.h"

typedef NS_ENUM(NSUInteger, TestActionType){
    TestActionTypeSimple = 1000,
    TestActionTypeNative,
    TestActionTypeAccretion
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0];
    [self setupTestEntrance];
}

- (void)setupTestEntrance {
    NSArray *testTypes = @[@(TestActionTypeSimple), @(TestActionTypeNative), @(TestActionTypeAccretion)];
    for (int i = 0; i < testTypes.count; i++) {
        TestActionType type = [testTypes[i] integerValue];
        UIButton *testButton = [self newButtonWithType:type];
        CGRect frame = testButton.frame;
        frame.origin.x = (TAT_SCREEN_WIDTH - CGRectGetWidth(frame)) / 2;
        frame.origin.y = 200 + (CGRectGetHeight(frame) + 32) * i;
        testButton.frame = frame;
        [self.view addSubview:testButton];
    }
}

- (void)gotoWebPage:(UIButton *)button {
    NSString *urlString = nil;
    switch (button.tag) {
        case TestActionTypeSimple:
            urlString = @"https://engine.tuiapre.cn/index/activity?appKey=4UycwwZv41rwzne1ZXgtQBgDSnPH&adslotId=323778&userFromType=1&sckId=2749&actsck=0&formUserId=190026&sckFromType=0&newApiRid=0acc7260kecp3dlu-20254893&sdkVersion=3.0.0.0&userId=190026";
            break;
        case TestActionTypeNative:
            urlString = @"https://engine.tuiapre.cn/index/activity?appKey=4UycwwZv41rwzne1ZXgtQBgDSnPH&adslotId=325021&userFromType=1&sckId=-1&actsck=0&formUserId=190026&sckFromType=0&newApiRid=0acc61bdkecpfku9-20215390&sdkVersion=3.0.0.0&userId=190026";
            break;
        case TestActionTypeAccretion:
            urlString = @"https://engine.tuiatest.cn/index/activity2?appKey=427wTcUcwxkttDmGcqYMTU7NJo3k&slotId=283557&subActivityWay=1&tck_rid_6c8=0a680be6ke2de0zc-137&login=normal&tck_loc_c5d=tactivity-8257&deviceId=9f89c84a559f573636a47ff8daed0d33&dcm=401.283557.0.37&tenter=SOW&specialType=0&sckId=571&isTestActivityType=0&sckFromType=0&newApiRid=0a680be6ke2de0zc-137&id=8257&dsm2=1.283557.1.8257&userFromType=1&actsck=1&netType=2&formUserId=null&idfa=9f89c84a559f573636a47ff8daed0d33&ep=Ppf8VAmvsBxlhOoV39QYB2Gsh31wmpGUgepXzPt4477H-iDpHPaenElaNCm1cOQs5up260ygvk4tL5IU6I8rXw==&actSckMd=H4sIAAAAAAAAAKtWKkktLgnISczzTFGyUlLSUUpMLgktygSyM0pKCoqt9PWBApllmSWVeiWlmYkg1XrJeXBB_cy8lNQKiDawCRZGpuZAbgGSiUWZIIZBopmFQVKqWXaqUUqqQVWyrqExSGFOYmleckZIZUEqSI1SLQCqDhzfkQAAAA==&visType=0&sourcePage=8257&sdkVersion=3.0.0.0&userType=2&dsm=1.283557.0.0&openStyleType=992&preloading=1&userId=12345";
            break;
        default:
            break;
    }
    WebViewController *webVC = [WebViewController new];
    webVC.urlString = urlString;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController: webVC];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
}

- (UIButton *)newButtonWithType:(TestActionType)type {
    NSString *title = nil;
    switch (type) {
        case TestActionTypeSimple:
            title = @"简单展示";
            break;
        case TestActionTypeNative:
            title = @"原生活动";
            break;
        case TestActionTypeAccretion:
            title = @"增值活动";
            break;
        default:
            break;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 200, 60);
    button.tag = type;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.layer.cornerRadius = 20;
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoWebPage:) forControlEvents:UIControlEventTouchUpInside];
    return button;;
}

@end
