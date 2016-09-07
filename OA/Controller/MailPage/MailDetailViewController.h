//
//  WriteNewMailViewController.h
//  OA
//
//  Created by Elon Musk on 16/8/11.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"
#import "MailDetailModel.h"


typedef NS_ENUM(NSInteger,DetailType)
{
    WriteMail = 0,//写邮件
    OutboxMail,//发件箱详情
    InboxMail,//收件箱详情
    DraftboxMail, //草稿箱详情
    DusbinboxMail, //垃圾箱详情
    EditMail,   //草稿箱点击编辑
    ReturnMail,  //收件箱点击回复
    Transpond   //转发
};

@interface MailDetailViewController : BaseViewController

@property(assign,nonatomic) DetailType mailType;

@property (nonatomic,strong) NSString *mailId;

@property (nonatomic,strong) MailDetailModel *mailModel;

@property (nonatomic,strong) NSMutableArray *sendArray;

@end
