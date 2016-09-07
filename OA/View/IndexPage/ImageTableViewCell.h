//
//  ImageTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/4.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeNewsModel.h"

@interface ImageTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UIImageView *detailImageView;


-(void)setNewsContent:(NoticeNewsModel *)model;

@end
