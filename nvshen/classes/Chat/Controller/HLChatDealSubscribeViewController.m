//
//  HLChatDealSubscribeViewController.m
//  nvshen
//
//  Created by hoolang on 15/7/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLChatDealSubscribeViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Circle.h"
#import "HLChatsTool.h"
#import "HLHttpTool.h"
#import "HLProfile.h"
#import "MJExtension.h"
#import "HLProfileViewController.h"

@interface HLChatDealSubscribeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *subscriptionsFrames;
@end

@implementation HLChatDealSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化tableview
    [self setupView];
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
#pragma mark - 处理好友请求
/**
 *  拒绝请求
 *
 *  @param jid
 */
- (void)doRefuse
{
    [self dealSubscription:NO];
    [HLChatsTool updateSubscriptionFromUsername:_user.username Status:@"已拒绝"];
    if ([self.delegate respondsToSelector:@selector(changeStatus:withTag:)]) {
        [self.delegate changeStatus:@"已拒绝" withTag:_tag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  接收请求
 *
 *  @param jid
 */
- (void)doAgree
{
    [self dealSubscription:YES];
    [HLChatsTool updateSubscriptionFromUsername:_user.username Status:@"已同意"];
    if ([self.delegate respondsToSelector:@selector(changeStatus:withTag:)]) {
        [self.delegate changeStatus:@"已同意" withTag:_tag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  处理好友请求
 *
 *  @param flag
 */
- (void)dealSubscription:(BOOL)flag
{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _user.username, domain]];
    
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.username"] = _user.username;
    
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

#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HLLog(@"self.subscriptionsFrames.count %ld", self.subscriptionsFrames.count);
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 54;
    }
    if (indexPath.row == 1) {
        return 34;
    }
    return ScreenHeight - 34 - 54 - 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"RecentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0){
        UIImageView *imageV = [[UIImageView alloc] init];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USER_ICON_URL,_user.icon]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] ];
        
        cell.imageView.image = [imageV.image clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
        cell.textLabel.text = _user.nickname;
        cell.detailTextLabel.text = @"请求加为好友";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // 附加信息
    if (indexPath.row == 1) {
        
        // 附加信息标题
        UILabel *label = [[UILabel alloc] init];
        label.text = @"附加信息";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        
        CGSize size =  [label.text sizeWithFont:[UIFont systemFontOfSize:13]];
        
        //CGFloat defaultWidth = (ScreenWidth - 100 - 20);
        CGFloat width = size.width ;
        //CGFloat height = size.height;
        
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        label.frame = CGRectMake(10, 0, width, height);
        
        [cell addSubview:label];
        
        // 附加信息内容
        UILabel *text = [[UILabel alloc] init];
        text.text = @"请求加为好友";
        text.textColor = [UIColor blackColor];
        text.font = [UIFont systemFontOfSize:13];
        
        CGSize textSize =  [text.text sizeWithFont:[UIFont systemFontOfSize:13]];
        text.frame = CGRectMake(CGRectGetMaxX(label.frame) + 30, 0, textSize.width, height);
        [cell addSubview:text];
        
        // 线条
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(cell.imageView.size.width, 0, ScreenWidth - cell.imageView.size.width, 0.5)];
        [line setBackgroundColor:HLColor(239, 239, 239)];
        //[cell addSubview:lable];
    
        [cell insertSubview:line belowSubview:cell.imageView];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (indexPath.row == 2) {
        
        // 拒绝按钮
        UIButton *refuseBtn = [[UIButton alloc] init];
        [refuseBtn setTag:indexPath.row];
        [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [refuseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [refuseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [refuseBtn setBackgroundColor:HLColor(249, 249, 249)];
        [refuseBtn addTarget:self action:@selector(doRefuse) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat x = 10;
        CGFloat y = 30;
        CGFloat width = (ScreenWidth - 3 * x) * 0.5;
        CGFloat height = 34;
        [refuseBtn setFrame:CGRectMake(x, y, width, height)];
        [cell addSubview:refuseBtn];
        
        // 同意按钮
        UIButton *agreeBtn = [[UIButton alloc] init];
        [agreeBtn setTag:indexPath.row];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn setBackgroundColor:[UIColor orangeColor]];
        [agreeBtn addTarget:self action:@selector(doAgree) forControlEvents:UIControlEventTouchUpInside];
        
        agreeBtn.frame = CGRectMake(CGRectGetMaxX(refuseBtn.frame) + x, y, width, height);
        
        [cell addSubview:agreeBtn];
        cell.backgroundColor = HLColor(239, 239, 239);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 跳转到查看改好友的个人资料
        HLProfileViewController *profile = [[HLProfileViewController alloc] init];
        profile.username = _user.username;
        profile.title = [NSString stringWithFormat:@"%@的资料", _user.username];
        [self.navigationController pushViewController:profile animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
