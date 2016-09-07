//
//  IndexNet.h
//  OA
//
//  Created by Elon Musk on 16/7/29.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseHandler.h"

@interface IndexNet : BaseHandler


//获取轮播图片
+(void)excuteGetPictureWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;


+(void)excuteGetNoticeWithStartPage:(NSInteger )startPage
                            endPage:(NSInteger)endpage
                            Success:(SuccessBlock)success
                             failed:(FailedBlock)failed;

+(void)excuteGetNewsWithStartPage:(NSInteger )startPage
                          endPage:(NSInteger)endpage
                          Success:(SuccessBlock)success
                           failed:(FailedBlock)failed;
@end
