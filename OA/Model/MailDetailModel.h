//
//  MailDetailModel.h
//  OA
//
//  Created by Elon Musk on 16/8/18.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailDetailModel : NSObject
@property(assign,nonatomic)  int mailId;
@property(copy,nonatomic)  NSString *level;
@property(copy,nonatomic)  NSString *sendFromName;
@property(assign,nonatomic)  int sendFromId;
@property(copy,nonatomic)  NSString *addresseeIds;
@property(copy,nonatomic)  NSString *subject;
@property(copy,nonatomic)  NSString *content;
@property(copy,nonatomic)  NSString *sendTime;
@property(assign,nonatomic)  BOOL isDraft;
@property(copy,nonatomic)  NSString *addresseeNames;
@property(strong,nonatomic) NSArray *mailFile;
@end


@interface fileModel :NSObject

@property(copy,nonatomic)  NSString *mid;


@end