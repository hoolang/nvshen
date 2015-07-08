//
//  HLChatListViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/12.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//


#import "HLChatListViewController.h"
#import "HLChatViewController.h"
#import "HLAddFriendViewController.h"
#import "UIImage+Circle.h"
#import "XMPPvCardTemp.h"
#import "HLChatsTool.h"


@interface HLChatListViewController()
<
UITableViewDelegate,
UITableViewDataSource,
NSFetchedResultsControllerDelegate
>
{

    NSFetchedResultsController *_resultsContrl;
}

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HLChatListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
        [self setupView];
    
    self.navigationItem.leftBarButtonItem =     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
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

-(void)viewWillAppear:(BOOL)animated{
    HLLog(@"viewWillAppear");
    if (self.didLoad == NO){
        [self loadFriends];
    }
}

-(void)loadFriends{
    HLLog(@"chat list didload");
    
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [HLXMPPTool sharedHLXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid = [HLUserInfo sharedHLUserInfo].jid;
    
    HLLog(@"jid :::::::: %@", jid);
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    _resultsContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _resultsContrl.delegate = self;
    
    NSError *err = nil;
    [_resultsContrl performFetch:&err];
    if (err) {
        HLLog(@"%@",err);
    }
    HLLog(@"_resultsContrl.fetchedObjects %@", _resultsContrl.fetchedObjects);
    
    [self.tableView reloadData];
    self.didLoad = YES;
}


#pragma mark 当数据的内容发生改变后，会调用 这个方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    HLLog(@"数据发生改变");
    //刷新表格
    [self.tableView reloadData];
}

-(void)loadFriends2{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [HLXMPPTool sharedHLXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid = [HLUserInfo sharedHLUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    self.friends = [context executeFetchRequest:request error:nil];
    //HLLog(@"%@",self.friends);
    
}

- (void)friendSearch{
    HLAddFriendViewController *addFriendVC = [[HLAddFriendViewController alloc] init];
    addFriendVC.title = @"查找女神";
    
    [self.navigationController pushViewController:addFriendVC animated:YES];
    
}

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
    // We only need to ask the avatar module for a photo, if the roster doesn't have it.
    
    if (user.photo != nil)
    {
        cell.imageView.image = [user.photo clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
    }
    else
    {
        NSData *photoData = [[HLXMPPTool sharedHLXMPPTool].avatar photoDataForJID:user.jid];
        
        if (photoData != nil)
            cell.imageView.image = [[UIImage imageWithData:photoData] clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
        else
            cell.imageView.image = [[UIImage imageNamed:@"avatar_default_small"] clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
    }
}

//** 行数 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HLLog(@"_resultsContrl.fetchedObjects.count %ld", _resultsContrl.fetchedObjects.count);
    return _resultsContrl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // 获取对应好友
    //XMPPUserCoreDataStorageObject *friend =self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];

    //    sectionNum
    //    “0”- 在线
    //    “1”- 离开
    //    “2”- 离线
    switch ([friend.sectionNum intValue]) {//好友状态
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            break;
    }
    
    NSString *name = friend.nickname;
    
    if (name == nil) {
        //获取联系人的名片，如果数据库有就返回，没有返回空，并到服务器上抓取
        XMPPvCardTemp *vcard = [[HLXMPPTool sharedHLXMPPTool].vCard  vCardTempForJID:friend.jid shouldFetch:YES];
        
        name = vcard.nickname;
        
        if (name == nil) {
             NSRange rang = [friend.jidStr rangeOfString:@"@"];
            name = [friend.jidStr substringToIndex:rang.location];
        }
    }

    cell.textLabel.text = name;
    //[NSString stringWithFormat:@"%@ %@",  friend.nickname, friend.unreadMessages ];
    
    HLLog(@"friend.jid %@,friend.nickname %@ ",friend.jid,friend.nickname);
    
    [self configurePhotoForCell:cell user:friend];
    return cell;
}

//实现这个方法，cell往左滑就会有个delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HLLog(@"删除好友");
        XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
        XMPPJID *freindJid = friend.jid;
        [[HLXMPPTool sharedHLXMPPTool].roster removeUser:freindJid];
        
        // 删除沙盒中的数据
        NSRange rang = [friend.jidStr rangeOfString:@"@"];
        NSString *username = [friend.jidStr substringToIndex:rang.location];
        [HLChatsTool updateSubscriptionFromUsername:username Status:@"已删除"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取好友
    XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
    
    HLChatViewController *chatView = [[HLChatViewController alloc] init];
    
    chatView.friendJid = friend.jid;
    
    chatView.title = [self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if (friend.photo != nil)
    {
        chatView.photo = [friend.photo clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
    }
    else
    {
        
        NSData *photoData = [[HLXMPPTool sharedHLXMPPTool].avatar photoDataForJID:friend.jid];
        
        if (photoData != nil)
            chatView.photo = [[UIImage imageWithData:photoData] clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
        else
            chatView.photo = [[UIImage imageNamed:@"avatar_default_small"] clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
    }
    if ([self.delegate respondsToSelector:@selector(pushToChatView:)]) {
        [self.delegate pushToChatView:chatView];
    }
    //[self.navigationController pushViewController:chatView animated:YES];
}
-(void)dealloc
{
    HLLog(@"%s", __func__);
}
@end
