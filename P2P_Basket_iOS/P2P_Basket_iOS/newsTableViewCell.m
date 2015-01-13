//
//  newsTableViewCell.m
//  hbj_app
//
//  Created by eidision on 14/12/27.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "newsTableViewCell.h"

@implementation newsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Fix for contentView constraint warning
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        //头像
        _portalImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//        _portalImage.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_portalImage];
        
        //news
        _newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, [UIScreen mainScreen].applicationFrame.size.width - 85, 19)];
        _newsTitle.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        _newsTitle.font = [UIFont boldSystemFontOfSize:16];
        _newsTitle.numberOfLines = 1;
        [self.contentView addSubview:_newsTitle];
        
        //detail
        _detailText = [[UILabel alloc]initWithFrame:CGRectMake(70, 25, [UIScreen mainScreen].applicationFrame.size.width - 85, 40)];
        _detailText.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        _detailText.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _detailText.numberOfLines = 0;
        [self.contentView addSubview:_detailText];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
