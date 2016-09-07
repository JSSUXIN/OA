//
//  MBProgressHUD+Custom.m
//  OA
//
//  Created by Elon Musk on 16/7/22.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MBProgressHUD+Custom.h"


#define AfterDelay 1.5
#define loadingAfterDelay 15.0
#define HUDWindow [[UIApplication sharedApplication].windows lastObject]

static MBProgressHUD *_bottomHUD = nil;
static MBProgressHUD *_centerHUD = nil;


@implementation MBProgressHUD (Custom)

+ (instancetype)shareHUD:(UIView*)view
{
    if (!_centerHUD) {
        _centerHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    return _centerHUD;
}

+ (instancetype)shareHUD_b:(UIView*)view
{
    if (!_bottomHUD) {
        _bottomHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    return _bottomHUD;
}

#pragma mark - 展示在中间(center) -
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (_centerHUD) {
        [_centerHUD removeFromSuperview];
        _centerHUD = nil;
    }
    // 快速显示一个提示信息
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _centerHUD = [MBProgressHUD shareHUD:view];
    _centerHUD.labelText = text;
    
    // 再设置模式
    _centerHUD.mode = MBProgressHUDModeCustomView;
    
    if (icon != nil)
    {
        BOOL hudImage = ([icon isEqualToString:HUDERRORIMAGE] || [icon isEqualToString:HUDSUCCESSIMAGE])?YES:NO;
        // 设置图片
        NSString *imageName = hudImage?[NSString stringWithFormat:@"%@",icon]:icon;
        
        _centerHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];//
    }
    // 隐藏时候从父控件中移除
    _centerHUD.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [_centerHUD hide:YES afterDelay:AfterDelay];
}


+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
{
    [self show:success icon:HUDSUCCESSIMAGE view:view];
}

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:HUDERRORIMAGE view:view];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:HUDWindow];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:HUDWindow];
}

//展示自定义的
+ (void)showText:(NSString *)text toView:(UIView *)view
{
    [self show:text icon:nil view:view];
}

+ (void)showText:(NSString *)text
{
    [self show:text icon:nil view:mWindow];
}

+ (void)showImage:(NSString*)imageUrl toView:(UIView *)view
{
    [self show:nil icon:imageUrl view:view];
}

+ (void)showImage:(NSString*)imageUrl
{
    [self show:nil icon:imageUrl view:mWindow];
}

+ (void)showText:(NSString*)text imageUrl:(NSString*)imageUrl toView:(UIView *)view
{
    [self show:text icon:imageUrl view:view];
}

+ (void)showText:(NSString*)text imageUrl:(NSString*)imageUrl
{
    [self show:text icon:imageUrl view:mWindow];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:HUDWindow];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:HUDWindow];
}

+ (MBProgressHUD *)showHUD:(NSString*)loading toView:(UIView *)view
{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = loading;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading"]];
    [hud hide:YES afterDelay:loadingAfterDelay];
    return hud;
}

+ (MBProgressHUD *)showHUD:(NSString*)loading
{
    return [self showHUD:loading toView:HUDWindow];
}

+ (MBProgressHUD *)showHUD
{
    return [self showHUD:nil toView:HUDWindow];
}

#pragma mark - 展示在底部(bottom) -
+ (void)show_b:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (_bottomHUD) {
        [_bottomHUD removeFromSuperview];
        _bottomHUD = nil;
    }
    // 快速显示一个提示信息
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDWindow animated:YES];
    _bottomHUD = [MBProgressHUD shareHUD_b:HUDWindow];
    _bottomHUD.labelText = text;
    // 再设置模式
    _bottomHUD.mode = MBProgressHUDModeText;
    _bottomHUD.margin = 10.f;
    _bottomHUD.yOffset = mScreenHeight/2-50;
    // 隐藏时候从父控件中移除
    _bottomHUD.removeFromSuperViewOnHide = YES;
    // 2秒之后再消失
    [_bottomHUD hide:YES afterDelay:AfterDelay];
}

+ (void)showText_b:(NSString*)text toView:(UIView*)view
{
    [self show_b:text icon:nil view:view];
}
+ (void)showText_b:(NSString*)text
{
    [self show_b:text icon:nil view:mWindow];
}

+ (void)showText_b:(NSString*)text imageUrl:(NSString*)imageUrl
{
    [self show_b:text icon:imageUrl view:mWindow];
}


@end
