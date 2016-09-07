//
//  MailListModel.h
//  OA
//
//  Created by Elon Musk on 16/8/10.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailListModel : NSObject

@property(copy,nonatomic)  NSString *mailId;
@property(copy,nonatomic)  NSString *sendFromName;
@property(assign,nonatomic)  NSInteger sendFromId;
@property(copy,nonatomic)  NSString *subject;//主题
@property(copy,nonatomic)  NSString *sendTime;
@property(assign,nonatomic)  BOOL isRead;
@property(copy,nonatomic)  NSString *content;
@property(assign,nonatomic) BOOL selected;

//@property(assign,nonatomic)  int mailID;
//@property(copy,nonatomic)  NSString *mode;
//@property(copy,nonatomic)  NSString *addressids;
//@property(copy,nonatomic)  NSString *addressnames;
//@property(assign,nonatomic)  int *sendfromid;
//@property(assign,nonatomic)  BOOL *isdraft;


@end
