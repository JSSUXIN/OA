//
//  UIButton+BackgroundColor.m
//  OA
//
//  Created by Elon Musk on 16/7/27.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "UIButton+BackgroundColor.h"

@implementation UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

@end
