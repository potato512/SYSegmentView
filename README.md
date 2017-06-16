# SYButtonView
多种按钮样式（带图标筛选按钮视图、多按钮选择滚动视图……）


#多选按钮视图控件
![moreButton.gif](./images/moreButton.gif)

``` javascript
// 代码示例

#import "SYMoreButtonView.h"

// 实例化
SYMoreButtonView *buttonView = [[SYMoreButtonView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0)];
[self.view addSubview:buttonView];
buttonView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
// 标题数组
buttonView.titles = @[@"精选", @"直播", @"关注", @"视频购", @"社区", @"好东西", @"生活", @"数码", @"亲子", @"风尚", @"美食"];
// 属性设置
buttonView.showline = YES;
buttonView.showlineAnimation = YES;
buttonView.indexSelected = 0;
buttonView.colorSelected = [UIColor blueColor];

// 代理对象，需要遵守协议SYMoreButtonDelegate，及实现代理方法
buttonView.delegate = self;

// 回调方法
buttonView.buttonClick = ^(NSInteger index) {
    NSLog(@"block click index = %@", @(index));
};
// 加载UI
[buttonView reloadData];

// 实现代理方法
- (void)sy_buttonClick:(NSInteger)index
{
    NSLog(@"delegate click index = %@", @(index));
}

```