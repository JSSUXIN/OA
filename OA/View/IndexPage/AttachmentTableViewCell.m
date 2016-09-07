//
//  AttachmentTableViewCell.m
//  OA
//
//  Created by Elon Musk on 16/8/26.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "AttachmentTableViewCell.h"

@implementation AttachmentTableViewCell{

    UIButton *_willReadBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}


- (void)initView{
    self.styleImage = [[UIImageView alloc]initWithFrame:CGRectMake(RELATIVE_WIDTH(20), RELATIVE_WIDTH(20), RELATIVE_WIDTH(110), RELATIVE_WIDTH(110))];
    self.styleImage.center = CGPointMake(self.styleImage.center.x, RELATIVE_WIDTH(75));
    [self.contentView addSubview:_styleImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_styleImage)+RELATIVE_WIDTH(20), 0, mScreenWidth - RELATIVE_WIDTH(100), RELATIVE_WIDTH(50))];
    _nameLabel.center = CGPointMake(_nameLabel.center.x, RELATIVE_WIDTH(37));
    _nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameLabel];
    
    _willReadBtn = [[UIButton alloc]initWithFrame:CGRectMake(GG_RIGHT_X(_styleImage)+RELATIVE_WIDTH(20), GG_BOTTOM_Y(_nameLabel), RELATIVE_WIDTH(100), RELATIVE_WIDTH(40))];
    _willReadBtn.center = CGPointMake(_willReadBtn.center.x, RELATIVE_WIDTH(102));
    [_willReadBtn setTitle:@"预览" forState:UIControlStateNormal];
    _willReadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _willReadBtn.layer.borderColor = [UIColor redColor].CGColor;
    [_willReadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _willReadBtn.layer.borderWidth = 0.5;
    _willReadBtn.layer.masksToBounds = YES;
    _willReadBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_willReadBtn];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 0.5)];
    lineview.backgroundColor = halvingLineColor;
    [self.contentView addSubview:lineview];
    
}



- (void)setContenView:(FileModel *)model{
    self.nameLabel.text = model.name;
    NSArray *textArray = [model.path componentsSeparatedByString:@"."];
    if ([[textArray lastObject] isEqualToString:@"pdf"]) {
        self.styleImage.image = mImageByName(@"ic_default_pdf");
    }else if ([[textArray lastObject] isEqualToString:@"docx"]||[[textArray lastObject] isEqualToString:@"doc"]){
        self.styleImage.image = mImageByName(@"ic_default_doc");
    }else if ([[textArray lastObject] isEqualToString:@"xlsx"]||[[textArray lastObject] isEqualToString:@"xls"]){
        self.styleImage.image = mImageByName(@"ic_default_xls");
    }else{
        self.styleImage.image = mImageByName(@"");
    }
    
    
}


- (void)setCOntent:(MailFileModel *)model{
    NSArray *textArray = [model.fileExt componentsSeparatedByString:@"."];
    if ([[textArray lastObject] isEqualToString:@"pdf"]) {
        self.styleImage.image = mImageByName(@"ic_default_pdf");
    }else if ([[textArray lastObject] isEqualToString:@"docx"]||[[textArray lastObject] isEqualToString:@"doc"]){
        self.styleImage.image = mImageByName(@"ic_default_doc");
    }else if ([[textArray lastObject] isEqualToString:@"xlsx"]||[[textArray lastObject] isEqualToString:@"xls"]){
        self.styleImage.image = mImageByName(@"ic_default_xls");
    }else{
        self.styleImage.image = mImageByName(@"");
    }
    self.nameLabel.text = model.fileName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
