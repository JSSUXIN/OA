//
//  MBProgressHUD+Custom.h
//  OA
//
//  Created by Elon Musk on 16/7/22.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#define HUDERRORIMAGE   @"error"
#define HUDSUCCESSIMAGE @"success"
@interface MBProgressHUD (Custom)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
//展示在中间
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;


+ (void)showText:(NSString *)text;//提示
+ (void)showImage:(NSString*)imageUrl;//图片
+ (void)showText:(NSString*)text imageUrl:(NSString*)imageUrl;//提示和图片

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
//展示在底部
+ (void)showText_b:(NSString*)text;
//+ (void)showText_b:(NSString*)text imageUrl:(NSString*)imageUrl;
+ (void)show_b:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

+ (MBProgressHUD *)showHUD;
+ (MBProgressHUD *)showHUD:(NSString*)loading;
+ (MBProgressHUD *)showHUD:(NSString*)loading toView:(UIView *)view;


@end
