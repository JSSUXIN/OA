//
//  NoticeModel.h
//  OA
//
//  Created by Elon Musk on 16/8/3.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeNewsModel : NSObject
@property (nonatomic,copy) NSString *nid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *postdate;
@property (nonatomic,assign) BOOL hasRead;
@property (nonatomic,copy) NSArray *files;
@property (nonatomic,assign) NSString *isImageNews;
@property (nonatomic,copy) NSString *imageNewsFile;
@property (nonatomic,copy) NSString *content;

@end


@interface FileModel : NSObject
@property(copy,nonatomic)  NSString *fid;
@property(copy,nonatomic)  NSString *name;
@property(copy,nonatomic)  NSString *path;


@end