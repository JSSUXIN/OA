//
//  MailListViewController.h
//  OA
//
//  Created by Elon Musk on 16/8/10.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,MailType)
{
    Inbox=0,
    Outbox,
    Draftbox,
    Dusbinbox
};

@protocol MailListDelegate <NSObject>

- (void)clickRecovery;

@end

@interface MailListViewController : BaseViewController
@property(assign,nonatomic) MailType BoxType;

@property(assign,nonatomic) id<MailListDelegate> delegate;


@end
