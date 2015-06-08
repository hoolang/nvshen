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
#import "HLTopPosts.h"
#import "HLTopCommentsPostsCell.h"
#import "HLTopLikesPotsCell.h"
#import "HLLatestUserPostsCell.h"
#import "HLTopDetailViewController.h"

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
@property (nonatomic, assign) BOOL isReady;

@end


@implementation HLTopViewController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] init];
    }
    return _tableView;
}
- (NSArray *)userPostsFrame
{
    if (!_userPostsFrame) {
        self.userPostsFrame = [NSArray array];
    }
    return _userPostsFrame;
}
- (NSArray *)mostCommentsFrame
{
    if (!_mostCommentsFrame) {
        self.mostCommentsFrame = [NSArray array];
    }
    return _mostCommentsFrame;
}
- (NSArray *)mostLikeFrame
{
    if (!_mostLikeFrame) {
        self.mostLikeFrame = [NSArray array];
    }
    return _mostLikeFrame;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    [self setupView];
    
    [self setupDownRefresh];
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    //    [self.tableView addHeaderWithTarget:self action:@selector(loadPostData)];
    [self loadPostData];
    // 2.进入刷新状态
    [self.tableView headerBeginRefreshing];
}
- (void)loadPostData
{
    HLLog(@"TOP View ->>>> loadData");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = @1;
    
    // 2.发送请求
    [HLHttpTool get:HL_TOP_LATEST_POSTS_URL
             params:params success:^(id json) {
                 HLLog(@"loadPostData=====-->>>>>>");
                 
                 NSArray *latestsUserPosts = [HLTopPosts objectArrayWithKeyValuesArray:json[@"latestUserPosts"]];
                 NSArray *mostCommentPosts = [HLTopPosts objectArrayWithKeyValuesArray:json[@"mostCommentsPosts"]];
                 NSArray *mostLikePosts = [HLTopPosts objectArrayWithKeyValuesArray:json[@"mostLikesPosts"]];
                 
                 //将 HWStatus数组 转为 HWStatusFrame数组
                 NSArray *latestUserPostsFrame = [self topFramesWithPosts:latestsUserPosts];
                 NSArray *mostCommentsFrame = [self topFramesWithPosts:mostCommentPosts];
                 NSArray *mostLikesPostsFrame = [self topFramesWithPosts:mostLikePosts];
                 
                 self.userPostsFrame = latestUserPostsFrame;
                 self.mostCommentsFrame = mostCommentsFrame;
                 self.mostLikeFrame = mostLikesPostsFrame;
                 
                 HLTopPostsFrame *topPostsFrame = self.mostCommentsFrame[0];
                 HLTopPosts *topPosts = topPostsFrame.topPosts;
                 HLLog(@"========load topPosts.posts.photo %@", topPosts.posts.photo);
                 
                 //HLLog(@"HLTOPVIEW %@", json);
                 // 刷新表格
                 [self.tableView reloadData];
                 
             } failure:^(NSError *error) {
                 HLLog(@"请求失败-%@", error);
             }];
}

/**
 *  将HLStatus模型转为HLStatusFrame模型
 */
- (NSArray *)topFramesWithPosts:(NSArray *)topPosts
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HLTopPosts *topPost in topPosts) {
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
            topPostsFrame = self.userPostsFrame[0];
            topPostsFrame.topPostsM = self.userPostsFrame;
            
            HLLatestUserPostsCell *cell = [HLLatestUserPostsCell cellWithTableView:tableView];
            cell.topPostsFrame = topPostsFrame;
            cell.delegate = self;
            return cell;
            break;
        }
        case MOST_COMMENTS_POSTS:
        {
            HLTopCommentsPostsCell *cell = [HLTopCommentsPostsCell cellWithTableView:tableView];
            topPostsFrame = self.mostCommentsFrame[0];
            topPostsFrame.topPostsM = self.mostCommentsFrame;
            cell.topPostsFrame = topPostsFrame;
            cell.delegate = self;
            return cell;
            break;
        }
        case MOST_LIKES_POSTS:
        {
            topPostsFrame = self.mostLikeFrame[0];
            topPostsFrame.topPostsM = self.mostLikeFrame;
            
            HLTopLikesPotsCell *cell = [HLTopLikesPotsCell cellWithTableView:tableView];
            cell.topPostsFrame = topPostsFrame;
            cell.delegate = self;
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
    HLTopPostsFrame *topPostsFrame = self.mostCommentsFrame[0];
    return topPostsFrame.cellHeight;
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