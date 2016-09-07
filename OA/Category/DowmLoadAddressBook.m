//
//  DowmLoadAddressBook.m
//  OA
//
//  Created by Elon Musk on 16/8/26.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "DowmLoadAddressBook.h"
#import "TelBookNet.h"
#import "TelBookModel.h"
#import "UsersModel.h"

@interface DowmLoadAddressBook()

@property (nonatomic,strong)  NSMutableArray *dataArray;

@end

@implementation DowmLoadAddressBook

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)downLoadAddressBook{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"telBook.archiver"];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [self.dataArray addObjectsFromArray:arr];
    if (!(self.dataArray.count >0)) {
        NSLog(@"电话本不存在");
        [self feachData];
    }
}


- (void)feachData{
    [TelBookNet excuteGetTelBookWithSuccess:^(id obj) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        [data addObjectsFromArray:obj];
        for (TelBookModel *model in data) {
            NSMutableArray *mulArray =[[NSMutableArray alloc]init];
            [mulArray addObjectsFromArray:model.users];
            NSArray *array = [NSArray arrayWithArray:mulArray];
            for (UsersModel *dic in array) {
                if ([dic.name  isEqual:@"无人员"]||[dic.name  isEqual:@"超级管理员"]) {
                    [mulArray removeObject:dic];
                }
                model.users = (NSArray *)mulArray;
            }
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"telBook.archiver"];
        
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr.count>0) {
            NSFileManager *defaultManage = [NSFileManager defaultManager];
            if ([defaultManage isDeletableFileAtPath:filePath]) {
                [defaultManage removeItemAtPath:filePath error:nil];
            }
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:self.dataArray toFile:filePath];
        if (success) {
            NSLog(@"保存成功！");
            [MBProgressHUD showText_b:@"电话本自动同步到本地成功"];
            [self creatAllUsers];
            
        }
    } failed:^(id obj) {
        [MBProgressHUD showText_b:@"电话本自动同步失败，请至电话本主动同步"];
    }];
}


- (void)creatAllUsers{
    dispatch_queue_t urls_queue = dispatch_queue_create("users", NULL);
    dispatch_async(urls_queue, ^{
        NSMutableArray *mulArr = [[NSMutableArray alloc]init];
        for (TelBookModel *model in self.dataArray) {
            for (UsersModel *userModel in model.users) {
                [mulArr addObject:userModel];
            }
        }
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"users.archiver"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr.count>0) {
            NSFileManager *defaultManage = [NSFileManager defaultManager];
            if ([defaultManage isDeletableFileAtPath:filePath]) {
                [defaultManage removeItemAtPath:filePath error:nil];
            }
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:mulArr toFile:filePath];
        if (success) {
            NSLog(@"users保存成功");
        }
    });
}

@end
