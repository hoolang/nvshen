//
//  ILProductViewController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLProductViewController.h"

#import "HLProduct.h"
#import "HLProductCell.h"

@interface HLProductViewController ()

@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation HLProductViewController

- (NSMutableArray *)products
{
    if (_products == nil) {
        _products = [NSMutableArray array];
    
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"products.json" ofType:nil];
    NSData *data =  [NSData dataWithContentsOfFile:fileName];
        
    NSArray *jsonArr =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
        for (NSDictionary *dict in jsonArr) {
            HLProduct *product = [HLProduct productWithDict:dict];
            [_products addObject:product];
        }
        
    }
    return _products;
}

static NSString *ID = @"product";

/*
    使用UICollectionView
    第一步：必须有布局
    第二部：cell必须自己注册
 
 
 */

- (id)init
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 每一个cell的尺寸
    layout.itemSize = CGSizeMake(80, 80);
    
    // 垂直间距
    layout.minimumLineSpacing = 10;
    
    // 水平间距
    layout.minimumInteritemSpacing = 0;
    
    // 内边距
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    // 注册UICollectionViewCell，如果没有从缓存池找到，就会自动帮我们创建UICollectionViewCell
    UINib *xib = [UINib nibWithNibName:@"HLProductCell" bundle:nil];
    
    [self.collectionView registerNib:xib forCellWithReuseIdentifier:ID];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

// 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.products.count;
}

// 返回每一个cell长什么样
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HLProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 获取模型
    HLProduct *p = self.products[indexPath.item];
    
    cell.product = p;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLProduct *p = self.products[indexPath.item];
    NSLog(@"点击了---%@",p.title);
}

@end
