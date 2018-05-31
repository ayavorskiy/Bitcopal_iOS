//
//  GameWebViewController.m
//  Bitcopal
//
//  Created by Костюкевич Илья on 27.05.2018.
//  Copyright © 2018 Open Whisper Systems. All rights reserved.
//

#import "GameWebViewController.h"
#import <WebKit/WebKit.h>
#import <SignalMessaging/UIUtil.h>

@interface GameWebViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation GameWebViewController

- (void)loadView {
    [super loadView];
    
    self.webView = [WKWebView new];
    self.webView.navigationDelegate = self;
    self.view = self.webView;
    
    self.activityIndicator = [UIActivityIndicatorView new];
    [self.activityIndicator setColor:[UIColor ows_signalBrandBlueColor]];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.webView addSubview:self.activityIndicator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRequest];
    [self.activityIndicator startAnimating];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect viewBounds = self.view.bounds;
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds));
}

- (void)loadRequest {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.activityIndicator stopAnimating];
}

@end
