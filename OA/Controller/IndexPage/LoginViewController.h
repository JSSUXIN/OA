//
//  LoginViewController.h
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"

@protocol loginDelegate <NSObject>

- (void) reloadIndex;

@end

@interface LoginViewController : BaseViewController

@property (nonatomic,strong) id<loginDelegate> delegate;


@end
