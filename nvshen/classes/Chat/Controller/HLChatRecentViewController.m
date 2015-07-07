//
//  HLChatRecentViewController.m
//  nvshen
//
//  Created by hoolang on 15/7/6.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLChatRecentViewController.h"
#import "HLChatsTool.h"
#import "HLUser.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Circle.h"

@interface HLChatRecentViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chatsFrames;
@end

@implementation HLChatRecentViewController

- (NSMutableArray *)chatsFrames
{
    if (!_chatsFrames) {
        self.chatsFrames = [NSMutableArray array];
    }
    return _chatsFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadDataSources];
}

- (void)viewWillAppear:(BOOL)animated
{
    HLLog(@"%s ", __func__);
}


/**
 初始化tableview
 */
- (void)setupView{
    self.view.backgroundColor = [UIColor grayColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = CGRectMake (0,69,self.view.frame.size.width,self.view.bounds.size.height-44);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HLColor(239, 239, 239);
    // 设置cell的边框颜色
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    
}

/**
 *  加载数据
 */
- (void)loadDataSources
{
    HLLog(@"%s", __func__);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = account.access_token;
    
    // 定义一个block处理返回的字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *users){

        [self.chatsFrames removeAllObjects];
        
        // 将最新的联系人数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, users.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.chatsFrames insertObjects:users atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];

    };
    
    // 2.先尝试从数据库中加载最近联系人数据
    NSArray *users = [HLChatsTool chatsWithParams:params];
    
    HLLog(@"user.count %ld", users.count);

    dealingResult(users);
}

#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HLLog(@"self.chatsFrames.count %ld", self.chatsFrames.count);
    return self.chatsFrames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"RecentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    HLUser *user = self.chatsFrames[indexPath.row];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USER_ICON_URL,user.icon]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] ];
    
    cell.imageView.image = [imageV.image clipCircleImageWithBorder:3 borderColor:[UIColor whiteColor]];
    cell.textLabel.text = user.nickname;
    
    return cell;
}

//实现这个方法，cell往左滑就会有个delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HLUser *user = self.chatsFrames[indexPath.row];
        [HLChatsTool deleteChats:user.username];
        [self.chatsFrames removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}



#pragma mark -其他
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)dealloc
{
    HLLog(@"%s", __func__);
}
@end
