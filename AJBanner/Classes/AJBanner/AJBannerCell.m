//
//  AJBannerCell.m
//  AJBanner
//
//  Created by JasonHu on 2017/7/4.
//  Copyright © 2017年 AJ. All rights reserved.
//

#import "AJBannerCell.h"

@interface AJBannerCell ()

@property (nonatomic ,weak)UIImageView * picImageView;

@end

@implementation AJBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //展示图片
        UIImageView * picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        picImageView.contentMode=UIViewContentModeScaleAspectFill;
        picImageView.clipsToBounds=YES;
        [self.contentView addSubview:picImageView];
        _picImageView=picImageView;
        
    }
    return self;
}


#pragma mark - setter

-(void)setObject:(id)object
{
    _object=object;
    
    if ([_object isKindOfClass:[NSString class]]) {
        self.picImageView.image=[UIImage imageNamed:_object];
    }
}


@end
