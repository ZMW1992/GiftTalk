//
//  CircleNextController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/8.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CircleNextController.h"
#import "SelectionCell.h"
#import "ShouyeModel.h"
#import "BaseNetWorkManager.h"
#import "ShouyeDetailViewController.h"

#define UrlStr @"http://api.liwushuo.com/v2/collections/%@/posts?limit=20&offset=%ld"
static NSInteger offset = 0;
@interface CircleNextController ()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *array;
@end

@implementation CircleNextController

- (NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleName;
    //添加tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

   // [self.tableView registerNib:[UINib nibWithNibName:@"RecommendTVCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self dataRequestWithUrlStr:[NSString stringWithFormat:UrlStr,
                                          self.idd, offset]];
   
}


- (void)dataRequestWithUrlStr:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        
        if (data != nil) {
            NSArray *arr = data[@"data"][@"posts"];
            for (NSDictionary *miniDic in arr) {
               ShouyeModel *model = [[ShouyeModel alloc] init];
                //让字典里边的数据赋值给model
                [model setValuesForKeysWithDictionary:miniDic];
                
                //把model扔到数组里边
                [self.array addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
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

    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // RecommendTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    SelectionCell *cell = [SelectionCell cellWithTableView:tableView];
    
    cell.model = self.array[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SelectionCell cellHeight];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShouyeDetailViewController *detailVC = [ShouyeDetailViewController new];
    ShouyeModel *model = self.array[indexPath.row];
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
