//
//  AttachmentTableViewCell.h
//  OA
//
//  Created by Elon Musk on 16/8/26.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeNewsModel.h"
#import "MailFileModel.h"

@interface AttachmentTableViewCell : UITableViewCell


@property (nonatomic,strong) UIImageView *styleImage;

@property (nonatomic,strong) UILabel *nameLabel;


- (void)setContenView:(FileModel *)model;

- (void)setCOntent:(MailFileModel *)model;


@end
