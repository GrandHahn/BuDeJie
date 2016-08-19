//
//  XMGEssenceViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/2.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGTitleButton.h"
//#import "UIBarButtonItem+Item.h"
#import "XMGAllViewController.h"
#import "XMGPictureViewController.h"
#import "XMGVideoViewController.h"
#import "XMGVoiceViewController.h"
#import "XMGWordViewController.h"
@interface XMGEssenceViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *titleBar;
@property (nonatomic, weak) XMGTitleButton *previousClickedtitleButton;
@property (nonatomic, weak) UIView *downLine;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation XMGEssenceViewController

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条内容
    [self setupNavBar];
    
    // 创建所有子控制器
    [self setupAllChildVCs];
    
    // 添加scrollview
    [self setupScrollView];
    // 添加栏目条
    [self setupTitleBar];
    
    
    // 默认显示第一个控制器view
    [self addChildViewIntoScrollView:0];
}

- (void)setupAllChildVCs {
    [self addChildViewController:[[XMGAllViewController alloc] init]];
    [self addChildViewController:[[XMGPictureViewController alloc] init]];
    [self addChildViewController:[[XMGVideoViewController alloc] init]];
    [self addChildViewController:[[XMGVoiceViewController alloc] init]];
    [self addChildViewController:[[XMGWordViewController alloc] init]];
}

- (void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    // 点击状态栏，不滚到顶部
    scrollView.scrollsToTop = NO;
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    
//    for (int i = 0; i < self.childViewControllers.count; i++) {
//        UIView *view = self.childViewControllers[i].view;
//        view.frame = CGRectMake(i * scrollView.xmg_width, 0, scrollView.xmg_width, scrollView.xmg_height);
//        [scrollView addSubview:view];
//    }
    scrollView.contentSize = CGSizeMake(5 * scrollView.xmg_width, 0);
    scrollView.pagingEnabled = YES;
}

- (void)setupTitleBar {
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.xmg_width, 35)];
//    titleBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titleBar.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.95];
    
    [self.view addSubview:titleBar];
    self.titleBar = titleBar;
    
    // 创建栏目标题
    [self setupTitleBtn];
    
    // 下划线
    [self setupDownLine];
}

- (void)setupDownLine {
    // 取出第一个按钮
    XMGTitleButton *btn = self.titleBar.subviews[0];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleBar.xmg_height - 2, 70, 2)];
//    downLine.backgroundColor = btn.titleLabel.textColor;
    downLine.backgroundColor = [btn titleColorForState:UIControlStateSelected];
    [self.titleBar addSubview:downLine];
    self.downLine = downLine;
    // 默认选中第一个
    
    // 默认选中第一个,这个按钮设红色
    btn.selected = YES;
    // 保存上一个按钮
    self.previousClickedtitleButton = btn;
    
    // 解决一开始没值
    [btn.titleLabel sizeToFit];
    // 设置下滑线位置
    self.downLine.xmg_width = btn.titleLabel.xmg_width + 10;
    self.downLine.xmg_centerX = btn.xmg_centerX;
}

- (void)setupTitleBtn {
    NSArray *titleArray = @[@"全部", @"图片", @"视频", @"声音", @"段子"];
    CGFloat btnW = self.titleBar.xmg_width / titleArray.count;
    CGFloat btnH = self.titleBar.xmg_height;
    for (int i = 0; i < titleArray.count; i++) {
        XMGTitleButton *titleBtn = [[XMGTitleButton alloc] initWithFrame:CGRectMake(i * btnW, 0, btnW, btnH)];
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag = i;
        [self.titleBar addSubview:titleBtn];
    }
    // 默认选中第一个
//    [self titleBtnClick:self.titleBar.subviews[0]];
}

- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"nav_item_game_icon" highImageName:@"nav_item_game_click_icon" target:self action:@selector(btn)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"navigationButtonRandom" highImageName:@"navigationButtonRandomClick" target:self action:@selector(btn)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationButtonRandom"]style:UIBarButtonItemStyleDone target:self action:@selector(btn)];
}

#pragma mark - 监听

- (void)titleBtnClick:(XMGTitleButton *)titleBtn {
    
    // 判断是否重复点击
    if (self.previousClickedtitleButton == titleBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 上一个按钮设灰色
    self.previousClickedtitleButton.selected = NO;
    // 这个按钮设红色
    titleBtn.selected = YES;
    // 保存上一个按钮
    self.previousClickedtitleButton = titleBtn;
    
    // 设置下滑线位置
    [UIView animateWithDuration:0.25 animations:^{
        self.downLine.xmg_width = titleBtn.titleLabel.xmg_width + 10;
        self.downLine.xmg_centerX = titleBtn.xmg_centerX;
        
        // 点击切换控制器界面
        self.scrollView.contentOffset = CGPointMake(self.scrollView.xmg_width * titleBtn.tag, self.scrollView.contentOffset.y);
//        [self.scrollView.subviews indexOfObject:titleBtn];
        
    } completion:^(BOOL finished) {
        // 加载控制器界面
        [self addChildViewIntoScrollView:titleBtn.tag];
        
        
#warning 此处发通知应该放在titleBtnClick里面，如果放scrollViewDidEndDecelerating里面，则在点击按钮时无响应
        [[NSNotificationCenter defaultCenter] postNotificationName:XMGEssenceViewScrollViewDidEndDeceleratingNotification object:nil userInfo:nil];

    }];
    
    // scrollsToTop
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVC = self.childViewControllers[i];
        
        if (!childVC.isViewLoaded) {
            return;
        }
        
        if (![childVC.view isKindOfClass:[UIScrollView class]]) {
            return;
        }
        
        UIScrollView *scrollView = (UIScrollView *)childVC.view;
        scrollView.scrollsToTop = (i == titleBtn.tag);
        
    }
}

- (void)addChildViewIntoScrollView:(NSInteger)index {
//    UIView *childView = self.childViewControllers[index].view;
    
    UIViewController *childVc = self.childViewControllers[index];
    if (self.childViewControllers[index].isViewLoaded) {
        return;
    }
    
    childVc.view.frame = CGRectMake(index * self.scrollView.xmg_width, 0, self.scrollView.xmg_width, self.scrollView.xmg_height);
    [self.scrollView addSubview:childVc.view];
}

- (void)btn {
    XMGFunc
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.xmg_width;
    XMGTitleButton *titleBtn = self.titleBar.subviews[index];
    
    // 防止拖动后还在原界面时会刷新
    if (self.previousClickedtitleButton == titleBtn) return;
    
    // 此方法可能会选错
    //    [self.titleBar viewWithTag:index];
    [self titleBtnClick:titleBtn];
    
    
#warning 此处发通知应该放在titleBtnClick里面，当前方法只有拖动来才会来
//    [[NSNotificationCenter defaultCenter] postNotificationName:XMGEssenceViewScrollViewDidEndDeceleratingNotification object:nil userInfo:nil];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 此方法要调用setContentOffset: animated:执行完动画才回调用
}



@end
