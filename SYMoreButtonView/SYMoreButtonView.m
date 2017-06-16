//
//  SYMoreButtonView.m
//  DemoMoreButton
//
//  Created by zhangshaoyu on 17/6/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYMoreButtonView.h"

static CGFloat const originXY = 10.0;
static CGFloat const heightline = 3.0;

static NSInteger const tagButton = 1000;

@interface SYMoreButtonView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleView;
@property (nonatomic, strong) UIView *titleLine;

@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, assign) CGFloat previousOffX;

@end

@implementation SYMoreButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
 
        _showline = NO;
        _showlineAnimation = NO;
        _colorline = [UIColor redColor];
        
        _indexSelected = 0;
        _colorNormal = [UIColor blackColor];
        _colorSelected = [UIColor redColor];
        
        [self setUI];
    }
    return self;
}

#pragma mark - 视图

- (void)setUI
{
    // 标题视图
    self.titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.titleView];
    self.titleView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.titleView.showsHorizontalScrollIndicator = NO;
    self.titleView.showsVerticalScrollIndicator = NO;
    self.titleView.delegate = self;
    
    // 移动线
    self.titleLine = [[UIView alloc] initWithFrame:CGRectMake(originXY, (self.titleView.frame.size.height - heightline), 0.0, heightline)];
    [self.titleView addSubview: self.titleLine];
    self.titleLine.backgroundColor = _colorline;
}

#pragma mark - 响应

- (void)cationClick:(UIButton *)button
{
    // 视图效果处理
    [self resetTileLine:button];
    [self resetTitleView:button];
    
    // 状态处理
    if (self.previousButton != nil)
    {
        self.previousButton.selected = NO;
    }
    button.selected = !button.selected;
    self.previousButton = button;
    
    // 响应
    if (self.buttonClick)
    {
        NSInteger index = button.tag - tagButton;
        self.buttonClick(index);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sy_buttonClick:)])
    {
        NSInteger index = button.tag - tagButton;
        [self.delegate sy_buttonClick:index];
    }
}

#pragma mark - UISCrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.previousOffX = scrollView.contentOffset.x;
}

#pragma mark - setter

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    
    __block CGFloat sizeWidth = originXY;
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 字符实际长度
        CGFloat titleWidth = [obj boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.width;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(sizeWidth, 0.0, titleWidth, self.titleView.frame.size.height)];
        [self.titleView addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:_colorNormal forState:UIControlStateNormal];
        [button setTitleColor:_colorSelected forState:UIControlStateSelected];
        button.tag = tagButton + idx;
        [button addTarget:self action:@selector(cationClick:) forControlEvents:UIControlEventTouchUpInside];
        
        sizeWidth += titleWidth + (originXY * 2);
    }];
    self.titleView.contentSize = CGSizeMake((sizeWidth - originXY), self.frame.size.height);
}

#pragma mark - methord

- (void)resetTileLine:(UIButton *)button
{
    if (_showline)
    {
        if (_showlineAnimation)
        {
            __block CGRect rectline = self.titleLine.frame;
            rectline.size.width = button.frame.size.width;
            [UIView animateWithDuration:0.3 animations:^{
                rectline.origin.x = button.frame.origin.x;
                self.titleLine.frame = rectline;
            }];
        }
        else
        {
            CGRect rectline = self.titleLine.frame;
            rectline.size.width = button.frame.size.width;
            rectline.origin.x = button.frame.origin.x;
            self.titleLine.frame = rectline;
        }
    }
}

- (void)resetTitleView:(UIButton *)button
{
    CGFloat buttonRight = button.frame.origin.x + button.frame.size.width + originXY;
    CGFloat buttonLeft = button.frame.origin.x;
    
    if (buttonRight > (self.titleView.frame.size.width + self.previousOffX))
    {
        self.previousOffX = (buttonRight - self.titleView.frame.size.width);
        [self.titleView setContentOffset:CGPointMake(self.previousOffX, 0.0) animated:YES];
    }
    else if (buttonLeft < self.previousOffX)
    {
        self.previousOffX = (buttonRight - button.frame.size.width - originXY * 2);
        [self.titleView setContentOffset:CGPointMake(self.previousOffX, 0.0) animated:YES];
    }
}

- (void)resetTitleButton
{
    [self.titleView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)obj;
            if (_colorNormal)
            {
                [button setTitleColor:_colorNormal forState:UIControlStateNormal];
            }
            if (_colorSelected)
            {
                [button setTitleColor:_colorSelected forState:UIControlStateSelected];
            }
        }
    }];
}

- (void)reloadData
{
    [self resetTitleButton];
    
    self.titleLine.hidden = !_showline;
    self.titleLine.backgroundColor = _colorline;
    
    // 初始化
    UIButton *button = (UIButton *)[self.titleView viewWithTag:(tagButton + _indexSelected)];
    [self cationClick:button];
}


@end
