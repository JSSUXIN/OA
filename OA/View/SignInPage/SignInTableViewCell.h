//
//  SignInTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface SignInTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel *mainAddress;

@property (nonatomic,strong) UILabel *detailAddress;


@property (nonatomic,strong) UIButton *selectedButton;

- (void)setContentWithModel:(AddressModel *)model;

@end
