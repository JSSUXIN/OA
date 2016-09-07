//
//  MailFileModel.h
//  OA
//
//  Created by Elon Musk on 16/9/1.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailFileModel : NSObject

@property(copy,nonatomic)  NSString *fileId;
@property(copy,nonatomic)  NSString *mid;
@property(copy,nonatomic)  NSString *fileModel;
@property(copy,nonatomic)  NSString *fileGUID;
@property(copy,nonatomic)  NSString *fileName;
@property(copy,nonatomic)  NSString *fileSize;
@property(copy,nonatomic)  NSString *fileExt;
@property(copy,nonatomic)  NSString *createDate;
@property(copy,nonatomic)  NSString *createUser;

@end
