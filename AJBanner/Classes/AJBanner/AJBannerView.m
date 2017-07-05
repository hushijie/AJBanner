//
//  AJBannerView.m
//  AJBanner
//
//  Created by JasonHu on 2017/7/4.
//  Copyright © 2017年 AJ. All rights reserved.
//

#define AJBannerCellIdentifier @"AJBannerCell"
#define ItemCountTimes 100 //item数的倍数（50倍）

#define PageContolHeight 30.0
#define PageContolWidth 90.0f
#define AJBannerTimeInterval 3  // banner 图的广告播放时间

#define PageImage @"Banner_PageControl_Normal"              //非当前页的 PageControl 的图片
#define CurrentPageImage @"Banner_PageControl_Selected"     //当前页的 PageControl 的图片
#define PlaceHolderImage  @"v4_default_rectangle"           //当没有 banner 图时候的占位图

#import "AJBannerView.h"
#import "AJBannerCell.h"
#import "AJBannerPageControl.h"

@interface AJBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

//没有数据的时候的占位图
@property (nonatomic ,weak)UIImageView * placeHolderImageView;

@property (weak, nonatomic)UICollectionView *collectionView;

@property (nonatomic ,weak)AJBannerPageControl * pageControl;

@property(nonatomic,strong)NSTimer * timer;

@end

@implementation AJBannerView

#pragma mark - 创建视图

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self placeHolderImageView];
        
    }
    return self;
}

- (void)dealloc {
    
    //移除定时器
    [self.timer invalidate];
    self.timer = nil;
    
}



#pragma mark - 懒加载

-(UIImageView *)placeHolderImageView
{
    if (!_placeHolderImageView) {
        
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        [imageView setImage:[UIImage imageNamed:PlaceHolderImage]];
        [self addSubview:imageView];
        _placeHolderImageView=imageView;
        
    }
    return _placeHolderImageView;
}


-(AJBannerPageControl *)pageControl
{
    if (!_pageControl) {
        
        AJBannerPageControl * pageController=[[AJBannerPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width-PageContolWidth-20, self.bounds.size.height-PageContolHeight, PageContolWidth, PageContolHeight)];
        pageController.backgroundColor=[UIColor clearColor];
        
        //修改pagecontroller的 选中 和非选中背景
        [pageController setValue:[UIImage imageNamed:PageImage] forKeyPath:@"pageImage"];
        [pageController setValue:[UIImage imageNamed:CurrentPageImage] forKeyPath:@"currentPageImage"];
        
        //禁止点击
        pageController.userInteractionEnabled=NO;
        
        [self addSubview:pageController];
        _pageControl=pageController;
    }
    
    [self bringSubviewToFront:_pageControl];
    
    return _pageControl;
}



-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        CGFloat itemWidth = self.bounds.size.width;
        CGFloat itemHeight = self.bounds.size.height;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        collectionView.backgroundColor=[UIColor whiteColor];
        
        //注册cell
        [collectionView registerClass:[AJBannerCell class] forCellWithReuseIdentifier:AJBannerCellIdentifier];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        
        collectionView.pagingEnabled=YES;
        
        [self addSubview:collectionView];
        _collectionView=collectionView;
        
    }
    return _collectionView;
}


#pragma mark - setter

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource=dataSource;
    
    if (_dataSource.count>0) {
        
        self.placeHolderImageView.hidden=YES;
        self.collectionView.hidden=NO;
        self.pageControl.hidden=NO;
        
        /*
         刷新并移到中间部分
         */
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_dataSource.count*(ItemCountTimes/2) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        self.pageControl.numberOfPages=_dataSource.count;
        self.pageControl.currentPage=0;
        
        /*
         是否滚动、是否显示pageController
         */
        //数据源数量超过1个：滚动、显示pageController
        if (_dataSource.count>1) {
            self.collectionView.scrollEnabled=YES;
            self.pageControl.hidden=NO;
        }
        //数据源只有一个数据：禁止滚动、隐藏pageController
        else{
            self.collectionView.scrollEnabled=NO;
            self.pageControl.hidden=YES;
        }
        
        //添加计时器
        [self addNSTimer];
        
    }
    else{
        
        self.placeHolderImageView.hidden=NO;
        self.collectionView.hidden=YES;
        self.pageControl.hidden=YES;
        
    }
    
}



#pragma mark - UICollectionViewDelegate 代理方法


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //注：之所以section的返回值是1，是因为section如果设置太大的话容易消耗性能！所以我们可以将item的返回值设置的大一些
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.dataSource.count * ItemCountTimes);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AJBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:AJBannerCellIdentifier forIndexPath:indexPath];
    cell.object=self.dataSource[indexPath.item%_dataSource.count];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedBannerBlock) {
        self.didSelectedBannerBlock(self.dataSource[indexPath.item%_dataSource.count]);
    }
}


#pragma mark - 自动定时轮播


//添加定时器
-(void)addNSTimer
{
    //数据源数量大于1 && 还没有添加计时器的时候才需要添加计时器
    if (self.dataSource.count>1 && !self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:AJBannerTimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        //添加到runloop中
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer=timer;
    }
}

//删除定时器
-(void)removeNSTimer
{
    [self.timer invalidate];
    self.timer=nil;
}

//自动滚动
-(void)nextPage
{
    
    if (self.dataSource.count == 0) {
        return;
    }
    //获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[self.collectionView indexPathsForVisibleItems]lastObject];
    
    //回到中间相应的显示位置
    NSIndexPath *currentIndexPathRest=[NSIndexPath indexPathForItem:(_dataSource.count*(ItemCountTimes/2))+(currentIndexPath.item%_dataSource.count) inSection:0];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathRest atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    //计算出下一个需要展示的位置
    NSInteger nextItem=currentIndexPathRest.item+1;
    NSInteger nextSection=currentIndexPathRest.section;
    NSIndexPath *nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}



#pragma mark - UIScrollView的代理


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
     页书为0 不需要设置page
     */
    if (self.dataSource.count==0) {
        return;
    }
    
    int page=(int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.dataSource.count;
    self.pageControl.currentPage=page;
    
}

@end
