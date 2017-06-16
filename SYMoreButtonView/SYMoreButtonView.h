//
//  SYMoreButtonView.h
//  DemoMoreButton
//
//  Created by zhangshaoyu on 17/6/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const heightSYMoreButtonView = 44.0;

@protocol SYMoreButtonDelegate <NSObject>

@optional
- (void)sy_buttonClick:(NSInteger)index;

@end

@interface SYMoreButtonView : UIView

/// 标题数组
@property (nonatomic, strong) NSArray <NSString *> *titles;

/// 默认NO，是否显示移动线
@property (nonatomic, assign) BOOL showline;
/// 默认NO，是否动态效果
@property (nonatomic, assign) BOOL showlineAnimation;
/// 默认红色，移动线条颜色
@property (nonatomic, strong) UIColor *colorline;

/// 默认0，初始化选择按钮
@property (nonatomic, assign) NSInteger indexSelected;
/// 默认黑色，按钮标题颜色
@property (nonatomic, strong) UIColor *colorNormal;
/// 默认红色，按钮标题选中颜色
@property (nonatomic, strong) UIColor *colorSelected;

/// 响应回调
@property (nonatomic, copy) void (^buttonClick)(NSInteger index);

/// 代理对象
@property (nonatomic, assign) id<SYMoreButtonDelegate> delegate;

/// 刷新数据
- (void)reloadData;

@end
