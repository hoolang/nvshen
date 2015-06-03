//
//  HLCommentViewContrller.m
//  nvshen
//
//  Created by hoolang on 15/6/2.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLCommentViewContrller.h"
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
#import "HLComposeToolbar.h"
#import "HLEmotionKeyboard.h"
@interface HLCommentViewContrller()
<
UITextViewDelegate,
HLComposeToolbarDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;
/** show展示 */
@property (nonatomic, weak) UIView *commentView;
/** 键盘顶部的工具条 */
@property (nonatomic, strong) HLComposeToolbar *toolbar;
#warning 一定要用strong
/** 表情键盘 */
@property (nonatomic, strong) HLEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
/**
 *  show数组（里面放的都是HLStatusFrame模型，一个HLStatusFrame对象就代表一条show）
 */
@property (nonatomic, strong) NSMutableArray *commentsFrames;

@end


@implementation HLCommentViewContrller
#pragma mark - 懒加载
- (HLEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[HLEmotionKeyboard alloc] init];
        // 键盘的宽度
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)commentsFrames
{
    if (!_commentsFrames) {
        self.commentsFrames = [NSMutableArray array];
    }
    return _commentsFrames;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    // 初始化tableView
    [self setupView];
    //设置导航栏
    [self setNav];
    
    // 设置Show的显示
    [self setupShow];
    
    // 集成下拉刷新控件
    //[self setupDownRefresh];
    
    [self loadNewComments];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    // 添加工具条
    [self setupToolbar];
    
    // 注册通知
    [HLNotificationCenter addObserver:self selector:@selector(changelikeStatus:) name:@"addLikeInCommentViewNotification" object:nil];
    
    // 文字改变的通知
    //[HLNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.toolbar.textView];
    

    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [HLNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 表情选中的通知
    [HLNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:HLEmotionDidSelectNotification object:nil];
    
    // 删除文字的通知
    [HLNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HLEmotionDidDeleteNotification object:nil];
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
    [self.view addSubview:_tableView];
}

/**
  *  设置Show
  */
- (void)setupShow{
    HLCommentView *topView = [[HLCommentView alloc] init];
    HLStatusFrame *statusF = [[HLStatusFrame alloc] init];
    
    statusF.status = _status;
    topView.statusFrame = statusF;
    
    // show的宽度
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    // 设置frame
    topView.frame = CGRectMake(0, -statusF.cellHeight, width, statusF.cellHeight);
    
    self.commentView = topView;
    // 设置table距离顶部的距离
    self.tableView.contentInset = UIEdgeInsetsMake(statusF.cellHeight, 0, 0, 0);
    // 把commentView添加到顶部
    [self.tableView insertSubview:self.commentView atIndex:0];
}
/**
 * 添加工具条
 */
- (void)setupToolbar
{
    HLComposeToolbar *toolbar = [[HLComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;

}
/**
 集成上拉刷新控件
 */
- (void)setupUpRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreComments)];
}
/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewComments)];
    
    // 2.进入刷新状态
    [self.tableView headerBeginRefreshing];
}

#pragma mark -加载最新评论
- (void)loadNewComments{
    HLLog(@"loadNewComments->>");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pid"] = _status.posts.pid;
    HLCommentsFrame *firstCommentF = [self.commentsFrames firstObject];
    
    if (firstCommentF) {
        // 若指定此参数，则返回ID比maxid大的show（即比maxid时间晚的show），默认为0
        params[@"maxid"] = firstCommentF.comments.cid;
        HLLog(@"params[@maxid] %@",params[@"maxid"]);
    }
    
    // 2.发送请求
    [HLHttpTool get:HL_LATEST_COMMENT_URL
             params:params success:^(id json) {
                 // 将 "show（posts）字典"数组 转为 "show模型"数组
                 NSArray *newComments = [HLComments objectArrayWithKeyValuesArray:json[@"comments"]];
                 
                 
                 // 将 HWStatus数组 转为 HWStatusFrame数组
                 NSArray *newFrames = [self commentsFramesWithComments:newComments];
                 
                 // 将最新的评论数据，添加到总数组的最前面
                 NSRange range = NSMakeRange(0, newFrames.count);
                 NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
                 [self.commentsFrames insertObjects:newFrames atIndexes:set];
                 
                 // 刷新表格
                 [self.tableView reloadData];
                 
                 // 结束刷新
                 [self.tableView headerEndRefreshing];
                 
                 // 显示最新评论的数量
                 //[self showNewStatusCount:newComments.count];
                 HLLog(@"%@", json);
             } failure:^(NSError *error) {
                 HLLog(@"请求失败-%@", error);
                 
                 // 结束刷新刷新
                 [self.tableView headerEndRefreshing];
             }];
    
}
#pragma mark -加载更多评论
- (void)loadMoreComments{
    
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
    [HLHttpTool get:HL_OLDER_COMMENT_URL params:params success:^(id json) {
        // 将 "评论字典"数组 转为 "评论模型"数组
        NSArray *newComments = [HLComments objectArrayWithKeyValuesArray:json[@"comments"]];
        
        // 将 HLComments数组 转为 HLCommentsFrame数组
        NSArray *newFrames = [self commentsFramesWithComments:newComments];
        
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
- (NSArray *)commentsFramesWithComments:(NSArray *)comments
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
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(doComment)];
    //self.view.backgroundColor = HLColor(239, 239, 239);
    
//    HLEmotionTextView *textView = [[HLEmotionTextView alloc] init];
//    // 垂直方向上可以拖拽
//    textView.alwaysBounceVertical = YES;
//    CGFloat screen = [UIScreen mainScreen].bounds.size.width;
//    
//    textView.frame = CGRectMake(0, 0, screen ,360);
//    textView.font = [UIFont systemFontOfSize:13];
//    textView.delegate = self;
//    textView.placeholder = @"秀一秀我的态度2";
//    [textView becomeFirstResponder];
//    
//    HLLog(@"self.textView.text%@",textView.text);
    
    //self.textView = textView;
    
    //[self.view addSubview:textView];
}
#pragma mark - 点赞之后重新加载数据
- (void)changelikeStatus:(NSNotification *)like{
    NSLog(@"pid: %@",like.userInfo[@"pid"]);
    
    if([like.userInfo[@"response"][@"status"] isEqualToString:@"cancel"]){
        NSLog(@"cancel: %@",like.userInfo[@"pid"]);
        _status.likes_count -= 1;
    }else if([like.userInfo[@"response"][@"status"] isEqualToString:@"done"]){
        NSLog(@"done: %@",like.userInfo[@"pid"]);
        _status.likes_count += 1;
    }
    
    [self.view setNeedsDisplay];
}
- (void)sendComment{
    // 1.请求管理者
    HLLog(@"sendComment");
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"access_token"] = [HWAccountTool account].access_token;
    params[@"comments.comment"] = self.toolbar.textView.text;
    params[@"user.uid"] = @2;
    params[@"post.pid"] = _status.posts.pid;
    
    HLLog(@"self.toolbar.textView.text %@", self.toolbar.textView.text);
    // 3.发送请求
    [mgr POST:HL_ADD_COMMENT parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        //        UIImage *image = _image;
        //        //
        //        NSData *data = UIImageJPEGRepresentation(image, 0.6);
        //        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_status.posts.pid, @"pid", nil];
        
        NSNotification *notification =[NSNotification notificationWithName:@"DoneCommentNotification" object:nil userInfo:dict];
        //通过通知中心发送通知
        [HLNotificationCenter postNotification:notification];
        self.toolbar.textView.text = nil;
        [self.toolbar.textView resignFirstResponder];
        
        
//        HLCommentsFrame *newCommentF = [[HLCommentsFrame alloc] init];
//        newCommentF.comments.ci
//        // 将刚刚添加的评论数据，添加到总数组的最前面
//        NSRange range = NSMakeRange(0, _commentsFrames.count);
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.commentsFrames insertObjects:_commentsFrames atIndexes:set];
//        
//        // 刷新表格
//        [self.tableView reloadData];
        
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
    [self.toolbar.textView deleteBackward];
}
/**
 *  表情被选中了
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    HLEmotion *emotion = notification.userInfo[HLSelectEmotionKey];
    [self.toolbar.textView insertEmotion:emotion];
}

/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
    HLLog(@"keyboardWillChangeFrame");
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - HLComposeToolbarDelegate
- (void)composeToolbar:(HLComposeToolbar *)toolbar didClickButton:(HLComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case HLComposeToolbarTypeSend:
            HLLog(@"发送");
            [self sendComment];
            break;
            
        case HLComposeToolbarTypeEmotion: // 表情\键盘
            HLLog(@"表情键盘");
            [self switchKeyboard];
            break;
            
        case HLComposeToolbarTypeMention: // @
            HLLog(@"--- @");
            break;
            
        case HLComposeToolbarTypeTrend: // #
            HLLog(@"--- #");
            break;
    }
}
/**
 *  刷新ToolBar的y值
 */
- (void)composeToolbar:(HLComposeToolbar *)toolbar refreshToolbarFrame:(CGFloat)difference{
        HLLog(@"_toolbar.y %f",_toolbar.y);
        _toolbar.y =  _toolbar.y - difference;
        
}
#pragma mark - 其他方法
/**
 *  切换键盘
 */
- (void)switchKeyboard
{
    // self.textView.inputView == nil : 使用的是系统自带的键盘
    if (self.toolbar.textView.inputView == nil) { // 切换为自定义的表情键盘
        self.toolbar.textView.inputView = self.emotionKeyboard;
        
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.toolbar.textView.inputView = nil;
        
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    // 开始切换键盘
    self.switchingKeybaord = YES;
    
    // 退出键盘
    [self.toolbar.textView endEditing:YES];
    
    // 结束切换键盘
    self.switchingKeybaord = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.toolbar.textView becomeFirstResponder];
    });
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
    
    
    HLLog(@"cell.commentsFrame %@",cell.commentsFrame);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLLog(@"indexPath.row======%ld",indexPath.row);
    HLCommentsFrame *frame = self.commentsFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    HWLog(@"didSelectRowAtIndexPath---%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

- (void)dealloc
{
    HLLog(@"HLCommentViewContrller dealloc");
    [HLNotificationCenter removeObserver:self];
}
@end
