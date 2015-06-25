//
//  HLProfileEditViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/24.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLProfileEditViewController.h"
#import "NSString+Extension.h"
#import "MLImageCrop.h"
#import "UIImage+Circle.h"
#import "HLEditNickNameViewController.h"
#import "HLProfileEditTextViewController.h"
#import "HLHttpTool.h"
#import "HLProfile.h"
#import "HLUser.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HLProvinces.h"
#import "HLCity.h"


#define HLPickFromAlum @"相册"
#define HLPickFromCamera @"拍照"

typedef enum {
    avatar = 0,         // 头像
    nicknameLabel = 1,  // 昵称
    sexLabel = 2,       // 性别
    local = 3,          // 所在地
    text = 4            // 描述
} indexRow;

@interface HLProfileEditViewController ()
<
UITextViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UIActionSheetDelegate,
MLImageCropDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HLEditNickNameDelegate,
HLProfileEditTextDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIPickerView *pickerV;
@property (nonatomic, strong) HLUser *user;
@property (nonatomic, strong) NSArray *provinces; // 省份
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic,assign) NSInteger provinceIndex;  // 选中城市索引 ProvinceName

@end

@implementation HLProfileEditViewController

-(NSArray *)provinces{
    if (_provinces == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"plist"];
        
        NSArray *provinceArr = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *provincesM = [NSMutableArray array];
        
        for (NSDictionary *dict in provinceArr) {
            HLProvinces *province = [HLProvinces provinceWithDict:dict];
            [provincesM addObject:province];
            
        }
        
        _provinces = provincesM;
        
    }
    
    return _provinces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.view.backgroundColor = HLColor(239, 239, 239);

    [self setupView];
    [self loadUserInfo];
}

/**
 初始化tableview
 */
- (void)setupView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = CGRectMake (0,0,self.view.frame.size.width,self.view.bounds.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
}

/** 加载个人信息 */
- (void)loadUserInfo
{
    /**
     @property (strong, nonatomic) UIImage *avatar;      //头像
     @property (copy, nonatomic) NSString *nickname; //昵称
     @property (copy, nonatomic) NSString *sex;      //性别
     @property (copy, nonatomic) NSString *local;         //地区
     @property (copy, nonatomic) NSString *text;
     @property (nonatomic, copy) NSString *uid;
     */
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.name"] = [HLUserInfo sharedHLUserInfo].user;
    
    // 2.发送请求
    [HLHttpTool get:HL_ONE_USER_URL params:params success:^(id json) {
        
        // 将 "字典"数组 转为 "模型"数组
        NSArray *userInfo = [HLProfile objectArrayWithKeyValuesArray:json[@"userinfo"]];
        
        HLProfile *profile = userInfo[0];
        
        HLUser *user = profile.user;
        
        self.user = user;
        
        UIImageView *imgV = [[UIImageView alloc] init];

        [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USER_ICON_URL,user.icon]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.avatar = imgV.image;
            [self.tableView reloadData];
        }];
        
        
        [self.tableView reloadData];
        
  
    } failure:^(NSError *error) {
        HLLog(@"请求失败-%@", error);
    }];
}

/** 返回一个垂直居中的label */
- (UILabel *)cellLabel:(NSString *)text cellHeight:(CGFloat)cellHeight{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    CGSize size =  [text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    label.frame = CGRectMake(100, (cellHeight - height) * 0.5, width , height);
    
    return label;
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"status";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    //cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case avatar:
        {
            [self.avatarLabel removeFromSuperview];
            
            cell.imageView.image = self.avatar;

            self.avatarLabel = [self cellLabel:@"修改头像" cellHeight:64];
            
            [cell addSubview:self.avatarLabel];
        }
            break;
        case nicknameLabel:
        {
            cell.textLabel.text = @"昵称";
            // 移除上一次的label
            [self.nicknameLabel removeFromSuperview];
            
            self.nicknameLabel = [self cellLabel:_user.username cellHeight:cell.height];
            
            [cell addSubview:self.nicknameLabel];
            
        }
            break;
        case sexLabel:
        {
            // 移除上一次的label
            [self.sexLabel removeFromSuperview];
            
            cell.textLabel.text = @"性别";

            self.sexLabel = [self cellLabel:_user.sex cellHeight:cell.height];
            
            [cell addSubview:self.sexLabel];

        }
            break;
        case local:
        {
            [self.localLabel removeFromSuperview];
            
            cell.textLabel.text = @"所在地";
        
            self.localLabel = [self cellLabel:[NSString stringWithFormat:@"%@-%@",_user.province, _user.city] cellHeight:cell.height];
            
            [cell addSubview:self.localLabel];
            
            return cell;
        }
            break;
        case text:
        {
            cell.textLabel.text = @"简介";
            
            [self.text removeFromSuperview];
            
            self.text = [self cellLabel:_user.text cellHeight:cell.height];
            
            [self.text setNumberOfLines:0];
            
            self.text.frame = CGRectMake(100, 10, ScreenWidth - 100 - 20, 100);
            
//            [self cellLabel:_user.text cellHeight:cell.height];
//            
//            self.textView.text = _user.text;
//            
//            self.textView.font = [UIFont systemFontOfSize:12];
//            
//            self.textView.textColor = [UIColor grayColor];
//            
//            self.textView.editable = NO;
            
            [cell addSubview:self.text];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return cell;
        }
            break;

        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case avatar:
        {
            return 64;
            break;
        }
            
        case text:
        {
            CGSize size =  [_user.text sizeWithFont:[UIFont systemFontOfSize:12]];

            return size.height + 10;
            break;
        }
        default:
            return 44;
            break;
    }
}

#pragma mark -选中一个cell的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case avatar:
        {

            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:HLPickFromAlum, HLPickFromCamera,nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];

        }
            break;
        case nicknameLabel:
        {
            HLEditNickNameViewController *nicknameVC = [[HLEditNickNameViewController alloc] init];
            nicknameVC.nickname = _user.username;
            nicknameVC.uid = _user.uid;
            nicknameVC.delegate = self;
            [self.navigationController pushViewController:nicknameVC animated:YES];
            
        }
            break;
        case sexLabel:
        {

            [self setupSex];
            
        }
            break;
        case local:
        {
            [self setPickerViewFrame];
        }
            break;
        case text:
        {

            HLProfileEditTextViewController *textVC = [[HLProfileEditTextViewController alloc] init];
            textVC.text = _user.text;
            textVC.uid = _user.uid;
            textVC.delegate = self;
            [self.navigationController pushViewController:textVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/** 设置性别 */
- (void)setupSex
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请设置性别"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男", @"女",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
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
#pragma mark -HLProfileEditTextDelegate
- (void)reloadText:(NSString *)text
{
    _user.text = text;
    [self.tableView reloadData];
}

#pragma mark - HLEditNickNameDelegate
- (void)reloadNickname:(NSString *)nickname
{
    _user.username = nickname;
    
    [self.tableView reloadData];
}

#pragma mark - MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self dismissViewControllerAnimated:YES completion:nil];


    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.uid"] = _user.uid;
    params[@"user.name"] = [HLUserInfo sharedHLUserInfo].user;

    // 3.发送请求
    [mgr POST:HL_UPDATE_AVATAR_USER parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = [cropImage scaleToSize:CGSizeMake(320, 320)];;
        //
        NSData *data = UIImageJPEGRepresentation(image, 0.6);
        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
         [MBProgressHUD showSuccess:@"正在保存头像...."];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"保存头像成功"];
        self.avatar = [cropImage scaleToSize:CGSizeMake(320, 320)];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常，请稍后再试！"];
    }];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.ratioOfWidthAndHeight = 500.0f/500.0f;
    imageCrop.image = image;
    imageCrop.delegate = self;
    
    [imageCrop showWithAnimation:YES];
    
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
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"男"]){
        // 设置性别：男
        _user.sex = @"男";
        [self.tableView reloadData];
        
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"女"]){
        // 设置性别：女
        _user.sex = @"女";
        [self.tableView reloadData];
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


/** 地区选择器*/
- (void)setPickerViewFrame{
    
    if (self.pickerV.frame.size.height > 0) {
        for ( UIView *view in [self.view subviews]) {
            //HLLog(@"view %@", view);
            if(view.tag == 1){
                view.hidden = !view.hidden;
                return;
            }
        }
    }else{
        UIPickerView *pickerV = [[UIPickerView alloc] init];
        pickerV.frame = CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216);
        pickerV.delegate = self;
        pickerV.tag = 1;
        pickerV.dataSource = self;
        [pickerV reloadAllComponents];
        self.pickerV = pickerV;
        
        [self.view addSubview:pickerV];
        
        [self.view reloadInputViews];
    }
    
}
#pragma mark - PickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return self.provinces.count;
        
    }else{
        
        HLProvinces *province = self.provinces[self.provinceIndex];
        
        return province.cities.count;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = nil;
    
    if (view != nil) {
        label = (UILabel *)view;
        //设置bound
    }else{
        label = [[UILabel alloc] init];
    }
    
    //显示省份
    if (component == 0) {
        HLProvinces *province = self.provinces[row];
        label.text = province.name;
        //label.bounds = CGRectMake(0, 0, 150, 30);
    }else{//显示城市
        //默认是第一城市
        HLProvinces *province = self.provinces[self.provinceIndex];
        label.text = province.cities[row];
    }
    
    label.backgroundColor = [UIColor whiteColor];
    return label;
    
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //省份选中
    if (component == 0) {
        HLProvinces *province = self.provinces[row];
        NSLog(@"选中省份 %@",province.name);
        //更改当前选中的省份索引
        self.provinceIndex = row;
        
        //刷新右边的数据
        [pickerView reloadComponent:1];
        
        //重新设置右边的数据显示第一行
        [pickerView selectRow:0 inComponent:1 animated:YES];
    
        _user.province = province.name;
        _user.city = province.cities[0];
        
    }else if(component == 1){
        HLProvinces *province = self.provinces[self.provinceIndex];
        _user.province = province.name;
        _user.city = province.cities[row];
    }
    
    [self.tableView reloadData];
}

//view的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    //省份的label宽度为150
    if (component == 0) {
        return ScreenWidth * 0.5 - 10;
    }else{
        //市的labl的宽度为100
        return ScreenWidth * 0.5 - 10;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 34;
}
- (void)dealloc
{
    HLLog(@"%s", __func__);
    [HLNotificationCenter removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
