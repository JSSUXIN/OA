//
//  NoImageTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/4.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeNewsModel.h"

@interface NoImageTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *timeLabel;

- (void)setNoticeContent:(NoticeNewsModel *)model;


@end
