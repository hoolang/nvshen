//
//  HLChatDealSubscriptionsViewController.m
//  nvshen
//
//  Created by hoolang on 15/7/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLChatListSubscriptionsViewController.h"
#import "HLChatsTool.h"
#import "HLUser.h"
#import "UIImage+Circle.h"
#import "UIImageView+WebCache.h"
#import "HLChatDealSubscribeViewController.h"
#import "HLHttpTool.h"
#import "HLChatsTool.h"
#import "HLProfile.h"
#import "MJExtension.h"
#import "HLProfileViewController.h"

@interface HLChatListSubscriptionsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
HLChatDealSubscribeDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *subscriptionsFrames;
@end

@implementation HLChatListSubscriptionsViewController

- (NSMutableArray *)subscriptionsFrames
{
    if (!_subscriptionsFrames) {
        self.subscriptionsFrames = [NSMutableArray array];
    }
    return _subscriptionsFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tableview
    [self setupView];
    // 加载数据
    [self loadDataSources];
}

/**
 初始化tableview
 */
- (void)setupView{
    self.view.backgroundColor = [UIColor grayColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = CGRectMake (0, 0, self.view.frame.size.width, self.view.bounds.size.height);
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
    HLLog(@"%s", __func__);
    // 定义一个block处理返回的字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *users){

        [self.subscriptionsFrames removeAllObjects];
        NSRange range = NSMakeRange(0, users.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.subscriptionsFrames insertObjects:users atIndexes:set];

        // 刷新表格
        [self.tableView reloadData];
        
    };
    
    // 2.尝试从数据库中加载最近联系人数据
    NSArray *users = [HLChatsTool subscriptionWithParams:nil];
    
    HLLog(@"user.count %ld", users.count);
    
    dealingResult(users);
}
/**
 *  接收请求
 *
 *  @param jid
 */
- (void)doAgree:(UIButton *)sender
{
    HLUser *user = _subscriptionsFrames[sender.tag];
    [self dealSubscriptionUsername:user.username Flag:YES];
    [HLChatsTool updateSubscriptionFromUsername:user.username Status:@"已同意"];
    
    user.text = @"已同意";
    
    self.subscriptionsFrames[sender.tag] = user;
    
    [self.tableView reloadData];
}

/**
 *  处理好友请求
 *
 *  @param flag
 */
- (void)dealSubscriptionUsername:(NSString *)username Flag:(BOOL)flag
{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", username, domain]];
    
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.username"] = username;
    
    // 2.发送请求
    [HLHttpTool get:HL_ONE_USER_URL params:params success:^(id json) {
        
        // 将 "字典"数组 转为 "模型"数组
        NSArray *userInfo = [HLProfile objectArrayWithKeyValuesArray:json[@"userinfo"]];
        // 如果数据库中有该用户则允许接收该好友请求
        if (userInfo.count > 0) {
            [[HLXMPPTool sharedHLXMPPTool].roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:flag];
        }
        
    } failure:^(NSError *error) {
        HLLog(@"请求失败-%@", error);
    }];
    
}
#pragma mark -HLChatDealSubscribeDelegate
- (void)changeStatus:(NSString *)status withTag:(NSInteger)tag
{
    HLUser *user = _subscriptionsFrames[tag];
    [self dealSubscriptionUsername:user.username Flag:YES];
    [HLChatsTool updateSubscriptionFromUsername:user.username Status:status];
    
    user.text = status;
    
    self.subscriptionsFrames[tag] = user;
    
    [self.tableView reloadData];
    
}

#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HLLog(@"self.subscriptionsFrames.count %ld", self.subscriptionsFrames.count);
    return self.subscriptionsFrames.count;
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
    
    HLUser *user = self.subscriptionsFrames[indexPath.row];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USER_ICON_URL,user.icon]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] ];

    cell.imageView.image = [imageV.image clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
    cell.textLabel.text = user.nickname;
    cell.detailTextLabel.text = @"请求加为好友";
    
    // 同意按钮
    UIButton *agreeBtn = [[UIButton alloc] init];
    [agreeBtn setTag:indexPath.row];
    [agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [agreeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [agreeBtn setBackgroundColor:HLColor(249, 249, 249)];
    [agreeBtn addTarget:self action:@selector(doAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([user.text isEqualToString:@"未处理"]){
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    }else
    {
        [agreeBtn setTitle:user.text forState:UIControlStateNormal];
        agreeBtn.enabled = NO;
    }

    CGFloat width = 44;
    CGFloat height = 24;
    CGFloat y = ([self tableView:tableView heightForRowAtIndexPath:indexPath] - height) * 0.5;
    
    agreeBtn.frame = CGRectMake(ScreenWidth - width - 5, y, width, height);
    
    [cell addSubview:agreeBtn];
    HLLog(@"cell.imageView.size.width: %f cell.textLabel： %f", cell.imageView.size.width, cell.textLabel.size.width);
    if(indexPath.row != 0){
        // 线条
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(cell.imageView.size.width, 0, ScreenWidth - cell.imageView.size.width, 0.5)];
        [lable setBackgroundColor:HLColor(100, 100, 100)];
        //[cell addSubview:lable];
        
        [cell insertSubview:lable belowSubview:cell.imageView];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HLUser *user = self.subscriptionsFrames[indexPath.row];
    
    if (![user.text isEqualToString:@"未处理"]){
        // 跳转到查看改好友的个人资料
        HLProfileViewController *profile = [[HLProfileViewController alloc] init];
        profile.username = user.username;
        profile.title = [NSString stringWithFormat:@"%@的资料", user.username];
        [self.navigationController pushViewController:profile animated:YES];
    }
    else
    {
        // 处理好友申请
        HLChatDealSubscribeViewController *dealVC = [[HLChatDealSubscribeViewController alloc] init];
        dealVC.title = @"好友申请";
        dealVC.user = user;
        dealVC.delegate = self;
        dealVC.tag = indexPath.row;
        [self.navigationController pushViewController:dealVC animated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
