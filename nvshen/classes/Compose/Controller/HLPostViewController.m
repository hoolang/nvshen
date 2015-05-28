//
//  HLPostViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/18.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLPostViewController.h"
#import "HLEmotionTextView.h"
#import "HLEmotion.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"


@interface HLPostViewController ()<UITextViewDelegate>
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;

@end

@implementation HLPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(send) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
  
    HLEmotionTextView *textView = [[HLEmotionTextView alloc] init];
    // 垂直方向上可以拖拽
    textView.alwaysBounceVertical = YES;
    CGFloat screen = [UIScreen mainScreen].bounds.size.width;
    
    textView.frame = CGRectMake(10, 74, screen - self.postImageView.frame.size.width -10 -10,self.postImageView.frame.size.height
                                );
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    textView.placeholder = @"秀一秀我的态度";
    [textView becomeFirstResponder];


    self.postImageView.image = _image;
    self.textView = textView;
    
    [self.view addSubview:textView];
    
    // 文字改变的通知
    [HLNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
//    // 键盘通知
//    // 键盘的frame发生改变时发出的通知（位置和尺寸）
//    [HLNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    
//    // 表情选中的通知
//    [HLNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:HWEmotionDidSelectNotification object:nil];
//    
//    // 删除文字的通知
//    [HLNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HWEmotionDidDeleteNotification object:nil];
}

#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}

-(void)QQ{
    HLLog(@"QQ");
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        //          获取微博用户名、uid、token等
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
//            
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            
//        }});
    
    
    
}

- (void)send {
    HLLog(@"send");
    HLLog(@"send %@",_image);
    [self sendWithImage];
//    if (_image) {
//        [self sendWithImage];
//    } else {
//        [self sendWithoutImage];
//    }
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 发布带有图片的微博
 */
- (void)sendWithImage
{

    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"access_token"] = [HWAccountTool account].access_token;
    params[@"post.content"] = self.textView.text;
    
    
    // 3.发送请求
    [mgr POST:HLPOST parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = _image;
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 * 发布没有图片的微博
 */
- (void)sendWithoutImage
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = [HWAccountTool account].access_token;
//    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
//    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        [MBProgressHUD showSuccess:@"发送成功"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@"发送失败"];
//    }];
    
    [mgr POST:@"http://192.168.168.100:8008/nvshen/addPost.action" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = _image;
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}
-(void)textDidChange{
    //HLLog(@"textDidChange");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
