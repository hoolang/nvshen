//
//  NSString+HLRegisgerIconViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/18.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLRegisgerIconViewController.h"
#import "HLImageCrop.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "HLMD5.h"
#import "XMPPvCardTemp.h"
#import "HLLoginViewController.h"
#import "UIImage+Circle.h"

#define HLPickFromAlum @"相册"
#define HLPickFromCamera @"拍照"

@interface HLRegisgerIconViewController()
<UITextFieldDelegate,
UIActionSheetDelegate,
HLImageCropDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIButton *uploadBtn;
@property (weak, nonatomic) UITextField *pwdField;
@property (weak, nonatomic) UITextField *rePwdField;
@property (weak, nonatomic) UIButton *registerBtn;
@end

@implementation HLRegisgerIconViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"（2/2）头像和密码";
    [self.view setBackgroundColor:HLColor(239, 239, 239)];
    
    /** 初始化view */
    [self setupViews];
}
#pragma mark - 初始化Views
- (void)setupViews
{
    CGFloat borderW = 10;
    CGFloat height = 34;
    /** 头像 */
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_big"]];
    
    CGFloat widthIcon = icon.frame.size.width;
    CGFloat heightIcon = icon.frame.size.height;
    
    CGFloat x = borderW;
    CGFloat y = 100;
    icon.frame = CGRectMake(x, y, widthIcon, heightIcon);
    self.icon = icon;
    [self.view addSubview:icon];
    
    /**上传按钮*/
    UIButton *uploadBtn = [[UIButton alloc] init];
    [uploadBtn setTitle:@"选择头像" forState:UIControlStateNormal];
    [uploadBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [uploadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [uploadBtn setBackgroundColor:[UIColor yellowColor]];
    
    CGFloat uploadBtnW = widthIcon;
    [uploadBtn setFrame:CGRectMake(x, CGRectGetMaxY(icon.frame)+ 10, uploadBtnW, 30)];
    
    [uploadBtn addTarget:self action:@selector(pickIcon) forControlEvents:UIControlEventTouchUpInside];
    self.uploadBtn = uploadBtn;
    [self.view addSubview:uploadBtn];
    
    /** 密码 */
    UITextField *pwdField = [[UITextField alloc] init];
    CGFloat fieldW = ScreenWidth - borderW * 3 - widthIcon;
    pwdField.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 10, y , fieldW, height);
    pwdField.backgroundColor = [UIColor whiteColor];
    pwdField.placeholder = @"（*）请填写密码";
    pwdField.font = [UIFont systemFontOfSize:12];
    self.pwdField = pwdField;
    [pwdField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:pwdField];
    
    /** 重复密码*/
    UITextField *rePwdField = [[UITextField alloc] init];
    
    rePwdField.frame = CGRectMake(pwdField.frame.origin.x, CGRectGetMaxY(pwdField.frame) + (widthIcon - height * 2), fieldW, height);
    rePwdField.backgroundColor = [UIColor whiteColor];
    rePwdField.placeholder = @"（*）请确认密码";
    rePwdField.font = [UIFont systemFontOfSize:12];
    
    self.rePwdField = rePwdField;
    [rePwdField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.rePwdField.delegate = self;
    [self.view addSubview:rePwdField];
    
    /** 提交按钮 */
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.frame = CGRectMake(ScreenWidth - widthIcon - borderW, uploadBtn.origin.y, uploadBtn.size.width, uploadBtn.size.height);
    [registerBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(comformRegister) forControlEvents:UIControlEventTouchUpInside];
    
    registerBtn.enabled = NO;
    self.registerBtn = registerBtn;
    [self.view addSubview:registerBtn];

}

/***/
- (void)comformRegister
{
    if (![self.pwdField.text isEqualToString:self.rePwdField.text]) {
        [MBProgressHUD showError:@"两次密码不一致，请重新输入" toView:self.view];
        return;
    }else{
        
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        //设置响应内容类型
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        // 2.拼接请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"user.username"] = [[_username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
        params[@"user.nickname"] = [[_username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
        params[@"user.password"] = [HLMD5 md5:_pwdField.text];
        params[@"user.sex"] = _sex;
        
        NSRange rang = [_local rangeOfString:@"-"];
        params[@"user.province"] = [_local substringToIndex:rang.location];
        params[@"user.city"] = [_local substringFromIndex:rang.location + 1];
        
        // 3.发送请求
        [mgr POST:HL_ADD_USER parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 拼接文件数据
            UIImage *image = _icon.image;
            //
            NSData *data = UIImageJPEGRepresentation(image, 0.6);
            [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            [MBProgressHUD showSuccess:@"注册成功"];
            HLLoginViewController *login = [[HLLoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络异常，请稍后再试！"];
        }];
        
        // 保存
        //[self updateVCard:[_username lowercaseString] withImage:_icon.image];
    }
}

- (void)updateVCard:(NSString *)jid withImage:(UIImage *)image
{
    // 保存
    // 获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [[XMPPvCardTemp alloc] init];
    
    HLLog(@"myvCard %@", myvCard);
    
    NSString *name = [NSString stringWithFormat:@"%@@%@",jid,domain];
    
    HLLog(@"name %@", name);
    //jid
    myvCard.jid = [XMPPJID jidWithString:name];
    
    HLLog(@"myvCard.jid %@", myvCard.jid);
    
    // 图片
    myvCard.photo = UIImagePNGRepresentation(image);
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[HLXMPPTool sharedHLXMPPTool].vCard updateMyvCardTemp:myvCard];
}
- (void)textFieldDidChange
{
    if (_pwdField.hasText && _rePwdField.hasText) {
        self.registerBtn.enabled = YES;
        [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.registerBtn setBackgroundColor:[UIColor yellowColor]];
    }else{
        self.registerBtn.enabled = NO;
        [self.registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.registerBtn setBackgroundColor:[UIColor clearColor]];
    }
}

/** 即将开始编辑 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 150);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

/** 即将结束编辑 */
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
    return YES;
}

/** 取消编辑 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/** 点击选择按钮*/
- (void)pickIcon{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:HLPickFromAlum, HLPickFromCamera,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

/** 选取照片 */
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}


#pragma mark - MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.icon.image = [cropImage scaleToSize:CGSizeMake(350, 350)];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    HLImageCrop *imageCrop = [[HLImageCrop alloc]init];
    imageCrop.ratioOfWidthAndHeight = 500.0f/500.0f;
    imageCrop.image = image;
    imageCrop.delegate = self;
    
    [picker pushViewController:imageCrop animated:YES];

}

/** 相册取消操作 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:HLPickFromAlum]){
        // 从相册获取头像
        [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:HLPickFromCamera]){
        // 通过拍照获取头像
        [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
@end
