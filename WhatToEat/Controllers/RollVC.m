//
//  RollVC.m
//  WhatToEat
//
//  Created by YinShi on 16/10/24.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "RollVC.h"
#import "WWFoodListVC.h"
#import "WWRollVCCell.h"
#import "WWFoodBaseModel.h"
#import "WWBreakfastFood.h"
#import "CollectionViewCell.h"
#import "WWCollectionHeader.h"

@interface RollVC () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theMainTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *theMainCollectionView;


@property (weak, nonatomic) IBOutlet UILabel *theBgLabel;
@property(nonatomic,copy) NSArray *theMealStructureArray;     //meal结构数组
@property(nonatomic,copy) NSArray *allFoodPool;               //食物池(包含早餐 或! 正餐的所有食物)
@property (weak, nonatomic) IBOutlet UIButton *theBtn1;


@property(nonatomic,copy) NSArray *finalFoodArrayAfterRandomPick;
@property(nonatomic)NSMutableArray * finalFoodDataSource;      //随机选出的最终食物, 接着要在tableview上展示

@end

@implementation RollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.theMainCollectionView.hidden = YES;
    
    [self.theMainCollectionView registerNib:[UINib nibWithNibName:@"WWCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeader"];
    [self.theMainCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    //首先确定Meal结构
    if (self.mealType == WWMealBreakfast) {
        
        self.theMealStructureArray =  CRUserObj(@"UDDefaultBreakfastStucture");
        
    }else if (self.mealType == WWMealLunch){
        
        self.theMealStructureArray =  CRUserObj(@"UDDefaultLunchStucture");
        
    }else{
        self.theMealStructureArray =  CRUserObj(@"UDDefaultSupperStucture");
        
    }
    
    
    //
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)makeTheRoll:(UIButton *)sender {
    if ([self.title isEqualToString:@"早餐"]) {
        [self getAllFoodPoolAndShowTableView];
        
    }
    
}

//准备好所有的食物池, 然后显示主tableview
-(void)getAllFoodPoolAndShowTableView{
    self.theMainCollectionView.hidden = NO;
 
    NSArray *dataArray = CRUserObj(@"UDBreakfast");
    self.allFoodPool =  [dataArray unarchiveObjectsFromUD];
    
    
    for (NSInteger i = 0 ;  i < self.theMealStructureArray.count ; i ++) {
        NSDictionary *dict =  self.theMealStructureArray[i];    //对应第i个section
        NSNumber *typeNumber = dict[@"type"];                   //第i个seciton的食物种类
        NSNumber *count = dict[@"count"];                       //第i个section的食物个数
        
        if (self.mealType == WWMealBreakfast ) {
            NSMutableArray *accurateFoodPool = [NSMutableArray array];
            //首先: 食物池细分一下, 组成一个新的更准确的食物池, 然后再从中随机抽取
            for (WWBreakfastFood *theModel in self.allFoodPool) {
                if ([theModel.foodTypeArray containsObject:typeNumber]  ) {
                    [accurateFoodPool addObject:theModel];
                }
            }
            //eg.@{@"米饭",面条}
            _finalFoodArrayAfterRandomPick =  [accurateFoodPool randomPickObjectsWithCount:count.integerValue randomOption:NonRepeatable];
            if (_finalFoodArrayAfterRandomPick.count == 0) {
                
                YSAlertController *alert = [[YSAlertController alloc]init];
                [alert showAlertViewOnVC:self title:[NSString stringWithFormat:@"⚠️[%@]下没有添加任何食物",[APPHelper convertFoodType:typeNumber]] subTitle:@"无法随机从中选出哦" cancelBtnTitle:@"取消" otherBtnTitle:@"马上添加" confirm:^{
                    [self performSegueWithIdentifier:@"show4" sender:self];
                    
                } cancel:^{
                    

                }];
                
            }
            
            //eg.@{@{"米饭","面条"},@{"可乐"}}
            if (_finalFoodArrayAfterRandomPick) {
                [self.finalFoodDataSource addObject:_finalFoodArrayAfterRandomPick];
                
            }
            
        }
        
        
    }
    
    [self.theMainCollectionView reloadData];
    
    
    
}

#pragma mark -
#pragma mark yaoyiyao
- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动手机");
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"stop");
    [self getAllFoodPoolAndShowTableView];
    
    
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
}


#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.finalFoodDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *subArray= self.finalFoodDataSource[section];
    return subArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWRollVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWRollVCCell"];
    
    NSArray *foodModelArray = self.finalFoodDataSource[indexPath.section];
    [cell refreshCellWithModel:foodModelArray[indexPath.row]];
    
    
    return cell;
}

#pragma mark - TableView Delegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSArray *mealStructure = [self.theMealStructureArray translateFoodTypeArrayToChinese];
    
    return mealStructure[section];
    
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  self.finalFoodDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *subArray= self.finalFoodDataSource[section];
    return subArray.count;

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    NSArray *foodModelArray = self.finalFoodDataSource[indexPath.section];
    [cell refreshCellWithMyFavouriteFood:foodModelArray[indexPath.row]];
    
    
    return cell;

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    //
        CGSize size = {320, 44};
        return size;
    
 }
 

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        WWCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeader" forIndexPath:indexPath];
        
        NSArray *mealStructure = [self.theMealStructureArray translateFoodTypeArrayToChinese];
        
        NSString *headerTitle = mealStructure[indexPath.section];

        headerView.titleLabel.text = headerTitle;
        
//        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
//        
//        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
        
    }
    
    return reusableview;
    
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show2"]) {
        
        WWFoodListVC *destTVC = segue.destinationViewController;
        destTVC.mealType = self.mealType;
    }
    
}

#pragma mark - setter & getter
//-(NSArray *)theBFStructureArray{
//    if (!_theBFStructureArray) {
//        _theBFStructureArray = [NSArray array];
//    }
//    return _theBFStructureArray;
//}

-(NSMutableArray *)finalFoodDataSource{
    if (!_finalFoodDataSource) {
        _finalFoodDataSource = [NSMutableArray array];
        
    }
    
    return _finalFoodDataSource;
}


@end
