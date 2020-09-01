//
//  WebViewController.m
//  iOSWebInteractionDemo
//
//  Created by wuleslie on 2020/8/31.
//  Copyright © 2020 wuleslie. All rights reserved.
//

#import "WebViewController.h"
#import "TATCoreMacro.h"
#import "TATWKWebViewJavascriptBridge.h"

@import WebKit;

static NSString * const kJSH5RewardProtocol = @"TAHandlerReward";
static NSString * const kJSH5CloseProtocol = @"TAHandlerClose";

@interface WebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
// 进度条
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) TATWKWebViewJavascriptBridge *bridge;

@end

@implementation WebViewController

#pragma mark - 视图控制器生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self cleanupWebViewCache];
    [self setupWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addScriptMsgHandler];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeScriptMsgHandler];
}

#pragma mark - 导航栏

- (void)configNavigationBar {
    if (self.pageTitle) {
        self.title = self.pageTitle;
    } else {
        self.title = @"详情";
    }
    [self customizeBackButton];
}

- (void)customizeBackButton {
    UIImage *backIcon = [UIImage imageNamed:@"tat_navigation_back.png"];
    CGRect frame = CGRectZero;
    frame.size = backIcon.size;
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:backIcon forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(returnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)returnPress:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self close];
    }
}

- (void)close {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else { //present方式
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - WebView

- (void)setupWebView {
    CGFloat originY = TAT_OnePixel;
    CGRect frame = CGRectMake(0, originY, TAT_SCREEN_WIDTH, TAT_SCREEN_HEIGHT - TAT_NavigationBarBottom);
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    configuration.userContentController = userController;
    // 初始化
    self.webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    // 设置自己为webView的代理
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    // 加载链接
    NSURL *webURL = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:webURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [self.webView loadRequest:request];
    // 添加到视图
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    // 进度条、标题监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    // 配置UA
    [self configUserAgent];
}

- (void)cleanupWebViewCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)configUserAgent {
    NSString *diyUserAgent = @"duibaios881";
    __weak __typeof(self)weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        NSString *oldUserAgent = nil;
        if (error) {
            NSLog(@"===Fail to get userAgent:%@", error);
        } else {
            oldUserAgent = result;
        }
        NSString *newUserAgent = [NSString stringWithFormat:@"%@/%@", oldUserAgent, diyUserAgent];
        self.webView.customUserAgent = newUserAgent;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    } else if ([keyPath isEqual:@"title"] && object == self.webView) {
        if (!self.pageTitle && self.webView.title) {
            self.title = self.webView.title;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setupBridge {
    [TATWKWebViewJavascriptBridge enableLogging];
    self.bridge = [TATWKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    __weak __typeof(self)weakSelf = self;
    [self.bridge registerHandler:@"modalClose" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
    }];
    
    [self.bridge registerHandler:@"rewardClose" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
        
    }];
    
    [self.bridge registerHandler:@"modalShow" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
    }];
    
    [self.bridge registerHandler:@"jumpToLand" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
        //NSString *jumpUrl = data[@"data"][@"jumpUrl"];
        //[self jumpToLoadURL:jumpUrl];
    }];
    
    [self.bridge registerHandler:@"myPrize" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
        //NSString *jumpUrl = data[@"data"][@"jumpUrl"];
        //[self jumpToLoadURL:jumpUrl];
    }];
    
    [self.bridge registerHandler:@"getInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback) responseCallback(nil);
    }];
    
    [self.bridge registerHandler:@"changeActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        __strong __typeof(weakSelf)self = weakSelf;
        self.webView = nil;
        //[self startRequest];
    }];
    
    [self.bridge registerHandler:@"beforeModalShow" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
        //NSString *type = data[@"data"][@"type"];
        //self.isModalOn = [type isEqualToString:@"modal"];
    }];
    
    [self.bridge registerHandler:@"initRewardWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
        //NSString *dataInfo = data[@"data"];
        //self.modalView = [[TATModalView alloc] initWithData:(NSDictionary *)dataInfo];
    }];
    
    [self.bridge registerHandler:@"getActInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        //__strong __typeof(weakSelf)self = weakSelf;
    }];
}


- (void)addScriptMsgHandler {
    WKUserContentController *userController = self.webView.configuration.userContentController;
    // 激励活动奖励相关
    [userController addScriptMessageHandler:self name:kJSH5RewardProtocol];
    [userController addScriptMessageHandler:self name:kJSH5CloseProtocol];
}

- (void)removeScriptMsgHandler {
    WKUserContentController *userController = self.webView.configuration.userContentController;
    // 激励活动奖励相关
    [userController removeScriptMessageHandlerForName: kJSH5RewardProtocol];
    [userController removeScriptMessageHandlerForName: kJSH5CloseProtocol];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    //拦截并跳转到appStore
    if (url != nil && url.absoluteString != nil && ([url.absoluteString containsString:@"//itunes.apple.com/"] || [url.absoluteString containsString:@"//apps.apple.com/"]) && [[UIApplication sharedApplication] openURL:url]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"===Navigation did start");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"===Navigation did finish");
}

#pragma mark - WKUIDelegate

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"===message handler name:%@", message.name);
    if ([message.name isEqualToString:kJSH5RewardProtocol]) {
        id body = message.body;
        if ([body isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)body;
            NSLog(@"===Reward object: %@", str);
        }
    } else if ([message.name isEqualToString:kJSH5CloseProtocol]) {
        id body = message.body;
        if ([body isKindOfClass:[NSString class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self returnPress:nil];
            });
        }
    }
}

#pragma mark - getters

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), TAT_OnePixel)];
        _progressView.progressTintColor = [UIColor colorWithRed:0.0 green:136.0/255 blue:1.0 alpha:1.0];
    }
    return _progressView;
}

@end
