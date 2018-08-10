//
//  AiPayWebView.h
//  H5WebViewDemo
//
//  Created by Shixiong on 2017/3/2.
//  Copyright © 2017年 Shixiong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  在iOS10及以上的设备上运行H5支付，需要在UIWebView的代理方法中进行拦截;
 *  判断拦截的URL为 http和https 的链接？
 *  如果URL是 http和https 开头的链接，正常使用UIWebView打开就OK！
 *  如果URL不是 http和https 开头的链接，就使用 系统的 OpenURL：方法进行打开链接，
    才能正常打开《微信》或《支付宝》对应客的户端！
 *
 *  问题：在支付宝或微信客户端中支付完成后，不能自动返回。
 *  原因：这个需要看第三方支付方式是否支持自动回调的配置
 *       如果他们支持配置回调的Scheme并开发这边做好配置，则能自动返回。否则就不行！
 */

#pragma mark - AiPayWebViewDelegate
@protocol YCWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end


@interface YCWebView : UIWebView

/**
 *  需实现代理对象
 */
@property (nonatomic, strong) id<YCWebViewDelegate> webViewDelegate;


/**
 *  链接使用OpenURL方法后的回调
 */
@property (nonatomic, copy) void(^openComplete)(NSString *string,BOOL status);


@end

