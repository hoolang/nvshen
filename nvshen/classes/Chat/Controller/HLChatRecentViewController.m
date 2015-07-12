//
//  HLChatRecentViewController.m
//  nvshen
//
//  Created by hoolang on 15/7/6.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLChatRecentViewController.h"
#import "HLChatsTool.h"
#import "HLUser.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Circle.h"
#import "HLChatsTool.h"
#import "HLChatViewController.h"
#import "HLChatListSubscriptionsViewController.h"

#define SUBSCRIPTIONS @"新朋友"

@interface HLChatRecentViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *chatsFrames;
@property (nonatomic, strong) NSArray *subscriptionsFrames;
@end

@implementation HLChatRecentViewController

- (NSMutableArray *)chatsFrames
{
    if (!_chatsFrames) {
        self.chatsFrames = [NSMutableArray array];
    }
    return _chatsFrames;
}
- (NSArray *)subscriptionsFrames
{
    if (!_subscriptionsFrames) {
        self.subscriptionsFrames = [NSArray array];
    }
    return _subscriptionsFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载视图
    [self setupView];
    // 加载数据
    [self loadDataSources];
}

- (void)viewWillAppear:(BOOL)animated
{
    HLLog(@"%s ", __func__);
}


/**
 初始化tableview
 */
- (void)setupView{
    self.view.backgroundColor = [UIColor grayColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = CGRectMake (0,69,self.view.frame.size.width,self.view.bounds.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HLColor(239, 239, 239);
    // 设置cell的边框颜色
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
}

/**
 *  加载数据
 */
- (void)loadDataSources
{

//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = account.access_token;
    
    //定义一个block处理返回的字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *users){

        [self.chatsFrames removeAllObjects];
        
        // 将最新的联系人数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, users.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.chatsFrames insertObjects:users atIndexes:set];
        
        // 好友请求个数
        [self subscriptions];
        
        // 实现代理
        if ([self.delegate respondsToSelector:@selector(chatRecentRefreshMainViewBadge)]) {
            [self.delegate chatRecentRefreshMainViewBadge];
        }
        
        // 回到主线程刷新表格
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    };
    
    // 2.从数据库中加载最近联系人数据
    //NSArray *users = [HLChatsTool chatsWithParams:params];
    NSArray *users = [HLChatsTool loadMessages];
    
    HLLog(@"%s user.count:%ld", __func__, users.count);
    

    dealingResult(users);
    
    
}

/**
 *  好友请求个数
 */
- (void)subscriptions
{
    HLLog(@"%s", __func__);
    
    // 获取待处理好友请求个数
    NSArray *array = [HLChatsTool newSubscriptions];
    
    if (array.count > 0) {
        HLUser *user = [[HLUser alloc] init];
        
        user.uid = SUBSCRIPTIONS;
        user.text = [NSString stringWithFormat:@"有%ld人请求加为好友", array.count];
        
        NSArray *newArray = [NSArray arrayWithObjects:user, nil];
        
        // 添加到总数组的最前面
        NSRange range = NSMakeRange(0, newArray.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.chatsFrames insertObjects:newArray atIndexes:set];
        
        //[self.tableView reloadData];
    }
}

#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HLLog(@"self.chatsFrames.count %ld", self.chatsFrames.count);
    return self.chatsFrames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"RecentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    HLUser *user = self.chatsFrames[indexPath.row];
    
    if ([user.uid isEqualToString:SUBSCRIPTIONS]) {

        cell.imageView.image = [[UIImage imageNamed:@"avatar_default_small"] clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
        cell.textLabel.text = user.uid;
        cell.detailTextLabel.text = user.text;
    }
    else{
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USER_ICON_URL,user.icon]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] ];
        
        cell.imageView.image = [imageV.image clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
        cell.textLabel.text = user.nickname;
        // user.email 表status：未读
        // user.sex 未读数
        // user.text 消息内容
        HLLog(@"%s", __func__);
        HLLog(@"user.text %@", user.text);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", user.text];
    }
    
    return cell;
}
/**
 *  选中某行
 *
 *  @param tableView 
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLUser *user = self.chatsFrames[indexPath.row];
    
    if([user.uid isEqualToString:SUBSCRIPTIONS]){
        HLChatListSubscriptionsViewController *dealVC = [[HLChatListSubscriptionsViewController alloc] init];
        dealVC.title = @"新朋友";
        // 代理方法
        if ([self.delegate respondsToSelector:@selector(pushRecentToChatView:)]) {
            [self.delegate pushRecentToChatView:dealVC];
        }
        return;
    }
    
    HLChatViewController *chatView = [[HLChatViewController alloc] init];
    // 设置聊天对象的头像
    chatView.photo = [self tableView:tableView cellForRowAtIndexPath:indexPath].imageView.image;
    // 设置聊天对象的jid
    chatView.friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", user.username,domain]];
    // 设置控制器标题
    chatView.title = user.nickname;
    
    // 代理方法
    if ([self.delegate respondsToSelector:@selector(pushRecentToChatView:)]) {
        [self.delegate pushRecentToChatView:chatView];
    }
    // 更新消息状态为已读
    [HLChatsTool updateMessage:user.username];

}

//cell往左滑就会有个delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HLUser *user = self.chatsFrames[indexPath.row];
        
        if([user.uid isEqualToString:SUBSCRIPTIONS]){
            // 拒绝好友请求信息
            [HLChatsTool updateSubscriptionsStatus:@"已拒绝"];
            [self.chatsFrames removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
        else{
            // 删除最近联系人信息
            [HLChatsTool deleteMessage:user.username];
            [self.chatsFrames removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

#pragma mark -其他
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)dealloc
{
    HLLog(@"%s", __func__);
}
@end
