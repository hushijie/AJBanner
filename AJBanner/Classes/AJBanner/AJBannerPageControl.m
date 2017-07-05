//
//  AJBannerPageControl.m
//  AJBanner
//
//  Created by JasonHu on 2017/7/4.
//  Copyright © 2017年 AJ. All rights reserved.
//

#define dotW 7.0f
#define activeDotW 7.0f
#define magrin 8

#import "AJBannerPageControl.h"

// 声明一个私有方法, 该方法不允许对象直接使用
@interface AJBannerPageControl (private)

- (void)updateDots;

@end

@implementation AJBannerPageControl

@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame
{ // 初始化
    self = [super initWithFrame:frame];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    
    CGFloat paddingX=self.bounds.size.width-marginX*self.subviews.count;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(paddingX+i * marginX, dot.frame.origin.y, activeDotW, activeDotW)];
        }else {
            [dot setFrame:CGRectMake(paddingX+i * marginX, dot.frame.origin.y, dotW, dotW)];
        }
    }
}


- (void)setImagePageStateNormal:(UIImage *)image
{
    // 设置正常状态点按钮的图片
    imagePageStateHighlighted = image;
    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image
{
    // 设置高亮状态点按钮图片
    imagePageStateNormal = image;
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)updateDots
{
//    // 更新显示所有的点按钮
//    if (imagePageStateNormal || imagePageStateHighlighted)
//    {
//        NSArray *subview = self.subviews;  // 获取所有子视图
//        for (NSInteger i = 0; i < [subview count]; i++)
//        {
//            UIImageView *dot = [subview objectAtIndex:i];
//            dot.image = self.currentPage == i ? imagePageStateNormal : imagePageStateHighlighted;
//            dot.image = [UIImage imageNamed:@"Banner_PageControl_Normal"];
//        }
//    }
}

- (void)dealloc
{
    // 释放内存
    imagePageStateNormal = nil;
    imagePageStateHighlighted = nil;
}

@end
