//
//  WebViewController.h
//  OA
//
//  Created by Elon Musk on 16/8/8.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeNewsModel.h"

@interface WebViewController : BaseViewController

@property (nonatomic,copy) NSString *urlString;

@property(strong,nonatomic) NoticeNewsModel * NoticeModel;


@end
