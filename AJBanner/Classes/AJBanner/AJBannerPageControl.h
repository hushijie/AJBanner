//
//  AJBannerPageControl.h
//  AJBanner
//
//  Created by JasonHu on 2017/7/4.
//  Copyright © 2017年 AJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJBannerPageControl : UIPageControl
{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
@property (nonatomic, retain) UIImage * imagePageStateNormal;
@property (nonatomic, retain) UIImage * imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame;

@end
