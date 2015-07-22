//
//  HLCommentViewContrller.m
//  nvshen
//
//  Created by hoolang on 15/6/2.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopViewController.h"
#import "HLEmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HLStatusFrame.h"
#import "HLStatus.h"
#import "HLPosts.h"
#import "HLUser.h"
#import "HLComments.h"
#import "HLCommentCell.h"
#import "HLCommentView.h"
#import "HLHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "HLTopPostsFrame.h"
#import "HLTopCommentsPostsCell.h"
#import "HLTopLikesPotsCell.h"
#import "HLLatestUserPostsCell.h"
#import "HLTopDetailViewController.h"
#import "HLCommentViewContrller.h"

typedef enum {
    LATEST_USER_POSTS = 0,
    MOST_COMMENTS_POSTS = 1,
    MOST_LIKES_POSTS =  2
} topStyle;

@interface HLTopViewController()
<
UITableViewDelegate,
UITableViewDataSource,
HLTopPostsCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *userPostsFrame;
@property (nonatomic, strong) NSArray *mostCommentsFrame;
@property (nonatomic, strong) NSArray *mostLikeFrame;
/** 标记是否已经加载数据 */
@property (nonatomic, assign) BOOL didLoad;

@end


@implementation HLTopViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    
    HLLog(@"top viewDidLoad");
    
    [self setupView];
    
    [self setupDownRefresh];
    
    // 注册通知
    [HLNotificationCenter addObserver:self selector:@selector(clickScrollView:) name:@"clickTopScrollViewNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    // 判断是否已经加载数据
    if (!self.didLoad) {
        // 还没有加载就调用此方法
        [self loadPostData];
        
        // 1.添加刷新控件
        [self.tableView addHeaderWithTarget:self action:@selector(loadPostData)];
    }
    
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 如果didLoad为yes 表示进入top页面，可以下拉刷新
    if (self.didLoad) {
        
        // 2.进入刷新状态
        [self.tableView headerBeginRefreshing];
    }
}
- (void)loadPostData
{
    HLLog(@"TOP View ->>>> loadData");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 2.发送请求
    [HLHttpTool get:HL_TOP_LATEST_POSTS_URL
             params:params success:^(id json) {
                 
                 self.didLoad = YES;
                 
                 HLLog(@"loadPostData=====-->>>>>>");
                 
                 NSArray *latestsUserPosts = [HLStatus objectArrayWithKeyValuesArray:json[@"latestUserPosts"]];
                 NSArray *mostCommentPosts = [HLStatus objectArrayWithKeyValuesArray:json[@"mostCommentsPosts"]];
                 NSArray *mostLikePosts = [HLStatus objectArrayWithKeyValuesArray:json[@"mostLikesPosts"]];
                 
                 //将 HLStatus数组 转为 HLStatusFrame数组
                 NSArray *latestUserPostsFrame = [self topFramesWithPosts:latestsUserPosts];
                 NSArray *mostCommentsFrame = [self topFramesWithPosts:mostCommentPosts];
                 NSArray *mostLikesPostsFrame = [self topFramesWithPosts:mostLikePosts];
                 
                 self.userPostsFrame = latestUserPostsFrame;
                 self.mostCommentsFrame = mostCommentsFrame;
                 self.mostLikeFrame = mostLikesPostsFrame;
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // 刷新表格
                     [self.tableView reloadData];
                 });
                 // 结束刷新(隐藏footer)
                 [self.tableView headerEndRefreshing];
                 
             } failure:^(NSError *error) {
                 HLLog(@"请求失败-%@", error);
                 // 结束刷新(隐藏footer)
                 [self.tableView headerEndRefreshing];
             }];
}

/**
 *  将HLStatus模型转为HLStatusFrame模型
 */
- (NSArray *)topFramesWithPosts:(NSArray *)topPosts
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HLStatus *topPost in topPosts) {
        HLTopPostsFrame *f = [[HLTopPostsFrame alloc] init];
        f.topPosts = topPost;
        [frames addObject:f];
    }
    return frames;
}
/**
 初始化tableview
 */
- (void)setupView{
    self.view.backgroundColor = [UIColor grayColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = CGRectMake (0,0,self.view.frame.size.width,self.view.bounds.size.height-44);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HLColor(239, 239, 239);
    // 设置cell的边框颜色
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    
}

- (void)pushToCommentViewContrller:(HLStatus *) status{
    HLCommentViewContrller *commentVC = [[HLCommentViewContrller alloc] init];
    commentVC.status = status;
    commentVC.title = viewDetailTitle;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - 通知
- (void)clickScrollView:(NSNotification *)oneStatus
{
    // 刷新表格
    [self pushToCommentViewContrller:oneStatus.userInfo[@"status"]];
}
#pragma mark - 实现HLTopPostsCell代理方法
- (void)clickFirstView:(NSString *)URL withTitle:(NSString *)title{
    
    HLTopDetailViewController *topDetail = [[HLTopDetailViewController alloc] init];
    HLLog(@"URL %@" , URL);
    topDetail.sourceURL = URL;
    topDetail.vcTitle = title;
    topDetail.title = title;
    [self.navigationController pushViewController:topDetail animated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HLTopPostsFrame *topPostsFrame = [[HLTopPostsFrame alloc] init];
    
    //HLCommentCell *cell = [HLCommentCell cellWithTableView:tableView];
    
    switch (indexPath.row) {
        case LATEST_USER_POSTS:
        {
            HLLatestUserPostsCell *cell = [HLLatestUserPostsCell cellWithTableView:tableView];
            if (self.userPostsFrame.count > 0) {
                topPostsFrame = self.userPostsFrame[0];
                topPostsFrame.topPostsM = self.userPostsFrame;
                cell.topPostsFrame = topPostsFrame;
                cell.delegate = self;
            }
            
            return cell;
            break;
        }
        case MOST_COMMENTS_POSTS:
        {
            HLTopCommentsPostsCell *cell = [HLTopCommentsPostsCell cellWithTableView:tableView];
            if(self.mostCommentsFrame.count > 0)
            {
                topPostsFrame = self.mostCommentsFrame[0];
                topPostsFrame.topPostsM = self.mostCommentsFrame;
                cell.topPostsFrame = topPostsFrame;
                cell.delegate = self;
            }
            
            return cell;
            break;
        }
        case MOST_LIKES_POSTS:
        {
            
            HLTopLikesPotsCell *cell = [HLTopLikesPotsCell cellWithTableView:tableView];
            if (self.mostLikeFrame.count > 0) {
                topPostsFrame = self.mostLikeFrame[0];
                topPostsFrame.topPostsM = self.mostLikeFrame;
                cell.topPostsFrame = topPostsFrame;
                cell.delegate = self;
            }
            
            return cell;
            break;
        }
        default:
            break;
    }
    return  NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case LATEST_USER_POSTS:
        {
            if (self.userPostsFrame.count > 0) {
                HLTopPostsFrame *topPostsFrame = self.userPostsFrame[0];
                return topPostsFrame.cellHeight;
            }
            
            return 0;
            break;
        }
        case MOST_COMMENTS_POSTS:
        {
            if (self.mostCommentsFrame.count > 0) {
                HLTopPostsFrame *topPostsFrame = self.mostCommentsFrame[0];
                return topPostsFrame.cellHeight;
            }
            return 0;
            break;
        }
        case MOST_LIKES_POSTS:
        {
            if (self.mostLikeFrame.count > 0) {
                HLTopPostsFrame *topPostsFrame = self.mostLikeFrame[0];
                return topPostsFrame.cellHeight;
            }
            return 0;
            break;
        }
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    HWLog(@"didSelectRowAtIndexPath---%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

- (void)dealloc
{
    [HLNotificationCenter removeObserver:self];
}
@end