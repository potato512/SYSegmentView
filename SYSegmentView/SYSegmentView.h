//
//  SYSegmentView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/6/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  github:https://github.com/potato512/SYSegmentView

#import <UIKit/UIKit.h>
@class SYSegmentView;

#pragma mark - 代理协议

@protocol SYSegmentViewDelegate <NSObject>

@optional
- (void)segmentView:(SYSegmentView *)segmentView didSelectAtIndexPath:(NSInteger)index;

@end

#pragma mark - 视图

@interface SYSegmentView : UIView

/// 实例化
- (instancetype)init __attribute__((unavailable("init 方法不可用，请用 initWithName:")));
- (instancetype)initWithFrame:(CGRect)frame;

/// 代理对象
@property (nonatomic, weak) id<SYSegmentViewDelegate> delegate;

/// 标题数组
@property (nonatomic, strong) NSArray <NSString *> *titles;

/// 默认0，初始化选择按钮
@property (nonatomic, assign) NSInteger indexSelected;

/// 默认10，间距大小
@property (nonatomic, assign) CGFloat spacing;


/// 默认YES，是否显示移动线
@property (nonatomic, assign) BOOL lineVisible;
/// 默认NO，是否动态效果
@property (nonatomic, assign) BOOL lineAnimation;
/// 默认红色，移动线条颜色
@property (nonatomic, strong) UIColor *lineColor;
/// 默认线高3，移动线条高度
@property (nonatomic, assign) CGFloat lineHeight;
/// 默认线宽40，移动线条宽度
@property (nonatomic, assign) CGFloat lineWidth;
/// 默认YES，移动线条自适应字体宽度
@property (nonatomic, assign) BOOL lineAutoWidth;
/// 默认底端居中对齐，移动线条中心位置
@property (nonatomic, assign) CGFloat lineTop;

/// 默认字体15，按钮标题字体大小
@property (nonatomic, strong) UIFont *fontNormal;
/// 默认字体15，按钮标题字体选中大小
@property (nonatomic, strong) UIFont *fontSelected;
/// 默认黑色，按钮标题颜色
@property (nonatomic, strong) UIColor *colorNormal;
/// 默认红色，按钮标题选中颜色
@property (nonatomic, strong) UIColor *colorSelected;

/// 响应回调
@property (nonatomic, copy) void (^buttonClick)(NSInteger index);


/// 刷新数据
- (void)reloadSegment;

@end
