//
//  DateAlertView.h
//  OA
//
//  Created by Elon Musk on 16/7/18.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewDelegate <NSObject>

- (void)getDateWithYear:(NSString *)year Month:(NSString *)month;

@end

@interface DateAlertView : UIView

@property (nonatomic,strong ) id <DateViewDelegate> delegate;


@end
