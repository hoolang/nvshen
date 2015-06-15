//
//  HLChatListViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/12.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//


#import "HLChatListViewController.h"
#import "HLChatViewController.h"


@interface HLChatListViewController()<NSFetchedResultsControllerDelegate>
{

    NSFetchedResultsController *_resultsContrl;
}

@property (nonatomic, strong) NSArray *friends;
/** 标记是否已经加载数据 */
@property (nonatomic, assign) BOOL didLoad;

@end

@implementation HLChatListViewController


-(void)viewDidLoad{
    HLLog(@"chat list didload");
    [super viewDidLoad];
    
    // 从数据里加载好友列表显示
    //[self loadFriends2];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (!self.didLoad){
        [self loadFriends2];
    }
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
    HLLog(@"_resultsContrl.fetchedObjects.count %ld", _resultsContrl.fetchedObjects.count);
    self.didLoad = YES;
}


#pragma mark 当数据的内容发生改变后，会调用 这个方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    HLLog(@"数据发生改变");
    //刷新表格
    [self.tableView reloadData];
}

-(void)loadFriends{
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
    NSLog(@"%@",self.friends);
    
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
    
    HLLog(@"friend.jidStr %@", friend.jidStr);
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
    cell.textLabel.text = friend.jidStr;
    
    return cell;
}

//实现这个方法，cell往左滑就会有个delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HLLog(@"删除好友");
        XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
        
        XMPPJID *freindJid = friend.jid;
        [[HLXMPPTool sharedHLXMPPTool].roster removeUser:freindJid];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取好友
    XMPPUserCoreDataStorageObject *friend = _resultsContrl.fetchedObjects[indexPath.row];
    
    //选中表格进行聊天界面
    //[self performSegueWithIdentifier:@"ChatSegue" sender:friend.jid];
    
    HLChatViewController *chatView = [[HLChatViewController alloc] init];
    
    chatView.friendJid = friend.jid;
    
    chatView.title = @"私聊";
    
    [self.navigationController pushViewController:chatView animated:YES];
    
}
@end
