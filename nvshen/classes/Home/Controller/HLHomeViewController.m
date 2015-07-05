//
//  HLHomeViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/9.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLHomeViewController.h"
#import "HLHttpTool.h"
#import "UIImageView+WebCache.h"
#import "HLStatus.h"
#import "HLStatusFrame.h"
#import "HLUser.h"
#import "HLStatusCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "HLPosts.h"
#import "HLStatusToolbar.h"
#import "HLCommentViewContrller.h"
#import "HLChatViewController.h"
#import "MBProgressHUD+MJ.h"

@interface HLHomeViewController ()
/**
 *  show数组（里面放的都是HLStatusFrame模型，一个HLStatusFrame对象就代表一条show）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation HLHomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNav];
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    //注册通知
    [HLNotificationCenter addObserver:self selector:@selector(changelikeStatus:) name:@"addLikeNotification" object:nil];
    // 点击评论按钮
    [HLNotificationCenter addObserver:self selector:@selector(clickCommentBtn:) name:@"clickCommentBtnNotification" object:nil];
    // 点击私聊按钮
    [HLNotificationCenter addObserver:self selector:@selector(clickChatBtn:) name:@"clickChatBtnNotification" object:nil];

    [HLNotificationCenter addObserver:self selector:@selector(changeCommentStatus:) name:@"DoneCommentNotification" object:nil];

    [self.tableView reloadData];

}

/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    //    [self.tableView addFooterWithCallback:^{
    //        HWLog(@"进入上拉刷新状态");
    //    }];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewPosts)];
    
    // 2.进入刷新状态
    [self.tableView headerBeginRefreshing];
}

- (void)loadNewPosts{
    
    HLLog(@"loadNewPosts->>");

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    HLStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比maxid大的show（即比maxid时间晚的show），默认为0
        params[@"maxid"] = firstStatusF.status.posts.pid;
        HLLog(@"params[@maxid] %@",params[@"maxid"]);
    }
    // 2.发送请求
    [HLHttpTool get:HL_LATEST_POSTS_URL
             params:params success:^(id json) {
        // 将 "show（posts）字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [HLStatus objectArrayWithKeyValuesArray:json[@"status"]];
        
        // 将 HLStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];

        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
        //HLLog(@"%@", json);
    } failure:^(NSError *error) {
        HLLog(@"请求失败-%@", error);
        
        // 结束刷新刷新
        [self.tableView headerEndRefreshing];
    }];
}

/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(NSUInteger)count
{
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"还没有新的show，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%zd条新show，么么哒", count];
    }
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}


/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    HLLog(@"loadMoreStatus->>>");
    // 1.拼接请求参数
//    HLAccount *account = [HLAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    HLStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型

        long long minId = lastStatusF.status.posts.pid.longLongValue;
        params[@"minid"] = @(minId);
         HLLog(@"params[@minid] %@",params[@"maxid"]);
    }
    
    // 2.发送请求
    [HLHttpTool get:HL_OLDER_POSTS_URL params:params success:^(id json) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [HLStatus objectArrayWithKeyValuesArray:json[@"status"]];
        
        // 将 HLStatus数组 转为 HLStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        HLLog(@"请求失败-%@", error);
        
        // 结束刷新
        [self.tableView footerEndRefreshing];
    }];
}

- (void)setNav{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    //    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.width = 150;
    titleButton.height = 30;
    //    titleButton.backgroundColor = HWRandomColor;
    
    // 设置图片和文字
    [titleButton setTitle:@"首页" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    //    titleButton.imageView.backgroundColor = [UIColor redColor];
    //    titleButton.titleLabel.backgroundColor = [UIColor blueColor];
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    // 如果图片的某个方向上不规则，比如有突起，那么这个方向就不能拉伸
}

- (void)friendSearch{
    
}
- (void)pop{
    
}
- (void)titleClick{
    
}

/**
 *  将HLStatus模型转为HLStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HLStatus *status in statuses) {
        HLStatusFrame *f = [[HLStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    HLStatusCell *cell = [HLStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLStatusFrame *frame = self.statusFrames[indexPath.row];
    HLStatus *status = frame.status;
    [self pushToCommentViewContrller:status];
}

#pragma mark - 跳转到私聊界面
- (void)pushToChatViewContrller:(HLStatus *) status{
    HLChatViewController *chatView = [[HLChatViewController alloc] init];
    
    if([status.posts.user.username isEqualToString:[HLUserInfo sharedHLUserInfo].user])
    {
        [MBProgressHUD showError:@"不能和自己聊天！"];
        return;
    }
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", status.posts.user.username, domain]];
    chatView.friendJid = jid;
    chatView.title = status.posts.user.nickname;
    
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark - 私聊通知
- (void)clickChatBtn:(NSNotification *)chat{
    [self pushToChatViewContrller:chat.userInfo[@"status"]];
}

#pragma mark - 跳转到评论界面
- (void)pushToCommentViewContrller:(HLStatus *) status{
    HLCommentViewContrller *commentVC = [[HLCommentViewContrller alloc] init];
    commentVC.status = status;
    commentVC.title = viewDetailTitle;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - status通知
- (void)clickCommentBtn:(NSNotification *)comment{
    // 刷新表格
    [self pushToCommentViewContrller:comment.userInfo[@"status"]];
}

#pragma mark - 添加评论之后重新加载数据
- (void)changeCommentStatus:(NSNotification *)doneComment{
    HLLog(@"changeCommentStatus:");
    for( int i = 0; i< self.statusFrames.count; i++){
        HLStatusFrame *statusFrames = self.statusFrames[i];
        if(statusFrames.status.posts.pid == doneComment.userInfo[@"pid"]){
            statusFrames.status.comments_count += 1;
            [self.tableView reloadData];
            return;
        }
    }
    
}

#pragma mark - 点赞之后重新加载数据
- (void)changelikeStatus:(NSNotification *)like{
    NSLog(@"Home changelikeStatus pid: %@",like.userInfo[@"pid"]);
    
    for( int i=0; i< self.statusFrames.count; i++){
        HLStatusFrame *statusFrames = self.statusFrames[i];
        if(statusFrames.status.posts.pid == like.userInfo[@"pid"]){
            if([like.userInfo[@"response"][@"status"] isEqualToString:@"cancel"]){
                statusFrames.status.likes_count -= 1;
            }else if([like.userInfo[@"response"][@"status"] isEqualToString:@"done"]){
                statusFrames.status.likes_count += 1;
            }
            [self.tableView reloadData];
            return;
        }
    }
    
}

@end
