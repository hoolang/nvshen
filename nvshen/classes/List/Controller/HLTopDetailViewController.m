//
//  HLTopDetailViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/7.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopDetailViewController.h"
#import "HLWaterflowLayout.h"
#import "HLTopPostsCategoryCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "HLHttpTool.h"
#import "HLTopPosts.h"
#import "HLTopPostsFrame.h"
#import "HLTopPostsCategoryFrame.h"
@interface HLTopDetailViewController()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *postsFrame;
@end
@implementation HLTopDetailViewController

- (NSMutableArray *)postsFrame
{
    if (_postsFrame == nil) {
        self.postsFrame = [NSMutableArray array];
    }
    return _postsFrame;
}


static NSString *const ID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化数据
    //NSArray *shopArray = [HLShop objectArrayWithFilename:@"1.plist"];
    //[self.shops addObjectsFromArray:shopArray];
    
    [self setupCollectionView];
    
    // 3.增加刷新控件
    //[self.collectionView addFooterWithTarget:self action:@selector(loadMoreDatas)];
    [self setupUpRefresh];
}

/**
    初始化CollectionView
 */
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    //    layout.sectionInset = UIEdgeInsetsMake(100, 20, 40, 30);
    //    layout.columnMargin = 20;
    //    layout.rowMargin = 30;
    //    layout.columnsCount = 4;
    
    // 2.创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    //注册
    //Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'could not dequeue a view of kind: UICollectionElementKindCell with identifier cell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'
    [collectionView registerClass:[HLTopPostsCategoryCell class] forCellWithReuseIdentifier:ID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = HLColor(239, 239, 239);
    //[collectionView registerNib:[UINib nibWithNibName:@"HMShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

/**
 *  集成下拉刷新控件
 */
- (void)setupUpRefresh
{
    // 1.添加刷新控件
    //    [self.tableView addHeaderWithTarget:self action:@selector(loadPostData)];
    [self loadMoreDatas];
    // 2.进入刷新状态
    [self.collectionView  headerBeginRefreshing];
}
- (void)loadMoreDatas
{
    HLLog(@"TOP Detail View Controller ->>>> loadData");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = @1;
    
    // 2.发送请求
    [HLHttpTool get:self.sourceURL
             params:params success:^(id json) {
                 HLLog(@"loadPostData=====-->>>>>> %@", self.sourceURL);
                 
                 NSArray *latestPosts = [HLTopPosts objectArrayWithKeyValuesArray:json[@"latestPosts"]];
                 
                 //将 HWStatus数组 转为 HWStatusFrame数组
                 NSArray *latestPostsFrame = [self topFramesWithPosts:latestPosts];
                 
                 // 将更多的评论数据，添加到总数组的最后面
                 [self.postsFrame addObjectsFromArray:latestPostsFrame];
                 
                 // 刷新collectionView
                 [self.collectionView reloadData];
                 [self.collectionView footerEndRefreshing];
                 
             } failure:^(NSError *error) {
                 HLLog(@"请求失败-%@", error);
             }];
}
- (NSArray *)topFramesWithPosts:(NSArray *)topPosts
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HLTopPosts *topPost in topPosts) {
        HLTopPostsCategoryFrame *f = [[HLTopPostsCategoryFrame alloc] init];
        f.topPosts = topPost;
        [frames addObject:f];
    }
    return frames;
}
#pragma mark - <HMWaterflowLayoutDelegate>
//- (CGFloat)waterflowLayout:(HLWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
//{
//    //HLTopPosts *shop = self.[indexPath.item];
//    HLLog(@"waterflowLayout width ----------------------00000000000>>>>>>>%f", width);
//    
//    
//    return width;
//}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HLLog(@"self.postsFrame.count %lu",self.postsFrame.count);
    return self.postsFrame.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    HLTopPostsCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    // 初始化cell
    [cell setupOriginal];
    cell.topPostsCategoryFrame = self.postsFrame[indexPath.item];
    return cell;
}

// 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark --UICollectionViewDelegateFlowLayout
// 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CollectionWidth;
    HLTopPostsCategoryFrame *topPostsCategoryFrame = self.postsFrame[indexPath.row];
    CGFloat height = topPostsCategoryFrame.cellHeight;
    return CGSizeMake(width, height);
}
// 定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
