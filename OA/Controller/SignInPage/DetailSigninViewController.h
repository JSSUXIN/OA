//
//  DetailSigninViewController.h
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

@interface DetailSigninViewController : BaseViewController

@property(strong,nonatomic)  AddrssLocation *loca;
@property(copy,nonatomic)  NSString *time;
@property(copy,nonatomic)  NSString *address;

@end
