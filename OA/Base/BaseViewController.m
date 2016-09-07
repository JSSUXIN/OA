//
//  BaseViewController.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

//@property (nonatomic,strong) UIView *returnView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self inintWithGoBack];
}

- (void)loadView{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}




-(void)inintWithGoBack{
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 7, 80, 30);
    [returnBtn setImage:mImageByName(@"ic_back") forState:UIControlStateNormal];
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 70)];
    [returnBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *btnItem= [[UIBarButtonItem alloc]initWithCustomView:returnBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:self action:@selector(back)];
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btnItem, nil];
}


- (void)setRightItemFont:(NSInteger )font{
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil] forState:UIControlStateNormal];
}





-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
