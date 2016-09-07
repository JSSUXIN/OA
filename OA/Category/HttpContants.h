//
//  HttpContants.h
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef HttpContants_h
#define HttpContants_h

#define HTTP_CONECT(x,y) [NSString stringWithFormat:@"%@%@",x,y]
#define BASE_URL @"http://jssuxin.net:90/api/"
#define GETMAILLIST @"http://jssuxin.net:90/api/Mail/GetMailList?uid=%@&mode=%@" //获取邮件列表
#define LOGIN @"http://jssuxin.net:90/api/Login/Login?UserName=%@&Psd=%@"       //登录
#define SENDMAIL @"http://jssuxin.net:90/api/Mail/SendMail"                      //发送邮件
#define MAILDETAIL @"http://jssuxin.net:90/api/Mail/GetMail?id=%@"               //邮件详情
#define DELETEMAIL @"http://jssuxin.net:90/api/Mail/DelMail?mode=%@&mids=%@&uid=%@"     //删除邮件
#define RECOVERYMAIL @"http://jssuxin.net:90/api/Mail/Recovery?mids=%@&uid=%@"      //恢复邮件
#define SIGNIN @"http://jssuxin.net:90/api/OutAttendance/Sign"                  //外勤签到
#define MAILREAD @"http://jssuxin.net:90/api/Mail/SetMailRead?mid=%@&uid=%@"        //设置邮件已读
#define MAILFILE @"http://jssuxin.net:90/api/Mail/GetMailFile?id=%@"            //邮件文件


#define BaiduCode @"eZAikbd1OnFWGFPEBmpIizZUHvLl0bBq"
#define mcode @"net.jssuxin.oa"
#endif /* HttpContants_h */
