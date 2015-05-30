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

@interface HLAddCommentViewController ()
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;
/**
*  show数组（里面放的都是HLStatusFrame模型，一个HLStatusFrame对象就代表一条show）
*/
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation HLAddCommentViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setNav];
    // 集成下拉刷新控件
    [self loadNewPosts];

}
- (void)loadNewPosts{
    HLLog(@"loadNewPosts->>");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    HLStatusFrame *firstStatusF = [self.statusFrames firstObject];

    // 2.发送请求
    [HLHttpTool get:HL_LATEST_POSTS_URL
             params:params success:^(id json) {
                 // 将 "show（posts）字典"数组 转为 "微博模型"数组
                 NSArray *newStatuses = [HLStatus objectArrayWithKeyValuesArray:json[@"status"]];
                 
                 
                 // 将 HWStatus数组 转为 HWStatusFrame数组
                 NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
                 
                 // 将最新的微博数据，添加到总数组的最前面
                 NSRange range = NSMakeRange(0, newFrames.count);
                 NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
                 [self.statusFrames insertObjects:newFrames atIndexes:set];
                 
                 // 刷新表格
                 [self.tableView reloadData];
                 
                 
                 // 结束刷新
                 [self.tableView headerEndRefreshing];
                 
                 // 显示最新微博的数量
                 [self showNewStatusCount:newStatuses.count];
                 HLLog(@"%@", json);
             } failure:^(NSError *error) {
                 HLLog(@"请求失败-%@", error);
                 
                 // 结束刷新刷新
                 //[self.tableView headerEndRefreshing];
             }];
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
    
    [self.view addSubview:textView];
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

@end
