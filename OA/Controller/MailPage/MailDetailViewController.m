//
//  WriteNewMailViewController.m
//  OA
//
//  Created by Elon Musk on 16/8/11.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MailDetailViewController.h"
#import "ElonHTTPSession.h"
#import "TelViewController.h"
#import "UsersModel.h"
#import "ParseModelToAddressBook.h"
#import "MailFileModel.h"
#import "AttachmentTableViewCell.h"
#import "BRPlaceholderTextView.h"




@interface MailDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TelViewControllerDelegate,UIWebViewDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>{
}

//@property (nonatomic,strong) UITableView *tableview;

@property(nonatomic ,copy) NSString *fileURLString;

@property (nonatomic,strong) UIButton *bottomButton;

@property (nonatomic,strong) BRPlaceholderTextView *textview;

@property (nonatomic,strong) BRPlaceholderTextView *lastTextView;

@property (nonatomic,strong) UITableView *fileTableview;

@property (nonatomic,strong) NSMutableArray *mailFileArray;

@property (nonatomic,strong)NSURL *fileURL;


@end

@implementation MailDetailViewController{
    UILabel *_textLabel;
    UILabel *_IndexLabel;
    UIButton *_clearButton;
    UIButton *_addButton;
    UILabel *_themeLabel;
    UILabel *_theme;
    UILabel *_sendFromLabel;
    UILabel *_sendDetailLabel;
    UILabel *_sendTimeLabel;
    UIView *_lineview;
    UILabel *_sendTimeDetailLabel;
    UITextField *_themeField;
    UIWebView *openFileWebView;
    UIView *_downView;

}

//- (UITableView *)tableview{
//    if (!_tableview) {
//        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(90)) style:UITableViewStyleGrouped];
//        _tableview.delegate = self;
//        _tableview.dataSource = self;
//        _tableview.scrollEnabled = YES;
//        _tableview.bounces = NO;
//        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    return _tableview;
//}

- (UITableView *)fileTableview{
    if (!_fileTableview) {
        _fileTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, mScreenHeight - RELATIVE_WIDTH(300) - mNavBarWithStateHeight - RELATIVE_WIDTH(90), mScreenWidth, RELATIVE_WIDTH(300)) style:UITableViewStylePlain];
        _fileTableview.delegate = self;
        _fileTableview.dataSource = self;
        _fileTableview.scrollEnabled = YES;
        _fileTableview.backgroundColor = grayBackGround;
        _fileTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _fileTableview;
}


- (NSMutableArray *)mailFileArray{
    if (!_mailFileArray) {
        _mailFileArray = [NSMutableArray array];
    }
    return _mailFileArray;
}

-(NSArray *)sendArray{ //存放userModel
    if (!_sendArray) {
        _sendArray = [[NSMutableArray alloc]init];
    }
   return _sendArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitle];
    [self setNavigaitonItem];
    [self creatUI];
    [self feachData];
//    [self.view addSubview:self.tableview];
    self.bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, mScreenHeight -mNavBarWithStateHeight- RELATIVE_WIDTH(90), mScreenWidth, RELATIVE_WIDTH(90))];
    [_bottomButton setBackgroundColor:redBack];
    [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomButton addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomButton];
    [self setBottomButton];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view from its nib.
}
#pragma mark 收缩键盘
//-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}
- (void)settitle{
    switch (self.mailType) {
        case WriteMail:
            self.title = @"写邮件";
            break;
        case OutboxMail:
            self.title = @"发件箱";
            break;
            
        case InboxMail:
            self.title = @"收件箱";
            break;
            
        case DraftboxMail:
            self.title = @"草稿箱";
            break;
        case DusbinboxMail:
            self.title = @"垃圾箱";
            break;
        case EditMail:
            self.title = @"编辑";

            break;
        case ReturnMail:
            self.title = @"回复";
            break;
        case Transpond:
            self.title = @"转发";
            break;
        default:
            break;
    }
}


- (void)setNavigaitonItem{
    switch (self.mailType) {
        case WriteMail:
        case EditMail:
        case ReturnMail:
        case Transpond:{
           UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithTitle:@"保存到草稿箱" style:UIBarButtonItemStylePlain target:self action:@selector(saveMail)];
            [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightItem;

        }
            break;
        case OutboxMail:
        case InboxMail:
        case DraftboxMail:
        case DusbinboxMail:{
           UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(transpond)];
            [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
        default:
            break;
    }
}

- (void)setBottomButton{
    switch (self.mailType) {
        case WriteMail:
        case EditMail:
        case ReturnMail:
        case Transpond:
            [self.bottomButton setTitle:@"直接发送" forState:UIControlStateNormal];
            break;
        case OutboxMail:
        case DusbinboxMail:
            self.bottomButton.hidden = YES;
            break;
        case InboxMail:
            [self.bottomButton setTitle:@"回复" forState:UIControlStateNormal];
            break;
        case DraftboxMail:
            [self.bottomButton setTitle:@"编辑" forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}


- (void)creatUI{
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, RELATIVE_WIDTH(180))];
    [self.view addSubview:upView];
    UIView *bankView = [[UIView alloc]initWithFrame:CGRectMake(0, GG_BOTTOM_Y(upView), mScreenWidth, RELATIVE_WIDTH(30))];
    bankView.backgroundColor = grayBackGround;
    [self.view addSubview:bankView];
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(210), mScreenWidth, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(300))];
    [self.view addSubview:_downView];

    switch (self.mailType) {
        case WriteMail:
        case EditMail:
        case ReturnMail:
        case Transpond:{
            if (!_IndexLabel){
                _IndexLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, 60, RELATIVE_WIDTH(35))];
                _IndexLabel.text = @"收件人:";
                _IndexLabel.font = [UIFont systemFontOfSize:15];
                _IndexLabel.textAlignment = NSTextAlignmentLeft;
                _IndexLabel.center = CGPointMake(_IndexLabel.center.x, RELATIVE_WIDTH(45));
                [upView addSubview:_IndexLabel];
            }
            if (!_textLabel) {
                _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_IndexLabel), 0, mScreenWidth - RELATIVE_WIDTH(370), RELATIVE_WIDTH(35))];
                _textLabel.center = CGPointMake(_textLabel.center.x, RELATIVE_WIDTH(45));
                _textLabel.font = [UIFont systemFontOfSize:15];
                _textLabel.textAlignment = NSTextAlignmentLeft;
                [upView addSubview:_textLabel];
            }
            if (!_lineview) {
                _lineview = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(88), mScreenWidth, 0.5)];
                _lineview.backgroundColor = halvingLineColor;
                [upView addSubview:_lineview];
            }
            
            if (self.mailType !=ReturnMail) {
                if (!_clearButton) {
                    _clearButton = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(190), 0, RELATIVE_WIDTH(100), RELATIVE_WIDTH(40))];
                    _clearButton.layer.masksToBounds =YES;
                    _clearButton.layer.cornerRadius = RELATIVE_WIDTH(20);
                    [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
                    _clearButton.titleLabel.font = [UIFont systemFontOfSize:12];
                    [_clearButton setBackgroundColor:redBack];
                    [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _clearButton.center = CGPointMake(_clearButton.center.x, RELATIVE_WIDTH(45));
                    [_clearButton addTarget:self action:@selector(clearArray) forControlEvents:UIControlEventTouchUpInside];
                    [upView addSubview:_clearButton];
                }
                if (!_addButton) {
                    _addButton = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(90), 0, RELATIVE_WIDTH(90), RELATIVE_WIDTH(90))];
                    _addButton.center = CGPointMake(_addButton.center.x, RELATIVE_WIDTH(45));
                    [_addButton setImage:mImageByName(@"ic_mailAdd") forState:UIControlStateNormal];
                    [_addButton addTarget:self action:@selector(chooseRecipient) forControlEvents:UIControlEventTouchUpInside];
                    [upView addSubview:_addButton];
                }
            }
          if (!_themeLabel) {
                _themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(90), 40, RELATIVE_WIDTH(35))];
                _themeLabel.text = @"主题:";
                _themeLabel.font = [UIFont systemFontOfSize:15];
                _themeLabel.textAlignment = NSTextAlignmentLeft;
                _themeLabel.center = CGPointMake(_themeLabel.center.x, RELATIVE_WIDTH(135));
                [upView addSubview:_themeLabel];
            }
            if (!_themeField) {
                _themeField = [[UITextField alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_themeLabel), 0, mScreenWidth - RELATIVE_WIDTH(150), RELATIVE_WIDTH(35))];
                _themeField.font = [UIFont systemFontOfSize:15];
                
                _themeField.center = CGPointMake(_themeField.center.x, RELATIVE_WIDTH(135));
                [upView addSubview:_themeField];
            }
            if (!self.textview) {
                self.textview = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth - 2*RELATIVE_WIDTH(20), mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270) - 30)];
                self.textview.font = [UIFont systemFontOfSize:15];
                self.textview.placeholder = @"输入内容";
                [self.textview setPlaceholderFont:[UIFont systemFontOfSize:15]];
                [_downView addSubview:_textview];
            }
            CGFloat height = (mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(300))/2;
            if (!self.lastTextView) {
                self.lastTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), height, mScreenHeight- 2*RELATIVE_WIDTH(20), height)];
                [_downView addSubview:_lastTextView];
            }
            _lastTextView.hidden = YES;
            _lastTextView.editable = NO;
        }
            break;
        case OutboxMail:
        case InboxMail:
        case DraftboxMail:
        case DusbinboxMail:{
            if (!_theme) {
                _theme = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth, RELATIVE_WIDTH(90))];
                _theme.textColor = [UIColor blackColor];
                [upView addSubview:_theme];
            }
            _theme.text = self.mailModel.subject;
            
            if (!_sendFromLabel) {
                _sendFromLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), GG_BOTTOM_Y(_theme), RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                _sendFromLabel.font = [UIFont systemFontOfSize:12];
                _sendFromLabel.text = @"发件人:";
                _sendFromLabel.center = CGPointMake(_sendFromLabel.center.x, RELATIVE_WIDTH(112));
                _sendFromLabel.textColor = grayTextcolor;
                [upView addSubview:_sendFromLabel];
            }
            if (!_sendDetailLabel) {
                _sendDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_sendFromLabel), GG_Y(_sendFromLabel), mScreenWidth - RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                _sendDetailLabel.font = [UIFont systemFontOfSize:12];
                _sendDetailLabel.center = CGPointMake(_sendDetailLabel.center.x, RELATIVE_WIDTH(112));
                _sendDetailLabel.textColor = grayTextcolor;
                [upView addSubview:_sendDetailLabel];
            }
            if (!_sendTimeLabel) {
                _sendTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), GG_BOTTOM_Y(_sendFromLabel), RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                _sendTimeLabel.font =  [UIFont systemFontOfSize:12];
                _sendTimeLabel.center = CGPointMake(_sendTimeLabel.center.x, RELATIVE_WIDTH(157));
                
                _sendTimeLabel.text = @"时间:";
                _sendTimeLabel.textColor = grayTextcolor;
                [upView addSubview:_sendTimeLabel];
            }
            if (!_sendTimeDetailLabel) {
                _sendTimeDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_sendTimeLabel), GG_Y(_sendTimeLabel), mScreenWidth - RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                _sendTimeDetailLabel.font =  [UIFont systemFontOfSize:12];
                _sendTimeDetailLabel.center = CGPointMake(_sendTimeDetailLabel.center.x, RELATIVE_WIDTH(157));
            }
            _sendTimeDetailLabel.textColor = grayTextcolor;
            [upView addSubview:_sendTimeDetailLabel];
            
            if (!self.textview) {
                self.textview = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth- 2*RELATIVE_WIDTH(20), mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270) - 10)];
                _textview.editable = NO;
                [_downView addSubview:_textview];
            }

            
        }
            break;
        default:
            break;
    }
}

#pragma mark tableviewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.fileTableview) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.fileTableview) {
        return self.mailFileArray.count;
    }else{
    
    switch (self.mailType) {
        case WriteMail:
        case ReturnMail:
        case EditMail:
        case Transpond:
        {
            if (section ==0) {
                return 2;
            }
            else{
                return 1;
            }
        }
            break;
        case InboxMail:
        case OutboxMail:
        case DraftboxMail:
        case DusbinboxMail:
        {
            return 1;
        }
            break;
        default:
            return 0;
            break;
    }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.fileTableview) {
        return RELATIVE_WIDTH(150);
    }else{
    switch (self.mailType) {
        case WriteMail:
        case ReturnMail:
        case EditMail:
        case Transpond:
        {
            if (indexPath.section ==0) {
                return RELATIVE_WIDTH(90);
            }else{
                return mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270) - 15;
            }
        }
            break;
        case InboxMail:
        case OutboxMail:
        case DraftboxMail:
        case DusbinboxMail:
            {
                if (indexPath.section ==0) {
                    return RELATIVE_WIDTH(180);
                }else{
                    return mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270) - 15;
                }
            }
            break;
        default:
            return 0;
            break;
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.fileTableview) {
        return 0.01;
    }else{
        if (section == 1) {
            return 15;
        }else{
            return 0.01;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.fileTableview) {
        MailFileModel *model = [self.mailFileArray objectAtIndex:indexPath.row];
        static NSString *reuseIdentifiercell = @"cell";
        AttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiercell];
        if (!cell) {
            cell = [[AttachmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifiercell];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCOntent:model];
        return cell;
    }else{
    static NSString *reuseIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
                }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (self.mailType) {
            case WriteMail:
            case ReturnMail:
            case EditMail:
            case Transpond:
            {
                if (indexPath.section ==0){
                    if (indexPath.row ==0)  {
                        if (!_IndexLabel){
                            _IndexLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, 60, RELATIVE_WIDTH(35))];
                            _IndexLabel.text = @"收件人:";
                            _IndexLabel.font = [UIFont systemFontOfSize:15];
                            _IndexLabel.textAlignment = NSTextAlignmentLeft;
                            _IndexLabel.center = CGPointMake(_IndexLabel.center.x, RELATIVE_WIDTH(45));
                            [cell.contentView addSubview:_IndexLabel];
                        }
                        if (!_textLabel) {
                            _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_IndexLabel), 0, mScreenWidth - RELATIVE_WIDTH(370), RELATIVE_WIDTH(35))];
                            _textLabel.center = CGPointMake(_textLabel.center.x, RELATIVE_WIDTH(45));
                            _textLabel.font = [UIFont systemFontOfSize:15];
                            _textLabel.textAlignment = NSTextAlignmentLeft;
                            [cell.contentView addSubview:_textLabel];
                        }
                        if (!_lineview) {
                            _lineview = [[UIView alloc]initWithFrame:CGRectMake(0, RELATIVE_WIDTH(88), mScreenWidth, 0.5)];
                            _lineview.backgroundColor = halvingLineColor;
                            [cell.contentView addSubview:_lineview];
                        }
                        
                        NSMutableArray *mul = [NSMutableArray array];
                        if (self.sendArray.count >0) {
                            for (UsersModel *model in self.sendArray) {
                                [mul addObject:model.name];
                            }
                            _textLabel.text = [mul componentsJoinedByString:@","];
                        }else{
                            _textLabel.text = @"";
                        }
                        if (self.mailType !=ReturnMail) {
                            if (!_clearButton) {
                                _clearButton = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(190), 0, RELATIVE_WIDTH(100), RELATIVE_WIDTH(40))];
                                _clearButton.layer.masksToBounds =YES;
                                _clearButton.layer.cornerRadius = RELATIVE_WIDTH(20);
                                [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
                                _clearButton.titleLabel.font = [UIFont systemFontOfSize:12];
                                [_clearButton setBackgroundColor:redBack];
                                [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                _clearButton.center = CGPointMake(_clearButton.center.x, RELATIVE_WIDTH(45));
                                [_clearButton addTarget:self action:@selector(clearArray) forControlEvents:UIControlEventTouchUpInside];
                                [cell.contentView addSubview:_clearButton];
                            }
                            if (!_addButton) {
                                _addButton = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - RELATIVE_WIDTH(90), 0, RELATIVE_WIDTH(90), RELATIVE_WIDTH(90))];
                                _addButton.center = CGPointMake(_addButton.center.x, RELATIVE_WIDTH(45));
                                [_addButton setImage:mImageByName(@"ic_mailAdd@3x.png") forState:UIControlStateNormal];
                                [_addButton addTarget:self action:@selector(chooseRecipient) forControlEvents:UIControlEventTouchUpInside];
                                [cell.contentView addSubview:_addButton];
                            }
                        }
                    }else if (indexPath.row ==1){
                        if (!_themeLabel) {
                            _themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, 40, RELATIVE_WIDTH(35))];
                            _themeLabel.text = @"主题:";
                            _themeLabel.font = [UIFont systemFontOfSize:15];
                            _themeLabel.textAlignment = NSTextAlignmentLeft;
                            _themeLabel.center = CGPointMake(_themeLabel.center.x, RELATIVE_WIDTH(45));
                            [cell.contentView addSubview:_themeLabel];
                        }
//                        if (!self.themeField) {
//                            self.themeField = [[UITextField alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_themeLabel), 0, mScreenWidth - RELATIVE_WIDTH(150), RELATIVE_WIDTH(35))];
//                            _themeField.font = [UIFont systemFontOfSize:15];
//
//                            _themeField.center = CGPointMake(_themeField.center.x, RELATIVE_WIDTH(47));
//                            [cell.contentView addSubview:_themeField];
//                        }
                        if (self.mailType ==ReturnMail) {
                            _themeField.text = [NSString stringWithFormat:@"Re:%@",self.mailModel.subject];
                        }else{
                            _themeField.text = self.mailModel.subject;
                        }
                    }
                }else if (indexPath.section ==1){
                    if (!self.textview) {
                    self.textview = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth - 2*RELATIVE_WIDTH(20), mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270) - 30)];
                    [cell.contentView addSubview:_textview];
                    }
                    self.textview.font = [UIFont systemFontOfSize:15];
                    self.textview.placeholder = @"输入内容";
                    self.textview.backgroundColor = [UIColor yellowColor];
                    [self.textview setPlaceholderFont:[UIFont systemFontOfSize:15]];
                    CGFloat height = (mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270)-15)/2;
                    if (!self.lastTextView) {
                    self.lastTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), height, mScreenHeight- 2*RELATIVE_WIDTH(20), height)];
                    [cell.contentView addSubview:_lastTextView];
                    }
                    _lastTextView.hidden = YES;
                    _lastTextView.editable = NO;
                                }
            }
                break;
            case InboxMail:
            case OutboxMail:
            case DraftboxMail:
            case DusbinboxMail:
            {
                if (indexPath.section ==0) {
                    if (!_theme) {
                    _theme = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth, RELATIVE_WIDTH(90))];
                    _theme.textColor = [UIColor blackColor];
                    [cell.contentView addSubview:_theme];
                    }
                    _theme.text = self.mailModel.subject;

                    if (!_sendFromLabel) {
                    _sendFromLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), GG_BOTTOM_Y(_theme), RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                    _sendFromLabel.font = [UIFont systemFontOfSize:12];
                    _sendFromLabel.text = @"发件人:";
                    _sendFromLabel.center = CGPointMake(_sendFromLabel.center.x, RELATIVE_WIDTH(112));
                    _sendFromLabel.textColor = grayTextcolor;
                    [cell.contentView addSubview:_sendFromLabel];
                    }
                    if (!_sendDetailLabel) {
                        _sendDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_sendFromLabel), GG_Y(_sendFromLabel), mScreenWidth - RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                        _sendDetailLabel.font = [UIFont systemFontOfSize:12];
                        _sendDetailLabel.center = CGPointMake(_sendDetailLabel.center.x, RELATIVE_WIDTH(112));
                        _sendDetailLabel.textColor = grayTextcolor;
                        [cell.contentView addSubview:_sendDetailLabel];
                    }
                    _sendDetailLabel.text = self.mailModel.sendFromName;
                    if (!_sendTimeLabel) {
                        _sendTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), GG_BOTTOM_Y(_sendFromLabel), RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                        _sendTimeLabel.font =  [UIFont systemFontOfSize:12];
                        _sendTimeLabel.center = CGPointMake(_sendTimeLabel.center.x, RELATIVE_WIDTH(157));
                        
                        _sendTimeLabel.text = @"时间:";
                        _sendTimeLabel.textColor = grayTextcolor;
                        [cell.contentView addSubview:_sendTimeLabel];
                    }
                    if (!_sendTimeDetailLabel) {
                        _sendTimeDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_sendTimeLabel), GG_Y(_sendTimeLabel), mScreenWidth - RELATIVE_WIDTH(100), RELATIVE_WIDTH(25))];
                        _sendTimeDetailLabel.font =  [UIFont systemFontOfSize:12];
                        _sendTimeDetailLabel.center = CGPointMake(_sendTimeDetailLabel.center.x, RELATIVE_WIDTH(157));
                    }
                    if (self.mailModel.sendTime) {
                        _sendTimeDetailLabel.text = [NSString parseTime:self.mailModel.sendTime];
                    }
                    _sendTimeDetailLabel.textColor = grayTextcolor;
                    [cell.contentView addSubview:_sendTimeDetailLabel];
                }else{
                    if (!self.textview) {
                        self.textview = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth- 2*RELATIVE_WIDTH(20), mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270) - 10)];
                        _textview.editable = NO;
                        [cell.contentView addSubview:_textview];
                    }
                    self.textview.text = self.mailModel.content;
                }
            }
                break;
            default:
                return 0;
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==self.fileTableview) {
        MailFileModel *filemodel = [self.mailFileArray objectAtIndex:indexPath.row];
        self.fileURLString = [NSString stringWithFormat:@"http://jssuxin.net:90/FilesUpload/Web_FileCenter/%@%@",filemodel.fileGUID,filemodel.fileExt];
        openFileWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        openFileWebView.delegate = self;
        [openFileWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURLString]]];
    }
}

#pragma webviewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView.isLoading) {
        return;
    }
    NSURL *targetURL = [NSURL URLWithString:self.fileURLString];
    NSString *docPath = [self documentsDirectoryPath];
    NSString *pathToDownloadTo = [NSString stringWithFormat:@"%@/%@", docPath, [targetURL lastPathComponent]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL hasDownLoad= [fileManager fileExistsAtPath:pathToDownloadTo];
    
    NSLog( @"%d",hasDownLoad);
    if (hasDownLoad) {
        self.fileURL = [NSURL fileURLWithPath:pathToDownloadTo];
        QLPreviewController *qlVC = [[QLPreviewController alloc]init];
        qlVC.delegate = self;
        qlVC.dataSource = self;
        [self.navigationController pushViewController:qlVC animated:YES];
    }else{
        NSData *fileData = [[NSData alloc] initWithContentsOfURL:targetURL];
        // Get the path to the App's Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        [fileData writeToFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, [targetURL lastPathComponent]] atomically:YES];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [openFileWebView loadRequest:request];
    }
}

- (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}
#pragma mark previewDelegate

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}


#pragma mark Click点击事件

- (void)chooseRecipient{
    //加载电话本界面
    TelViewController *chooseController = [[TelViewController alloc]init];
    chooseController.contactArray = self.sendArray;
    chooseController.delegate = self;
    chooseController.isMailType  = YES;
    [self.navigationController pushViewController:chooseController animated:YES];
}

- (void)clearArray{
    NSLog(@"点击了清空");
    [self.sendArray removeAllObjects];
//    [self.tableview reloadData];
}

- (void)saveMail{
    NSLog(@"保存到草稿箱");
    if ([self canSendMail]) {
    NSMutableArray *uidArray = [NSMutableArray array];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (UsersModel *model in self.sendArray) {
        [uidArray addObject:model.userId];
        [nameArray addObject:model.name];
    }
    NSDictionary*params = @{
                            @"mailID": self.mailId == nil?@"0":self.mailId,
                            @"mode": @"draftBox",
                            @"content": self.textview.text,
                            @"subject": _themeField.text,
                            @"addressids": [uidArray componentsJoinedByString:@","],
                            @"addressnames": [nameArray componentsJoinedByString:@","],
                            @"sendfromname": [AccountManager sharedManager].userName,
                            @"sendfromid": [AccountManager sharedManager].uid,
                            @"isdraft": @YES
                            };
    NSLog(@"%@",params);
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypePost urlString:SENDMAIL paraments:params completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"%@",object);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    }else{
        return;
    }
}

- (void)transpond{
    NSLog(@"转发");
    MailDetailViewController *mailDetail = [[MailDetailViewController alloc]init];
    mailDetail.mailType = Transpond;
    mailDetail.mailModel = self.mailModel;
    [self.navigationController pushViewController:mailDetail animated:YES];
}

- (void)bottomBtnClick{
    switch (self.mailType) {
        case WriteMail://写邮件界面
        case EditMail://编辑界面
        case ReturnMail://回复界面
        case Transpond://转发界面
        {
    NSString *mode = @"";
    if (self.mailType == WriteMail) {
        mode = @"inbox";
    }else if (self.mailType ==EditMail){
        mode = @"";
    }else if (self.mailType ==ReturnMail){
        mode =@"feedback";
    }else if (self.mailType == Transpond){
        mode = @"turnpost";
    }
    NSLog(@"发送邮件");
    NSMutableArray *uidArray = [NSMutableArray array];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (UsersModel *model in self.sendArray) {
        [uidArray addObject:model.userId];
        [nameArray addObject:model.name];
    }
    NSDictionary*params = @{
                            @"mailID": self.mailId == nil?@"0":self.mailId,
                            @"mode": mode,
                            @"content": [NSString stringWithFormat:@"%@\n%@",self.textview.text,self.lastTextView.text],
                            @"subject": _themeField.text,
                            @"addressids": [uidArray componentsJoinedByString:@","],
                            @"addressnames": [nameArray componentsJoinedByString:@","],
                            @"sendfromname": [AccountManager sharedManager].userName,
                            @"sendfromid": [AccountManager sharedManager].uid,
                            @"isdraft": @NO
                            };
    NSLog(@"%@",params);
            
            if ([self canSendMail]) {
                [ElonHTTPSession requestWithRequestType:HTTPSRequestTypePost urlString:SENDMAIL paraments:params completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                    NSLog(@"%@",object);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }else{
                return;
            }
        }
            break;
        case InboxMail:{
            NSLog(@"点击回复");
            UsersModel *userModel = [ParseModelToAddressBook searchAddressModelWithUserId:[NSString stringWithFormat:@"%d",self.mailModel.sendFromId]];
            if (!userModel.userId) {
                [MBProgressHUD showText_b:@"该用户现在不存在"];
            }else{
            MailDetailViewController *returnViewController = [[MailDetailViewController alloc]init];
            returnViewController.mailType = ReturnMail;
            [returnViewController.sendArray addObject:userModel];
            returnViewController.mailModel = self.mailModel;
            returnViewController.mailId = self.mailId;
            [self.navigationController pushViewController:returnViewController animated:YES];
            }
        }
            break;
            
        case DraftboxMail:{
            NSLog(@"编辑邮件");
            MailDetailViewController *editMailViewController = [[MailDetailViewController alloc]init];
            editMailViewController.mailType = EditMail;
            editMailViewController.mailModel = self.mailModel;
            editMailViewController.mailId = self.mailId;
            NSArray *uidArray = [self.mailModel.addresseeIds componentsSeparatedByString:@","];
            NSMutableArray *mul = [[NSMutableArray alloc]init];
            for (NSInteger i = 0; i<uidArray.count; i++) {
                UsersModel *userModel = [ParseModelToAddressBook searchAddressModelWithUserId:[NSString stringWithFormat:@"%@",uidArray[i]]];
                [mul addObject:userModel];
            }
            [editMailViewController.sendArray addObjectsFromArray:mul];
            [self.navigationController pushViewController:editMailViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark 获取数据

-(void) feachData{
    switch (self.mailType) {
        case WriteMail:
            self.title = @"写邮件";
            break;
        case OutboxMail:
        case InboxMail:
        case DraftboxMail:
        case DusbinboxMail:{
            [self getMailFile];
            NSString *urlStr = [NSString stringWithFormat:MAILDETAIL,self.mailId];
            [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:urlStr paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                NSLog(@"%@,%@",object,error);
                [MailDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"mailId":@"id",
                             @"level":@"level",
                             @"sendFromName":@"sendFromName",
                             @"sendFromId":@"sendFromId",
                             @"addresseeIds":@"addresseeIds",
                             @"subject":@"subject",
                             @"content":@"content",
                             @"sendTime":@"sendTime",
                             @"isDraft":@"isDraft",
                             @"addresseeNames":@"addresseeNames",
                             @"mailFile":@"mailFile"};
                }];
                self.mailModel = [MailDetailModel mj_objectWithKeyValues:object];
                [self updateViewContents];
                
            }];
            [self setMailRead];
        }
            break;
        case EditMail:
        case Transpond:
        case ReturnMail:
            [self updateViewContents];
            break;
        default:
            break;
    }

}


- (void)updateViewContents{
    NSMutableArray *mul = [NSMutableArray array];
    if (self.sendArray.count >0) {
        for (UsersModel *model in self.sendArray) {
            [mul addObject:model.name];
        }
        _textLabel.text = [mul componentsJoinedByString:@","];
    }else{
        _textLabel.text = @"";
    }
    
    if (self.mailType ==ReturnMail) {
        _themeField.text = [NSString stringWithFormat:@"Re:%@",self.mailModel.subject];
    }else{
        _themeField.text = self.mailModel.subject;
    }
    _theme.text = self.mailModel.subject;
    _sendDetailLabel.text = self.mailModel.sendFromName;
    if (self.mailModel.sendTime) {
        _sendTimeDetailLabel.text = [NSString parseTime:self.mailModel.sendTime];
    }
    self.textview.text = self.mailModel.content;
    CGFloat height = (mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(270)-15)/2;
    if (self.mailType ==ReturnMail) {
        self.textview.frame =CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth - 2*RELATIVE_WIDTH(20), height);
        self.lastTextView.hidden = NO;
        _lastTextView.text = [NSString stringWithFormat:@"------------------------------------------\n%@",self.mailModel.content];
    }else if (self.mailType ==EditMail){
        _textview.text = self.mailModel.content;
    }else if (self.mailType ==Transpond){
        _textview.frame =CGRectMake(RELATIVE_WIDTH(20), 0, mScreenWidth -2*RELATIVE_WIDTH(20), height);
        _lastTextView.hidden = NO;
        _lastTextView.text = [NSString stringWithFormat:@"--------------------原始信息------------------\n发件人：%@\n收件人：%@\n时 间：%@\n\n%@",self.mailModel.sendFromName,self.mailModel.addresseeNames,[NSString parseTime:self.mailModel.sendTime],self.mailModel.content];
    }

}


- (void)setMailRead{
    NSString *urlStr = [NSString stringWithFormat:MAILREAD,self.mailId,[AccountManager sharedManager].uid];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:urlStr paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"object = %@,error = %@",object,error);
    }];
}

- (void)getMailFile{
    NSString *urlStr = [NSString stringWithFormat:MAILFILE,self.mailId];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:urlStr paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"object = %@,error = %@",object,error);
        [MailFileModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"fileId":@"id",
                     @"fileModel": @"fileModel",
                     @"mid": @"mid",
                     @"fileGUID": @"fileGUID",
                     @"fileName": @"fileName",
                     @"fileSize": @"fileSize",
                     @"fileExt": @"fileExt",
                     @"createDate": @"createDate",
                     @"createUser": @"createUser"};
        }];
        self.mailFileArray  = [MailFileModel mj_objectArrayWithKeyValuesArray:object];
        if (self.mailFileArray.count >0) {
            self.textview.frame = CGRectMake(0,0,mScreenWidth ,mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(390));
////            self.tableview.frame =  ;
//            [self.view addSubview:self.fileTableview];
//        }else{
//            self.tableview.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(90));
        }

//        [self.fileTableview reloadData];
    }];
}


- (BOOL)canSendMail{
    if (!(self.sendArray.count>0)) {
        [MBProgressHUD showText_b:@"请添加收件人"];
        return NO;
    }else if ([_themeField.text isEqualToString:@""]){
        [MBProgressHUD showText_b:@"请填写主题"];
        return NO;
    }else if ([self.textview.text isEqualToString:@""]){
        [MBProgressHUD showText_b:@"请填写正文"];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark TelViewControllerDelegate

- (void)choosePersonWith:(NSArray *)personArray{
    NSLog(@"personArray = %@",personArray);
    [self.sendArray removeAllObjects];
    [self.sendArray addObjectsFromArray:personArray];
//    [self.tableview reloadData];
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
