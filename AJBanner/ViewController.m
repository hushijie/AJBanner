//
//  ViewController.m
//  AJBanner
//
//  Created by JasonHu on 2017/7/4.
//  Copyright © 2017年 AJ. All rights reserved.
//

#define BannnerRatioWidthToHeight (75.0/28.0)

#import "ViewController.h"
#import "AJBannerView.h"

@interface ViewController ()

@property (nonatomic,weak)AJBannerView * bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self bannerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

-(AJBannerView *)bannerView
{
    if (!_bannerView) {
        
        AJBannerView * bannerView=[[AJBannerView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, (self.view.bounds.size.width/BannnerRatioWidthToHeight))];
        bannerView.dataSource=@[@"AJBannerImage1.jpg",@"AJBannerImage2.jpg",@"AJBannerImage3.jpg"];
        
        __weak __typeof__(self)weakSelf=self;
        //点击某个广告之后的回调
        [bannerView setDidSelectedBannerBlock:^(id object) {
            
//            UIViewController * vc=[[UIViewController alloc]init];
//            vc.view.backgroundColor=[UIColor greenColor];
//            [weakSelf presentViewController:vc animated:YES completion:^{
//                
//            }];
            
        }];
        
        [self.view addSubview:bannerView];
        _bannerView=bannerView;
    }
    return _bannerView;
}


@end
