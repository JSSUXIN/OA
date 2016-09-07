//
//  AddressModel.h
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AddrssLocation;

@interface AddressModel : NSObject

@property (nonatomic,copy) NSString *name;
@property(strong,nonatomic) AddrssLocation *location;
@property (nonatomic,copy) NSString *address;
@property(assign,nonatomic) BOOL selected;

@end

@interface AddrssLocation : NSObject
@property(copy,nonatomic) NSString *lat;
@property(copy,nonatomic) NSString *lng;

@end