//
//  TelTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "usersModel.h"

@interface TelTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UILabel *detailText;


@property (nonatomic,strong) UILabel *telep;


@property (nonatomic,strong) UILabel *nameLabel;
- (void)setContentWithDic:(UsersModel *)model;
    
@end
