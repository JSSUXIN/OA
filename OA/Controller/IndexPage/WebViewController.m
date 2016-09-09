//
//  WebViewController.m
//  OA
//
//  Created by Elon Musk on 16/8/8.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "WebViewController.h"
#import "AttachmentTableViewCell.h"

@interface WebViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIWebView *openFileWebView;
}

@property (nonatomic, retain)NSString *fileURLString;

@property (nonatomic,strong)NSURL *fileURL;


@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WebViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(300), mScreenWidth, RELATIVE_WIDTH(300)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =grayBackGround;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView setScalesPageToFit:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:mUrlWithString(self.urlString)];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    if (self.NoticeModel.files.count>0) {
        self.webView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(300));
        [self.view addSubview:self.tableView];
        UIButton * fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fileBtn.backgroundColor = blueBackGround;
        [fileBtn setTitle:[NSString stringWithFormat:@"附件数：%ld",self.NoticeModel.files.count] forState:UIControlStateNormal];
        fileBtn.titleLabel.font = mFont(12);
        fileBtn.frame = CGRectMake(mScreenWidth - 90, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(370), 80, RELATIVE_WIDTH(50));
        fileBtn.layer.cornerRadius = RELATIVE_WIDTH(25);
        fileBtn.layer.masksToBounds = YES;
        [fileBtn addTarget:self action:@selector(hidefileTableview:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fileBtn];
    }
}

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

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.fileURL;
}

- (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.NoticeModel.files.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileModel *model = [self.NoticeModel.files objectAtIndex:indexPath.row];
    
    static NSString *cellId = @"cellid";
    AttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AttachmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = grayBackGround;
    [cell setContenView:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_WIDTH(150);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FileModel *model = [self.NoticeModel.files objectAtIndex:indexPath.row];
    self.fileURLString= model.path;
    openFileWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    openFileWebView.delegate = self;
    [openFileWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURLString]]];

}


-(void)hidefileTableview:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected ==YES) {
        self.tableView.hidden = YES;
        sender.frame = CGRectMake(mScreenWidth - 90, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(70), 80, RELATIVE_WIDTH(50));
        self.webView.frame =CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight);
        
    }else{
        self.tableView.hidden =NO;
        sender.frame = CGRectMake(mScreenWidth - 90, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(370), 80, RELATIVE_WIDTH(50));
        self.webView.frame =CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarWithStateHeight - RELATIVE_WIDTH(300));

    }
}
@end
