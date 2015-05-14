//
//  HLEditPhotoViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/14.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLEditPhotoViewController.h"

@interface HLEditPhotoViewController ()

@end

@implementation HLEditPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 50, 100, 50);
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"按1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(press1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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

@end
