//
//  TelBookModel.h
//  OA
//
//  Created by Elon Musk on 16/8/1.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TelBookModel : NSObject
//@property (nonatomic,copy) NSString *deptId;
@property (nonatomic,copy) NSString *deptName;
@property (nonatomic,strong) NSArray *users;
@property (nonatomic,assign) BOOL expanded;

@property(assign,nonatomic) BOOL selected;

+(NSDictionary*)objectClassInArray;


@end
