//
//  SYSegmentView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYSegmentView.h"

static NSInteger const kTagButton = 1000;
//
static NSString *const kWidthNormal = @"WidthNormal";
static NSString *const kWidthSelected = @"WidthSelected";

@interface SYSegmentView () <UIScrollViewDelegate>

// 初始化时没有动画
@property (nonatomic, assign) BOOL initializeAnimation;
//
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, assign) CGFloat previousOffX;
//
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *widthArray;
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;

@end

@implementation SYSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
 
        _spacing = 10;
        //
        _lineVisible = YES;
        _lineAnimation = YES;
        _lineWidth = 40;
        _lineHeight = 3;
        _lineAutoWidth = YES;
        _lineColor = UIColor.redColor;
        //
        _fontNormal = [UIFont systemFontOfSize:15];
        _fontSelected = [UIFont systemFontOfSize:15];
        _colorNormal = UIColor.blackColor;
        _colorSelected = UIColor.redColor;
    }
    return self;
}

#pragma mark - 视图

#pragma mark - 交互响应

- (void)segmentButtonClick:(UIButton *)button
{
    if (self.previousButton) {
        if (self.previousButton == button) {
            return;
        }
        self.previousButton.selected = NO;
    }
    button.selected = YES;
    self.previousButton = button;
    
    NSInteger index = button.tag - kTagButton;
    _indexSelected = index;
    // 视图效果处理
    [self reloadTitleView];
    [self reloadLineView:button];
    [self reloadTitleView:button];
    
    // 响应
    if (self.buttonClick) {
        self.buttonClick(index);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectAtIndexPath:)]) {
        [self.delegate segmentView:self didSelectAtIndexPath:index];
    }
}

#pragma mark - UISCrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.previousOffX = scrollView.contentOffset.x;
}

#pragma mark - methord

CGFloat TextWidth(NSString *text, UIFont *font)
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    return width;
}

- (void)loadTitleView:(NSArray *)titles
{
    CGFloat sizeWidth = self.spacing;
    //
    for (NSInteger index = 0; index < titles.count; index++) {
        NSString *title = self.titles[index];
        // 字符长度
        CGFloat widthNormal = TextWidth(title, self.fontNormal);
        CGFloat widthSelected = TextWidth(title, self.fontSelected);
        NSDictionary *dict = @{kWidthNormal:[NSNumber numberWithDouble:widthNormal], kWidthSelected:[NSNumber numberWithDouble:widthSelected]};
        [self.widthArray addObject:dict];
        //
        CGFloat titleWidth = widthNormal;
        // 按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(sizeWidth, 0.0, titleWidth, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = self.fontNormal;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.colorNormal forState:UIControlStateNormal];
        [button setTitleColor:self.colorSelected forState:UIControlStateSelected];
        button.tag = kTagButton + index;
        [button addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        //
        sizeWidth += titleWidth + (self.spacing * 2);
    }
    self.scrollView.contentSize = CGSizeMake((sizeWidth - self.spacing), self.frame.size.height);
}

- (void)reloadTitleView
{
    CGFloat originX = self.spacing;
    for (NSInteger index = 0; index < self.buttonArray.count; index++) {
        NSDictionary *dict = self.widthArray[index];
        NSNumber *widthNum = dict[kWidthNormal];
        UIFont *font = self.fontNormal;
        BOOL selected = NO;
        if (index == self.indexSelected) {
            widthNum = dict[kWidthSelected];
            font = self.fontSelected;
            selected = YES;
        }
        CGFloat width = widthNum.doubleValue;
        //
        UIButton *button = self.buttonArray[index];
        button.selected = selected;
        CGRect rect = button.frame;
        rect.origin.x = originX;
        rect.size.width = width;
        button.frame = rect;
        //
        button.titleLabel.font = font;
        //
        originX = (button.frame.origin.x + button.frame.size.width + self.spacing);
    }
    self.scrollView.contentSize = CGSizeMake(originX, self.frame.size.height);
}

- (void)reloadLineView:(UIButton *)button
{
    self.lineView.hidden = YES;
    if (self.lineVisible) {
        self.lineView.hidden = NO;
        [self.scrollView sendSubviewToBack:self.lineView];
        //
        CGFloat width = self.lineWidth;
        if (self.lineAutoWidth) {
            width = button.frame.size.width;
        }
        CGFloat originX = (button.frame.origin.x + (button.frame.size.width - width) / 2);
        CGFloat originY = (self.scrollView.frame.size.height - self.lineHeight);
        if (self.lineTop > 0) {
            originY = self.lineTop;
        }
        //
        if (self.lineAnimation) {
            __block CGRect rectline = self.lineView.frame;
            [UIView animateWithDuration:0.3 animations:^{
                rectline.origin.x = originX;
                rectline.origin.y = originY;
                rectline.size.width = width;
                self.lineView.frame = rectline;
            }];
        } else {
            CGRect rectline = self.lineView.frame;
            rectline.origin.x = originX;
            rectline.origin.y = originY;
            rectline.size.width = width;
            self.lineView.frame = rectline;
        }
    }
}

- (void)reloadTitleView:(UIButton *)button
{
    CGFloat buttonRight = button.frame.origin.x + button.frame.size.width + self.spacing;
    CGFloat buttonLeft = button.frame.origin.x;
    //
    if (buttonRight > (self.scrollView.frame.size.width + self.previousOffX)) {
        self.previousOffX = (buttonRight - self.scrollView.frame.size.width);
        [self.scrollView setContentOffset:CGPointMake(self.previousOffX, 0.0) animated:YES];
    } else if (buttonLeft < self.previousOffX) {
        self.previousOffX = (buttonRight - button.frame.size.width - self.spacing * 2);
        [self.scrollView setContentOffset:CGPointMake(self.previousOffX, 0.0) animated:YES];
    }
}

- (void)reloadSegment
{
    [self loadTitleView:self.titles];
    self.initializeAnimation = self.lineAnimation;
    self.lineAnimation = NO;
    
    // 初始化
    UIButton *button = self.buttonArray[self.indexSelected];
    [self segmentButtonClick:button];
    //
    self.lineAnimation = self.initializeAnimation;
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_spacing, (self.scrollView.frame.size.height - _lineHeight), 0.0, _lineHeight)];
        [self.scrollView addSubview:_lineView];
        _lineView.backgroundColor = _lineColor;
    }
    return _lineView;
}

- (NSMutableArray<NSDictionary *> *)widthArray
{
    if (_widthArray == nil) {
        _widthArray = [[NSMutableArray alloc] init];
    }
    return _widthArray;
}

- (NSMutableArray<UIButton *> *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

#pragma mark - setter

- (void)setIndexSelected:(NSInteger)indexSelected
{
    _indexSelected = indexSelected;
    if (self.buttonArray.count > 0 && self.titles.count == self.buttonArray.count) {
        [self reloadTitleView];
        //
        UIButton *button = self.buttonArray[_indexSelected];
        [self reloadTitleView:button];
        [self reloadLineView:button];
    }
}

@end
