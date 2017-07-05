//
//  AJBannerView.h
//  AJBanner
//
//  Created by JasonHu on 2017/7/4.
//  Copyright © 2017年 AJ. All rights reserved.
//

/*
 banner视图
 */

#import <UIKit/UIKit.h>

@interface AJBannerView : UIView

//数据源
@property (nonatomic ,copy)NSArray * dataSource;

//选中某个广告之后的回调
@property (nonatomic ,copy)void(^didSelectedBannerBlock)(id object);

@end
