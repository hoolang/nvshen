//
//  HLChatMainViewController.m
//  nvshen
//
//  Created by hoolang on 15/7/6.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLChatMainViewController.h"
#import "SegmentedControl.h"
#import "HLChatRecentViewController.h"
#import "HLChatListViewController.h"
#import "HLChatViewController.h"

@interface HLChatMainViewController ()
<
HLChatListVCDelegate
>
@property (nonatomic, strong) HLChatRecentViewController *recentVC;
@property (nonatomic, strong) HLChatListViewController *chatListVC;
@property (nonatomic, strong) NSArray *viewsControllers;
@property (nonatomic, assign) NSInteger lastSelectedSegmentIndex;
@end

@implementation HLChatMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
        HLLog(@"%s ", __func__);
    [self.recentVC loadDataSources];
    
    if (!self.chatListVC.didLoad) {

        [self.chatListVC loadFriends];

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SegmentedControl *segmentedControl = [[SegmentedControl alloc] init];
    [segmentedControl addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    
    self.recentVC = [[HLChatRecentViewController alloc] init];
    self.recentVC.view.frame = self.view.bounds;
    [self.view addSubview:self.recentVC.view];
    
    self.chatListVC = [[HLChatListViewController alloc] init];
    self.chatListVC.view.frame = self.view.bounds;
    self.chatListVC.delegate = self;
    [self.view addSubview:self.chatListVC.view];

    
    self.viewsControllers = @[self.recentVC, self.chatListVC];
    
    segmentedControl.selectedSegmentIndex = 0;
    self.lastSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    

    self.recentVC.view.hidden = NO;
    self.chatListVC.view.hidden = YES;
    
    [HLNotificationCenter addObserver:self selector:@selector(setupChatBadge) name:@"SetUpChatBadgeNotification" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) typeAction:(SegmentedControl *) sender{
    HLLog(@"ViewController typeAction:");
    [self transitionFrom:self.lastSelectedSegmentIndex to:sender.selectedSegmentIndex];
    self.lastSelectedSegmentIndex = sender.selectedSegmentIndex;
}


-(void)transitionFrom:(NSInteger)from to:(NSInteger)to{
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionPush;
    transition.subtype = from > to ? kCATransitionFromLeft : kCATransitionFromRight;
    
    UIViewController *currentSegmentedView = (UIViewController *)self.viewsControllers[from];
    UIViewController *nextSegmentedView = (UIViewController *)self.viewsControllers[to];
    
    [currentSegmentedView.view.layer addAnimation:transition forKey:@"transition"];
    [nextSegmentedView.view.layer addAnimation:transition forKey:@"transition"];
    
    currentSegmentedView.view.hidden = YES;
    nextSegmentedView.view.hidden = NO;
}

#pragma mark -HLChatListVCDelegate
- (void)pushToChatView:(HLChatViewController *)chatView{
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark - 设置badge
- (void)setupChatBadge
{
//    if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
        self.tabBarItem.badgeValue = @"11";
        [UIApplication sharedApplication].applicationIconBadgeNumber = 11;
//    } else { // 非0情况
//        self.tabBarItem.badgeValue = status;
//        [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
//    }
}
-(void)dealloc
{
    HLLog(@"%s", __func__);
}
@end
