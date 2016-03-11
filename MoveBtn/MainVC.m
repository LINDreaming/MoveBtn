//
//  MainVC.m
//  MoveBtn
//
//  Created by Linxi on 15/1/5.
//  Copyright (c) 2015年 china08. All rights reserved.
//

#import "MainVC.h"
#import "MoveCell.h"

@interface MainVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
{
    UICollectionView *colllectionview;
    UIButton *moveBtn;
    NSMutableArray *dataSource;
    UIButton *deleteButton;
       NSInteger deleteIndexPath;
}

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    dataSource = [NSMutableArray array];
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"更多"];
    dataSource = [NSMutableArray arrayWithArray:array];
     [self setupSubViews];
}

- (void)setupSubViews{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    colllectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)collectionViewLayout:layOut];
    colllectionview.delegate = self;
    colllectionview.dataSource = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(activiteDeletionMode:)];
    longPress.delegate = self;
    [colllectionview addGestureRecognizer:longPress];
    colllectionview.contentSize = CGSizeMake(self.view.frame.size.width, 400);
    colllectionview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:colllectionview];
   // 利用Xib加载UICollectionViewCell的方法
    [colllectionview registerNib:[UINib nibWithNibName:@"MoveCell" bundle:nil] forCellWithReuseIdentifier:@"mainCell"];
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(50, 0, 20, 20);
    deleteButton.backgroundColor = [UIColor redColor];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteAction:(UIButton *)sender{
    [dataSource removeObjectAtIndex:deleteIndexPath];
    [deleteButton removeFromSuperview];
    [colllectionview reloadData];
}
#pragma mark - UIGesture delegate -

- (void)activiteDeletionMode:(UILongPressGestureRecognizer *)gr{
    static NSIndexPath *sourceIndexPath = nil;
      NSIndexPath *indexPath1 = [colllectionview indexPathForItemAtPoint:[gr locationInView:colllectionview]];
    if (indexPath1.row != dataSource.count - 1) {
        switch (gr.state) {
            case UIGestureRecognizerStateBegan:{
                NSIndexPath *indexPath = [colllectionview indexPathForItemAtPoint:[gr locationInView:colllectionview]];
                UICollectionViewCell *cell = [colllectionview cellForItemAtIndexPath:indexPath];
                deleteButton.hidden = NO;
                [cell addSubview:deleteButton];
                [UIView animateWithDuration:0.5 animations:^{
                }];
                deleteIndexPath = indexPath.row;
                sourceIndexPath = indexPath;
                [deleteButton bringSubviewToFront:colllectionview];
                
                
            }
                break;
            case UIGestureRecognizerStateChanged:{
                
                NSIndexPath *indexPath = [colllectionview indexPathForItemAtPoint:[gr locationInView:colllectionview]];
                [colllectionview moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                if (sourceIndexPath.row<indexPath.row ) {
                    for (NSInteger i = sourceIndexPath.row; i < indexPath.row; i++) {
                        [dataSource exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                    }
                }else if( indexPath.row < sourceIndexPath.row){
                    for (NSInteger i = sourceIndexPath.row;i > indexPath.row ; i --) {
                        [dataSource exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                    }
                }
                
                
                deleteIndexPath = indexPath.row;
                sourceIndexPath = indexPath;
               
                
            }
                break;
            case UIGestureRecognizerStateEnded:{
                NSIndexPath *indexPath =[colllectionview indexPathForItemAtPoint:[gr locationInView:colllectionview]];
                [colllectionview moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                if (sourceIndexPath.row<indexPath.row ) {
                    for (NSInteger i = sourceIndexPath.row; i < indexPath.row; i++) {
                        [dataSource exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                    }
                   
                  
                }else if( indexPath.row < sourceIndexPath.row){
                    for (NSInteger i = sourceIndexPath.row;i > indexPath.row ; i --) {
                        [dataSource exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                    }
                }
                  sourceIndexPath = indexPath;
                for (id temp in dataSource) {
                    NSLog(@"---datasource == %@",temp);
                }
            }
            default:
                break;
        }

    }

    
}

#pragma mark UICollectionviewDelegate Methods -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    MoveCell *cell = [colllectionview dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
       cell.backgroundColor = [UIColor whiteColor];
    NSString *str = [dataSource objectAtIndex:indexPath.row];
    // 此处Lable上面的text值不显示；
    cell.lable.text = str;
    UIImage *image = [UIImage imageNamed:@"parentCollaege"];
    cell.imageview.image = image;
   // cell.lable.backgroundColor = [UIColor redColor];
    cell.imageview.backgroundColor = [UIColor blueColor];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize rect = CGSizeMake(79, 80);
    return rect;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    deleteButton.hidden = YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
