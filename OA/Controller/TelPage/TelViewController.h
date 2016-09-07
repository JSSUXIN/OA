//
//  TelViewController.h
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"

@protocol TelViewControllerDelegate <NSObject>

- (void)choosePersonWith:(NSArray *)personArray;

@end

@interface TelViewController : BaseViewController

@property (nonatomic,assign) BOOL isMailType;

@property (nonatomic,strong) NSArray *contactArray;

@property(assign,nonatomic) id<TelViewControllerDelegate> delegate;


@end
