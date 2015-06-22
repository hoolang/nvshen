//
//  HLRegisgerViewController.m
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import "HLRegisgerViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HLHttpTool.h"
#import "HLUser.h"
#import "HLMD5.h"
#import "HLRegisgerIconViewController.h"
#import "HLProvinces.h"
#import "HLCity.h"
#import "MJExtension.h"

@interface HLRegisgerViewController()
<
UITextFieldDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIActionSheetDelegate
>

@property (weak, nonatomic) UITextField *userField;
@property (weak, nonatomic) UIButton *localLable;
@property (weak, nonatomic) UIButton *sexLabel;
@property (weak, nonatomic) UIButton *registerBtn;
@property (nonatomic, strong) NSArray *provinces; // 省份
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic,assign) NSInteger provinceIndex;  // 选中城市索引 ProvinceName
@property (strong, nonatomic) UIPickerView *pickerV;


@end

@implementation HLRegisgerViewController

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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = HLColor(239, 239, 239);
    self.title = @"（1/2）创建账号资料";

    [self setupView];
    
}

/** 初始化 */
- (void)setupView{
    /** 用户名*/
    UITextField *userField = [[UITextField alloc] init];
    CGFloat borderW = 10;
    CGFloat height = 34;
    userField.frame = CGRectMake(borderW, 100, ScreenWidth - borderW * 2, height);
    userField.backgroundColor = [UIColor whiteColor];
    userField.placeholder = @"（*）请输入用户名";
    userField.font = [UIFont systemFontOfSize:12];
    self.userField = userField;
    self.userField.inputView = self.pickerV;
    [userField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userField];
    
    
    /** 所在地*/
    UIButton *localLable = [[UIButton alloc] init];
    localLable.frame = CGRectMake(borderW, CGRectGetMaxY(userField.frame) + 10, ScreenWidth - borderW * 2, height);
    [localLable setTitle:@"广东-广州" forState:UIControlStateNormal];
    [localLable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    localLable.titleLabel.font = [UIFont systemFontOfSize:12];
    localLable.backgroundColor = [UIColor whiteColor];
    [localLable addTarget:self action:@selector(setPickerViewFrame) forControlEvents:UIControlEventTouchUpInside];
    localLable.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    localLable.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.localLable = localLable;
    [self.view addSubview:localLable];
    
    /** 性别 */
    UIButton *sexLabel = [[UIButton alloc] init];
    sexLabel.frame = CGRectMake(borderW, CGRectGetMaxY(localLable.frame) + 10, ScreenWidth - borderW * 2, height);
    [sexLabel setTitle:@"男" forState:UIControlStateNormal];
    [sexLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sexLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    sexLabel.backgroundColor = [UIColor whiteColor];
    [sexLabel addTarget:self action:@selector(setupSex) forControlEvents:UIControlEventTouchUpInside];
    sexLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sexLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.sexLabel = sexLabel;
    [self.view addSubview:sexLabel];
    
    /** pickerview */
    //self.pickerV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    
    /** 下一步按钮 */
    UIButton *registerBtn = [[UIButton alloc] init];
    CGFloat btnW = 60;
    registerBtn.frame = CGRectMake((ScreenWidth - btnW) * 0.5, CGRectGetMaxY(sexLabel.frame) + borderW, btnW, height);
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    registerBtn.enabled = NO;
    self.registerBtn = registerBtn;
    [self.view addSubview:registerBtn];
}

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

/** 地区选择器*/
- (void)setPickerViewFrame{
    
    [self.userField resignFirstResponder];
    
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
#pragma mark - next tept
/** 是否可以下一步 */
- (void)textFieldDidChange{
    if (self.userField.hasText) {
        self.registerBtn.enabled = YES;
        [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.registerBtn setBackgroundColor:[UIColor orangeColor]];
    }else{
        self.registerBtn.enabled = NO;
        [self.registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.registerBtn setBackgroundColor:[UIColor clearColor]];
    }
}

/** 点击下一步 */
- (void)registerBtnClick {

    [self.view endEditing:YES];
    
    if (!self.userField.hasText)
    {
        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
        return;
    }else{
        HLRegisgerIconViewController *registerIcon = [[HLRegisgerIconViewController alloc] init];
        registerIcon.username = self.userField.text;
        registerIcon.local = self.localLable.titleLabel.text;
        registerIcon.sex = self.sexLabel.titleLabel.text;
        
        [self.navigationController pushViewController:registerIcon animated:YES];
    }
}

/**
 *  处理注册的结果
 */
-(void)handleResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeNetErr:
                [MBProgressHUD showError:@"网络不稳定" toView:self.view];
                break;
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                // 回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidFinishRegister)]) {
                    [self.delegate regisgerViewControllerDidFinishRegister];
                }
                break;
                
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                break;
            default:
                break;
        }
    });
    
    
}


#pragma mark - UIActionSheetDelegate
// 设置性别
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"男"]){
        // 男
        [self.sexLabel setTitle:@"男" forState:UIControlStateNormal];
        
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"女"]){
        // 女
        [self.sexLabel setTitle:@"女" forState:UIControlStateNormal];
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

        [self.localLable setTitle:[province.name stringByAppendingString:[@"-" stringByAppendingString:province.cities[0]]] forState:UIControlStateNormal];
    }else if(component == 1){
         HLProvinces *province = self.provinces[self.provinceIndex];
        [self.localLable setTitle:[province.name stringByAppendingString:[@"-" stringByAppendingString:province.cities[row]]] forState:UIControlStateNormal];

    }
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
@end