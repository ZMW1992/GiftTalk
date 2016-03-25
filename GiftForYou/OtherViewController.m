//
//  OtherViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "OtherViewController.h"
#import "SelectionCell.h"
#import "ShouyeModel.h"
#import "BaseNetWorkManager.h"
#import "ShouyeDetailViewController.h"

#define otherPinDaoUrlStr @"http://api.liwushuo.com/v1/channels/%@/items?limit=20&offset=%ld"
@interface OtherViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

static NSInteger pagNumber = 0;
@implementation OtherViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // @[@"精选", @"海淘", @"涨姿势", @"美食", @"创意生活", @"生日", @"礼物", @"结婚", @"纪念日", @"数码", @"爱运动", @"母婴", @"家居", @"情人节", @"爱读书", @"科技范", @"送爸妈", @"送基友"];
   // NSArray *idArr = @[@"129", @"120", @"118", @"125", @"30", @"111", @"33", @"31", @"121", @"123", @"119", @"112", @"32", @"124", @"28", @"6", @"26"];
   
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [header setImages:@[[UIImage imageNamed:@"loadmore_arrow"]] forState:MJRefreshStatePulling];
    [header setImages:@[[UIImage imageNamed:@"loadmore_loading"]] duration:0.3 forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 加载数据
/**
 *  加载数据
 */
- (void)loadData {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    pagNumber = 0;
    NSString *str = [NSString stringWithFormat:otherPinDaoUrlStr, self.ID, pagNumber];
    NSString *newString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (0 == pagNumber) {
        [self.dataArr removeAllObjects];
    }
    [BaseNetWorkManager GET:newString parameters:nil success:^(id data) {
        NSArray *arr = data[@"data"][@"items"];
        
        MLLog(@"%@", data);
        
        for (NSDictionary *miniDic in arr) {
            ShouyeModel *model = [ShouyeModel new];
            //让字典里边的数据赋值给model
            [model setValuesForKeysWithDictionary:miniDic];
            [self.dataArr addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
       
    } fail:^(NSError *error) {
        
    }];
    
}

/**
 *  加载更多数据
 */
- (void)loadMoreData {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    pagNumber += 20;
    NSString *str = [NSString stringWithFormat:otherPinDaoUrlStr, self.ID, pagNumber];
    NSString *newString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [BaseNetWorkManager GET:newString parameters:nil success:^(id data) {
        
        NSArray *arr = data[@"data"][@"items"];
        for (NSDictionary *miniDic in arr) {
            ShouyeModel *model = [ShouyeModel new];
            //让字典里边的数据赋值给model
            [model setValuesForKeysWithDictionary:miniDic];
            [self.dataArr addObject:model];
        }
        [self.tableView.mj_footer endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectionCell *cell = [SelectionCell cellWithTableView:tableView];
    
    cell.model = self.dataArr[indexPath.row];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    return [SelectionCell cellHeight];
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 从SB加载控制器
    ShouyeDetailViewController *detailVC = kVCFromSb(@"shouyedetail", @"Main");
    detailVC.navigationItem.title = @"攻略详情";
    
    
    
    ShouyeModel *model = self.dataArr[indexPath.row];
    detailVC.idd = [model.idd stringValue];
    detailVC.shouyeModel = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
