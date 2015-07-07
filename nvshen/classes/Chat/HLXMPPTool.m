//
//  HLXMPPTool.m
//
//  Created by apple on 14/12/9.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import "HLXMPPTool.h"
#import "HLLoginViewController.h"
#import "Appdelegate.h"
NSString *const HLLoginStatusChangeNotification = @"HLLoginStatusNotification";
/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */
@interface HLXMPPTool ()<XMPPStreamDelegate, XMPPRosterDelegate>{
    
    XMPPResultBlock _resultBlock;
    
    XMPPReconnect *_reconnect;// 自动连接模块
    
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
    
    XMPPMessageArchiving *_msgArchiving;//聊天模块
    

}

// 1. 初始化XMPPStream
-(void)setupXMPPStream;


// 2.连接到服务器
-(void)connectToHost;

// 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost;

// 4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost;
@end


@implementation HLXMPPTool


singleton_implementation(HLXMPPTool)


#pragma mark  -私有方法
#pragma mark 初始化XMPPStream
-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
#warning 每一个模块添加后都要激活
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    
    // 添加花名册模块【获取好友列表】
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    // 添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];
    
    _xmppStream.enableBackgroundingOnSocket = YES;
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_roster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 释放xmppStream相关的资源
-(void)teardownXmpp{
    
    // 移除代理
    [_xmppStream removeDelegate:self];
    
    // 停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;

}
#pragma mark 连接到服务器
-(void)connectToHost{
    HLLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    // 发送通知【正在连接】
    [self postNotification:XMPPResultTypeConnecting];
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    
    // 从单例获取用户名
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [HLUserInfo sharedHLUserInfo].registerUser;
    }else{
        user = [HLUserInfo sharedHLUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:domain resource:@"iphone" ];
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = @"192.168.168.188";//不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        HLLog(@"%@",err);
    }
    
}


#pragma mark 连接到服务成功后，再发送密码授权
-(void)sendPwdToHost{
    HLLog(@"再发送密码授权");
    NSError *err = nil;
    
    // 从单例里获取密码
    NSString *pwd = [HLUserInfo sharedHLUserInfo].pwd;
    
    [_xmppStream authenticateWithPassword:pwd error:&err];
    
    if (err) {
        HLLog(@"%@",err);
    }
}

#pragma mark  授权成功后，发送"在线" 消息
-(void)sendOnlineToHost{
    
    HLLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    HLLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
}

/**
 * 通知 HLHistoryViewControllers 登录状态
 *
 */
-(void)postNotification:(XMPPResultType)resultType{
    
    // 将登录状态放入字典，然后通过通知传递
    NSDictionary *userInfo = @{@"loginStatus":@(resultType)};
    
    [HLNotificationCenter postNotificationName:HLLoginStatusChangeNotification object:nil userInfo:userInfo];
}

#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    HLLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作，发送注册的密码
        NSString *pwd = [HLUserInfo sharedHLUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{//登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
    }
    
}
#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }
    
    if (error) {
        //通知 【网络不稳定】
        [self postNotification:XMPPResultTypeNetErr];
    }
    HLLog(@"与主机断开连接 %@",error);
    
}
#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    HLLog(@"授权成功");
    
    [self sendOnlineToHost];
    
    // 回调控制器登录成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    [self postNotification:XMPPResultTypeLoginSuccess];
    
}


#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    HLLog(@"授权失败 %@",error);
    
    // 判断block有无值，再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    
    [self postNotification:XMPPResultTypeLoginFailure];
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    HLLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    HLLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

#pragma mark 接收到好友消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    HLLog(@"%@",message);
    
    //如果当前程序不在前台，发出一个本地通知
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        HLLog(@"在后台");
        
        //本地通知
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        
        // 设置内容
        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
        
        // 设置通知执行时间
        localNoti.fireDate = [NSDate date];
        
        //声音
        localNoti.soundName = @"default";
        
        //执行
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        
        //{"aps":{'alert':"zhangsan\n have dinner":'sound':'default',badge:'12'}}
    }
}

-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //XMPPPresence 在线 离线
    
    //presence.from 消息是谁发送过来
}

#pragma mark -公共方法
-(void)xmppUserlogout{
    // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    //4.更新用户的登录状态
    [HLUserInfo sharedHLUserInfo].loginStatus = NO;
    [[HLUserInfo sharedHLUserInfo] saveUserInfoToSanbox];
    
    // 跳转到登录界面
    HLLoginViewController *login = [[HLLoginViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    
    UIApplication *app =[UIApplication sharedApplication];
    
    AppDelegate *appDelegate = app.delegate;
    // 切换跟控制器
    appDelegate.window.rootViewController = nav;

}

-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    
    // 先把block存起来
    _resultBlock = resultBlock;
    
    //    Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd86bf06700 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送登录密码
    [self connectToHost];
}


-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

//处理加好友
#pragma mark 处理加好友回调,加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    HLLog(@"presenceType:%@",presenceType);
    
    HLLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",presenceFromUser,domain ]];
    HLLog(@"接收到好友请求: %@", jid);
    [_roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    

    NSNotification *notification =[NSNotification notificationWithName:@"SetUpChatBadgeNotification" object:nil userInfo:nil];
    //通过通知中心发送通知
    [HLNotificationCenter postNotification:notification];
}

-(void)dealloc{
    [self teardownXmpp];
}
@end
