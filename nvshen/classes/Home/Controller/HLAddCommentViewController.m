//
//  HLAddCommentViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/30.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLAddCommentViewController.h"
#import "HLEmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HLStatusFrame.h"
#import "HLStatus.h"
#import "HLPosts.h"
#import "HLUser.h"
#import "HLCommentCell.h"
#import "HLCommentView.h"
#import "HLHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface HLAddCommentViewController ()
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;
@property (nonatomic, weak) UIView *commentView;
/**
*  show数组（里面放的都是HLStatusFrame模型，一个HLStatusFrame对象就代表一条show）
*/
@property (nonatomic, strong) NSMutableArray *commentsFrames;
@end

@implementation HLAddCommentViewController

- (NSMutableArray *)commentsFrames
{
    if (!_commentsFrames) {
        self.commentsFrames = [NSMutableArray array];
    }
    return _commentsFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    //[self setNav];
    
    HLCommentView *commentView = [[HLCommentView alloc] init];
    self.commentView = commentView;

    HLStatusFrame *statusF = [[HLStatusFrame alloc] init];

    statusF.status = _status;

    commentView.statusFrame = statusF;
    
    
    CGFloat width = commentView.frame.size.width;
    CGFloat height = commentView.frame.size.height;

    commentView.frame = CGRectMake(0, -statusF.cellHeight, width, height);

    self.tableView.contentInset = UIEdgeInsetsMake(statusF.cellHeight, 0, 0, 0);
    [self.tableView insertSubview:self.commentView atIndex:0];
    // 注册通知
    
    // 集成上拉刷新控件
    //[self setupDownRefresh];
    [HLNotificationCenter addObserver:self selector:@selector(changelikeStatus:) name:@"addLikeInCommentViewNotification" object:nil];
    
}
/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadComments)];
    
    // 2.进入刷新状态
    [self.tableView headerBeginRefreshing];
}
- (void)loadComments{
    
    HLLog(@"loadMoreComments->>>");
    // 1.拼接请求参数

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"pid"] = _status.posts.pid;
    // 取出最后面的评论（最新的评论，ID最大的评论）
    HLCommentsFrame *lastCommentF = [self.commentsFrames lastObject];
    if (lastCommentF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        
        long long minId = lastCommentF.comments.cid.longLongValue;
        params[@"minid"] = @(minId);
        HLLog(@"params[@minid] %@",params[@"maxid"]);
    }
    
    // 2.发送请求
    [HLHttpTool get:HL_LOAD_COMMENT params:params success:^(id json) {
        // 将 "评论字典"数组 转为 "评论模型"数组
        NSArray *newComments = [HLComments objectArrayWithKeyValuesArray:json[@"comments"]];
        
        // 将 HLComments数组 转为 HLCommentsFrame数组
        NSArray *newFrames = [self commentsFramesWithStatuses:newComments];
        
        // 将更多的评论数据，添加到总数组的最后面
        [self.commentsFrames addObjectsFromArray:newFrames];
        
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
/**
 *  将HLStatus模型转为HLStatusFrame模型
 */
- (NSArray *)commentsFramesWithStatuses:(NSArray *)comments
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HLComments *comment in comments) {
        HLCommentsFrame *f = [[HLCommentsFrame alloc] init];
        f.comments = comment;
        [frames addObject:f];
    }
    return frames;
}

- (void)setNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(doComment)];
    self.view.backgroundColor = HLColor(239, 239, 239);
    HLLog(@"pid %@",self.pid);
    HLEmotionTextView *textView = [[HLEmotionTextView alloc] init];
    // 垂直方向上可以拖拽
    textView.alwaysBounceVertical = YES;
    CGFloat screen = [UIScreen mainScreen].bounds.size.width;
    
    textView.frame = CGRectMake(0, 0, screen ,160);
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    textView.placeholder = @"秀一秀我的态度2";
    [textView becomeFirstResponder];
    
    HLLog(@"self.textView.text%@",textView.text);
    
    self.textView = textView;
    
    //[self.view addSubview:textView];
}
#pragma mark - 点赞之后重新加载数据
- (void)changelikeStatus:(NSNotification *)like{
//    NSLog(@"pid: %@",like.userInfo[@"pid"]);
//    
//    for( int i=0; i< self.statusFrames.count; i++){
//        HLStatusFrame *statusFrames = self.statusFrames[i];
//        
//        if(statusFrames.status.posts.pid == like.userInfo[@"pid"]){
//            if([like.userInfo[@"response"][@"status"] isEqualToString:@"cancel"]){
//                statusFrames.status.likes_count -= 1;
//            }else if([like.userInfo[@"response"][@"status"] isEqualToString:@"done"]){
//                statusFrames.status.likes_count += 1;
//            }
//        }
//    }
//    [self.tableView reloadData];
}
- (void)doComment{
    // 1.请求管理者
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"access_token"] = [HWAccountTool account].access_token;
    params[@"comments.content"] = self.textView.text;
    params[@"user.uid"] = @1;
    params[@"post.pid"] = _pid;
    
    
    // 3.发送请求
    [mgr POST:HL_ADD_COMMENT parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
//        UIImage *image = _image;
//        //
//        NSData *data = UIImageJPEGRepresentation(image, 0.6);
//        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_pid, @"pid", nil];
        
        NSNotification *notification =[NSNotification notificationWithName:@"DoneCommentNotification" object:nil userInfo:dict];
        //通过通知中心发送通知
        [HLNotificationCenter postNotification:notification];
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常，请稍后再试！"];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    HLCommentCell *cell = [HLCommentCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.commentsFrame = self.commentsFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLCommentsFrame *frame = self.commentsFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    HWLog(@"didSelectRowAtIndexPath---%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}
@end
