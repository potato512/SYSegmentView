//
//  ViewController.m
//  DemoMoreButton
//
//  Created by zhangshaoyu on 17/6/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYSegmentView.h"

@interface ViewController () <SYSegmentViewDelegate, UIScrollViewDelegate>
{
    SYSegmentView *segmentView;
    UIScrollView *scrollView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"多按钮视图";
    //
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

#pragma mark -

- (void)setUI
{
    NSArray *titles = @[@"精选", @"我的直播间", @"关注", @"视频购", @"社区", @"好东西", @"生活", @"数码", @"亲子", @"风尚", @"美食"];
    //
    segmentView = [[SYSegmentView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0)];
    [self.view addSubview:segmentView];
    segmentView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    segmentView.titles = titles;
    //
    segmentView.spacing = 20;
    // 线条
    segmentView.lineVisible = NO;
    segmentView.lineAnimation = NO;
    segmentView.lineAutoWidth = YES;
    segmentView.indexSelected = 3;
    segmentView.lineHeight = 30;
    segmentView.lineTop = 10;
    segmentView.lineColor = UIColor.orangeColor;
    // 字体样式
    segmentView.fontNormal = [UIFont systemFontOfSize:13];
    segmentView.fontSelected = [UIFont systemFontOfSize:18];
    segmentView.colorNormal = UIColor.orangeColor;
    segmentView.colorSelected = UIColor.greenColor;
    // 代理回调
    segmentView.delegate = self;
    segmentView.buttonClick = ^(NSInteger index) {
        NSLog(@"block click index = %@", @(index));
    };
    //
    [segmentView reloadSegment];
    
    //
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, (self.view.frame.size.height - 50))];
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    for (NSInteger index = 0; index < titles.count; index++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((index * scrollView.frame.size.width), 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        [scrollView addSubview:view];
        //
        NSString *title = titles[index];
        UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
        [view addSubview:label];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.blackColor;
    }
    scrollView.contentSize = CGSizeMake(titles.count * self.view.frame.size.width, self.view.frame.size.height);
}

- (void)segmentView:(SYSegmentView *)segmentView didSelectAtIndexPath:(NSInteger)index
{
    NSLog(@"delegate click index = %@", @(index));
    [scrollView setContentOffset:CGPointMake(index * scrollView.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
//    segmentView.indexSelected = page;
    NSLog(@"1 %s", __func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"2 %s", __func__);
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    segmentView.indexSelected = page;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"3 %s", __func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"4 %s", __func__);
}
@end
