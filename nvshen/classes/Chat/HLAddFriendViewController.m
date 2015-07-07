//
//  HLAddContactViewController.m
//
//  Created by apple on 14/12/9.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import "HLAddFriendViewController.h"
#import "HLHttpTool.h"

@interface HLAddFriendViewController()
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HLAddFriendViewController

- (void)viewDidLoad{
    
    // 初始化tableview
    [self setupView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 44)];
    textField.delegate = self;
    [self.tableView.tableHeaderView addSubview:textField];
    self.textField = textField;
    self.textField.returnKeyType = UIReturnKeySearch;
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
/** 加载数据 */
- (void)loadSource
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    HLStatusFrame *firstStatusF = [self.statusFrames firstObject];
//    if (firstStatusF) {
//        // 若指定此参数，则返回ID比maxid大的show（即比maxid时间晚的show），默认为0
//        params[@"maxid"] = firstStatusF.status.posts.pid;
//        HLLog(@"params[@maxid] %@",params[@"maxid"]);
//    }
//    // 2.发送请求
//    [HLHttpTool get:HL_LATEST_POSTS_URL
//             params:params success:^(id json) {
//                 // 将 "show（posts）字典"数组 转为 "微博模型"数组
//                 NSArray *newStatuses = [HLStatus objectArrayWithKeyValuesArray:json[@"status"]];
//                 
//                 // 将 HLStatus数组 转为 HWStatusFrame数组
//                 NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
//                 
//                 // 将最新的微博数据，添加到总数组的最前面
//                 NSRange range = NSMakeRange(0, newFrames.count);
//                 NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//                 [self.statusFrames insertObjects:newFrames atIndexes:set];
//                 
//                 // 刷新表格
//                 [self.tableView reloadData];
//                 
//                 // 结束刷新
//                 [self.tableView headerEndRefreshing];
//                 
//                 // 显示最新微博的数量
//                 [self showNewStatusCount:newStatuses.count];
//                 //HLLog(@"%@", json);
//             } failure:^(NSError *error) {
//                 HLLog(@"请求失败-%@", error);
//                 
//                 // 结束刷新刷新
//                 [self.tableView headerEndRefreshing];
//             }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 添加好友
    
    // 1.获取好友账号
    NSString *user = textField.text;
    HLLog(@"%@",user);
    
    // 判断这个账号是否为手机号码
//    if(![textField isTelphoneNum]){
//        //提示
//        [self showAlert:@"请输入正确的手机号码"];
//        return YES;
//    }
    
    
    //判断是否添加自己
    if([user isEqualToString:[HLUserInfo sharedHLUserInfo].user]){
        
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", user, domain];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    
    //判断好友是否已经存在
    if([[HLXMPPTool sharedHLXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[HLXMPPTool sharedHLXMPPTool].xmppStream]){
        [self showAlert:@"当前好友已经存在"];
        return YES;
    }
    
    
    // 2.发送好友添加的请求
    // 添加好友,xmpp有个叫订阅
   
  
    [[HLXMPPTool sharedHLXMPPTool].roster subscribePresenceToUser:friendJid];
    
    return YES;
}

-(void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
@end
