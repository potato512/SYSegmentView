//
//  ViewController.m
//  DemoMoreButton
//
//  Created by zhangshaoyu on 17/6/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYMoreButtonView.h"

@interface ViewController () <SYMoreButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"多按钮视图";
    

    
    SYMoreButtonView *buttonView = [[SYMoreButtonView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0)];
    [self.view addSubview:buttonView];
    buttonView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    buttonView.titles = @[@"精选", @"直播", @"关注", @"视频购", @"社区", @"好东西", @"生活", @"数码", @"亲子", @"风尚", @"美食"];
    buttonView.showline = YES;
    buttonView.showlineAnimation = YES;
    buttonView.indexSelected = 0;
    buttonView.colorSelected = [UIColor blueColor];
    buttonView.delegate = self;
    buttonView.buttonClick = ^(NSInteger index) {
        NSLog(@"block click index = %@", @(index));
    };
    [buttonView reloadData];
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

- (void)sy_buttonClick:(NSInteger)index
{
    NSLog(@"delegate click index = %@", @(index));
}

@end
