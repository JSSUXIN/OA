//
//  LoginModel.m
//  OA
//
//  Created by Elon Musk on 16/8/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

+(LoginModel *)parseLoginWithDic:(NSDictionary *)dic{
    LoginModel *model = [[LoginModel alloc]init];
    model.uid = [NSString isNull:dic[@"id"]];
    model.name = [NSString isNull:dic[@"name"]];
    model.realName = [NSString isNull:dic[@"realName"]];
    model.sex = [NSString isNull:dic[@"sex"]];
    model.birthday = [NSString isNull:dic[@"birthday"]];
    model.mail = [NSString isNull:dic[@"mail"]];
    model.mobile = [NSString isNull:dic[@"mobile"]];
    model.tel = [NSString isNull:dic[@"tel"]];
    model.qq = [NSString isNull:dic[@"qq"]];
    model.ipAddress = [NSString isNull:dic[@"ipAddress"]];
    model.imageUrl = [NSString isNull:dic[@"imageUrl"]];
    return model;
}

MJCodingImplementation

@end
