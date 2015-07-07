//
//  HLChatViewController.m
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import "HLChatViewController.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
#import "HLMessageCell.h"
#import "HLMessageFrame.h"
#import "HLMessage.h"
#import "HLComposeToolbar.h"
#import "HLEmotionKeyboard.h"
#import "HLEmotionTextView.h"
#import "XMPPvCardTemp.h"

@interface HLChatViewController ()
<UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate,
UITextViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
HLComposeToolbarDelegate>
{
    NSFetchedResultsController *_resultsContr;
}
//@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView底部约束
//@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束
@property (nonatomic, weak) UITableView *tableView;
/** 自己的头像 */
@property (nonatomic, strong) UIImage *selfAvatar;
@property (nonatomic, strong) HttpTool *httpTool;
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;
/** 键盘顶部的工具条 */
@property (nonatomic, strong) HLComposeToolbar *toolbar;
#warning 一定要用strong
/** 表情键盘 */
@property (nonatomic, strong) HLEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;

@end

@implementation HLChatViewController
#pragma mark - 懒加载

- (UIImage *)selfAvatar
{
    if (!_selfAvatar) {
        XMPPvCardTemp *myVCard = [HLXMPPTool sharedHLXMPPTool].vCard.myvCardTemp;
        // 图片
        _selfAvatar = [UIImage imageWithData:myVCard.photo];
        NSData *photoData = [[HLXMPPTool sharedHLXMPPTool].avatar photoDataForJID:[XMPPJID jidWithString:[HLUserInfo sharedHLUserInfo].jid]];
        
       _selfAvatar = [UIImage imageWithData:photoData];

    }
    return _selfAvatar;
}

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
-(HttpTool *)httpTool{
    if (!_httpTool) {
        _httpTool = [[HttpTool alloc] init];
    }
    
    return _httpTool;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self setupView];
    
    // 添加工具条
    [self setupToolbar];
    
    // 键盘监听
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 加载数据
    [self loadMsgs];
    
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [HLNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 表情选中的通知
    [HLNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:HLEmotionDidSelectNotification object:nil];
    
    // 删除文字的通知
    [HLNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HLEmotionDidDeleteNotification object:nil];
    
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
    toolbar.textView.placeholder = @"聊些什么吧";
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
}
-(void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"%@",noti);
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
    
    //竖屏{{0, 0}, {768, 264}
    //横屏{{0, 0}, {352, 1024}}
    // 如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0
       && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        kbHeight = kbEndFrm.size.width;
    }
        
//    self.inputViewBottomConstraint.constant = kbHeight;
    
    //表格滚动到底部
    [self scrollToTableBottom];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    // 隐藏键盘的进修 距离底部的约束永远为0
//    self.inputViewBottomConstraint.constant = 0;
}


-(void)setupView{
    // 代码方式实现自动布局 VFL
    // 创建一个Tableview;
    UITableView *tableView = [[UITableView alloc] init];
    //tableView.backgroundColor = [UIColor redColor];
    //cell 不可选中
    tableView.allowsSelection = NO;
    
    tableView.backgroundColor = HLColor(249, 249, 249);
    
    tableView.frame = CGRectMake (0,0,self.view.frame.size.width,self.view.bounds.size.height-44);
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
#warning 代码实现自动布局，要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 创建输入框View
//    HLInputView *inputView = [HLInputView inputView];
//    inputView.translatesAutoresizingMaskIntoConstraints = NO;
//    // 设置TextView代理
//    inputView.textView.delegate = self;
    
    // 添加按钮事件
//    [inputView.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:inputView];
    
    // 自动布局
    
    // 水平方向的约束
//   NSDictionary *views = @{@"tableview":tableView,
//                            @"inputView":inputView};
    
    // 1.tabview水平方向的约束
//    NSArray *tabviewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:tabviewHConstraints];
//    
//    // 2.inputView水平方向的约束
//    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:inputViewHConstraints];
//    
//    
//    // 垂直方向的约束
//    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableview]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
//    [self.view addConstraints:vContraints];
    // 添加inputView的高度约束
//    self.inputViewHeightConstraint = vContraints[2];
//    self.inputViewBottomConstraint = [vContraints lastObject];
//    NSLog(@"%@",vContraints);
}

#pragma mark 加载XMPPMessageArchiving数据库的数据显示在表格
-(void)loadMsgs{

    // 上下文
    NSManagedObjectContext *context = [HLXMPPTool sharedHLXMPPTool].msgStorage.mainThreadManagedObjectContext;
    // 请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    
    // 过滤、排序
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[HLUserInfo sharedHLUserInfo].jid,self.friendJid.bare];
    HLLog(@"%@",pre);
    request.predicate = pre;
    
    // 时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
   
    // 查询
    _resultsContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    
    NSError *err = nil;
    // 代理
    _resultsContr.delegate = self;
    
    [_resultsContr performFetch:&err];
    
    HLLog(@"_resultsContr.fetchedObjects.count %ld", _resultsContr.fetchedObjects.count);
    
    if (err) {
        HLLog(@"%@",err);
    }
}
/** 转frames*/
- (HLMessageFrame *)chatFramesWithChats:(XMPPMessageArchiving_Message_CoreDataObject *) msg
{
    
    HLMessageFrame *frames = [[HLMessageFrame alloc] init];
    HLMessage *message = [[HLMessage alloc] init];
    
    message.text = msg.body;
    
    NSString *time = [NSString stringWithFormat:@"%@", msg.timestamp];
    
    message.time = [time getNewStyleByCompareNow: @"yyyy-MM-dd HH:mm:ss z"];
    
    if ([msg.outgoing boolValue]) {//自己发
        message.type = HLMessageMe;
        message.avatar = self.selfAvatar;
    }else{//别人发的
        message.type = HLMessageOther;
        message.avatar = self.photo;
    }
    
    frames.message = message;
    
    return frames;
}
#pragma mark -表格的数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultsContr.fetchedObjects.count;
}

/** 通过模型返回cell */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HLMessageFrame *frame = [self chatFramesWithChats:_resultsContr.fetchedObjects[indexPath.row]];
    
    HLMessageCell *cell = [HLMessageCell messageCellWithTableView:tableView];
    cell.frameMessage = frame;

    return cell;

}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLMessageFrame *frame = [self chatFramesWithChats:_resultsContr.fetchedObjects[indexPath.row]];

    return frame.cellH;
}


#pragma mark ResultController的代理
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 刷新数据
    [self.tableView reloadData];
    [self scrollToTableBottom];
}

#pragma mark TextView的代理
-(void)textViewDidChange:(UITextView *)textView{
    //获取ContentSize
    CGFloat contentH = textView.contentSize.height;
    HLLog(@"textView的content的高度 %f",contentH);
    
    // 大于33，超过一行的高度/ 小于68 高度是在三行内
    if (contentH > 33 && contentH < 68 ) {
//        self.inputViewHeightConstraint.constant = contentH + 18;
    }
    
    NSString *text = textView.text;
    
    
    // 换行就等于点击了的send
    if ([text rangeOfString:@"\n"].length != 0) {
        HLLog(@"发送数据 %@",text);
        
        // 去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self sendMsgWithText:text bodyType:@"text"];
        //清空数据
        textView.text = nil;
        
        // 发送完消息 把inputView的高度改回来
//        self.inputViewHeightConstraint.constant = 50;
        
    }else{
        HLLog(@"%@",textView.text);

    }
}
#pragma mark 发送聊天消息(Text)
- (void)sendTextMsg{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //text 纯文本
    //image 图片
    [msg addAttributeWithName:@"bodyType" stringValue:@"text"];
    
    // 设置内容
    [msg addBody:self.toolbar.textView.text];
    
    [[HLXMPPTool sharedHLXMPPTool].xmppStream sendElement:msg];
    
    self.toolbar.textView.text = nil;
    [self.toolbar.textView resignFirstResponder];
}

#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text bodyType:(NSString *)bodyType{
    
    HLLog(@"self.friendjid :::::%@", self.friendJid);
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //text 纯文本
    //image 图片
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
   
    // 设置内容
    [msg addBody:text];

    [[HLXMPPTool sharedHLXMPPTool].xmppStream sendElement:msg];
}

#pragma mark 滚动到底部
-(void)scrollToTableBottom{
    
    NSInteger lastRow = _resultsContr.fetchedObjects.count - 1;
    
    if (lastRow < 0) {
        //行数如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark 选择图片
-(void)addBtnClick{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];

}

#pragma mark 选取后图片的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    // 隐藏图片选择器的窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 把图片发送到文件服务器
    //http post put
    /**
     * put实现文件上传没post那烦锁，而且比POST快
     * put的文件上传路径就是下载路径
     
     *文件上传路径 http://localhost:8080/imfileserver/Upload/Image/ + "图片名【程序员自已定义】"
     */
    
    // 1.取文件名 用户名 + 时间(201412111537)年月日时分秒
    NSString *user = [HLUserInfo sharedHLUserInfo].user;

    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [dataFormatter stringFromDate:[NSDate date]];
    
    // 针对我的服务，文件名不用加后缀
    NSString *fileName = [user stringByAppendingString:timeStr];
    
    // 2.拼接上传路径
    NSString *uploadUrl = [@"http://localhost:8080/imfileserver/Upload/Image/" stringByAppendingString:fileName];
    
    
    // 3.使用HTTP put 上传
#warning 图片上传请使用jpg格式 因为我写的服务器只接接收jpg
    [self.httpTool uploadData:UIImageJPEGRepresentation(image, 0.75) url:[NSURL URLWithString:uploadUrl] progressBlock:nil completion:^(NSError *error) {
       
        if (!error) {
            NSLog(@"上传成功");
            [self sendMsgWithText:uploadUrl bodyType:@"image"];
        }
    }];
    
    
    // 图片发送成功，把图片的URL传Openfire的服务
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
            //HLLog(@"发送");
            [self sendTextMsg];
            break;
            
        case HLComposeToolbarTypeEmotion: // 表情\键盘
            //HLLog(@"表情键盘");
            [self switchKeyboard];
            break;
            
        case HLComposeToolbarTypeMention: // @
            //HLLog(@"--- @");
            break;
            
        case HLComposeToolbarTypeTrend: // #
            //HLLog(@"--- #");
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
- (void)dealloc
{
    HLLog(@"HLChatViewContrller dealloc");
    [HLNotificationCenter removeObserver:self];
}
@end
