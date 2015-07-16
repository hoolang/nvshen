//
//  HLChatMainViewController.m
//  nvshen
//
//  Created by hoolang on 15/7/6.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLChatMainViewController.h"
#import "SegmentedControl.h"
#import "HLChatViewController.h"
#import "HLChatsTool.h"

@interface HLChatMainViewController ()
<
HLChatRecentVCDelegate,
HLChatListVCDelegate
>
@property (nonatomic, strong) NSArray *viewsControllers;
@property (nonatomic, assign) NSInteger lastSelectedSegmentIndex;
@end

@implementation HLChatMainViewController

- (void)viewDidAppear:(BOOL)animated
{
    HLLog(@"%s ", __func__);
    [self.recentVC loadDataSources];
    
    if (!self.chatListVC.didLoad) {

        [self.chatListVC loadFriends];

    }
    self.chatListVC.isChating = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChatBadge];
    
    SegmentedControl *segmentedControl = [[SegmentedControl alloc] init];
    [segmentedControl addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    
    self.recentVC = [[HLChatRecentViewController alloc] init];
    self.recentVC.view.frame = self.view.bounds;
    self.recentVC.delegate = self;
    [self.view addSubview:self.recentVC.view];
    
    self.chatListVC = [[HLChatListViewController alloc] init];
    self.chatListVC.view.frame = self.view.bounds;
    self.chatListVC.delegate = self;
    [self.view addSubview:self.chatListVC.view];

    // 添加子控制器
    self.viewsControllers = @[self.recentVC, self.chatListVC];
    
    segmentedControl.selectedSegmentIndex = 0;
    self.lastSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    

    self.recentVC.view.hidden = NO;
    self.chatListVC.view.hidden = YES;
    
    [HLNotificationCenter addObserver:self selector:@selector(refreshRecentList) name:@"SetUpChatBadgeNotification" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) typeAction:(SegmentedControl *) sender{
    HLLog(@"ViewController typeAction:");
    [self transitionFrom:self.lastSelectedSegmentIndex to:sender.selectedSegmentIndex];
    self.lastSelectedSegmentIndex = sender.selectedSegmentIndex;
}


-(void)transitionFrom:(NSInteger)from to:(NSInteger)to{
    
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionPush;
    transition.subtype = from > to ? kCATransitionFromLeft : kCATransitionFromRight;
    
    UIViewController *currentSegmentedView = (UIViewController *)self.viewsControllers[from];
    UIViewController *nextSegmentedView = (UIViewController *)self.viewsControllers[to];
    
    [currentSegmentedView.view.layer addAnimation:transition forKey:@"transition"];
    [nextSegmentedView.view.layer addAnimation:transition forKey:@"transition"];
    
    currentSegmentedView.view.hidden = YES;
    nextSegmentedView.view.hidden = NO;
}

#pragma mark -HLChatListVCDelegate
- (void)pushToChatView:(HLChatViewController *)chatView
{
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark -HLChatRecentVCDelegate
- (void)pushRecentToChatView:(HLChatViewController *)chatView
{
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)pushRecentToSubscriptionView:(HLChatViewController *)chatView
{
    
}

- (void)chatRecentRefreshMainViewBadge
{
    HLLog(@"%s", __func__);
    // 设置badge
    [self setupChatBadge];
}

#pragma mark - 设置badge
/**
 *  刷新待处理好友请求个数
 */
- (void)refreshRecentList
{
    // 刷新待处理好友请求个数
    [self.recentVC loadDataSources];
    // 设置badge
    [self setupChatBadge];
    // 刷新表格
    [self.recentVC.tableView reloadData];
}

/**
 *  设置badge
 */
- (void)setupChatBadge
{
    HLLog(@"%s", __func__);
    
    int badges = 0;
    // 获取好友请求数
    NSArray *array = [HLChatsTool newSubscriptions];
    // 获取消息数
    NSArray *messages = [HLChatsTool loadMessages];
    
    for (HLUser *user in messages) {
        // 此时的sex表示消息数
        badges += [user.sex intValue];
    }
    
    badges += array.count;
    
    HLLog(@"setupChatBadge array.count %d", badges);
    if (badges > 0) { // 如果是0，得清空数字
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", badges];
        [UIApplication sharedApplication].applicationIconBadgeNumber = badges;
    } else { // badges = 0, 清空数字
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    HLLog(@"设置Badge完成： %s", __func__);
}


-(void)dealloc
{
    [HLNotificationCenter removeObserver:self];
    HLLog(@"%s", __func__);
}
@end
