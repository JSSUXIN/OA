//
//  UsersModel.h
//  OA
//
//  Created by Elon Musk on 16/8/1.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersModel : NSObject
@property (nonatomic,copy) NSString *postName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL selected;

@end
