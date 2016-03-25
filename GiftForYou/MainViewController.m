//
//  MainViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MainViewController.h"
#import "HeaderViewController.h"
#import "OtherViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init {
    if (self = [super init]) {
        self.menuHeight = 40.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = 60;
    }
    return self;
}

- (NSArray *)titles {
    return @[@"精选", @"海淘", @"涨姿势", @"美食", @"创意生活", @"生日", @"礼物", @"结婚", @"纪念日", @"数码", @"爱运动", @"母婴", @"家居", @"情人节", @"爱读书", @"科技范", @"送爸妈", @"送基友"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  必须用此方法初始化，来布局分页样式
 *
 *  @return 初始化对象
 */
- (instancetype)initWithStyle {
    if (self = [super init]) {
        self = [[MainViewController alloc] initWithViewControllerClasses:[self itemControllerClass] andTheirTitles:[self itemNames]];
        //        self.keys = [self vcKeys];
        //       self.values = [self vcValues];
        self.postNotification = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = kWindowW/6.0;
        self.progressColor = kRGBColor(255, 160, 21);
        self.titleColorNormal = kRGBColor(40, 40, 40);
        self.titleColorSelected = kRGBColor(255, 160, 21);
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.progressHeight = 4;
        
        
    }
    return self;
}

- (NSArray *)itemNames {
    return @[@"精选", @"海淘", @"涨姿势", @"美食", @"创意生活", @"生日", @"礼物", @"结婚", @"纪念日", @"数码", @"爱运动", @"母婴", @"家居", @"情人节", @"爱读书", @"科技范", @"送爸妈", @"送基友"];
}

- (NSArray *)itemControllerClass {
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[HeaderViewController class]];
    for (int i = 0; i < 17; i++) {
        [arr addObject:[OtherViewController class]];
    }
    return [arr copy];
}

- (NSArray *)vcKeys {
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger count = [self itemNames].count;
    for (int i = 0; i < count; i++) {
        [arr addObject:@"type"];
    }
    return [arr copy];
}



- (NSArray *)vcValues {
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger count = [self itemNames].count;
    for (int i = 0; i <count; i++) {
        [arr addObject:@(i)];
    }
    return [arr copy];
}






#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

//- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
//    switch (index) {
//        case 0: {
//            HeaderViewController *vc = [[HeaderViewController alloc] init];
//           
//            return vc;
//        }
//            break;
//        case 1:
//        case 2:
//        case 3:
//        case 4:
//        case 5:
//        case 6:
//        case 7:
//        case 8:
//        case 9:
//        case 10:
//        case 11:
//        case 12:
//        case 13:
//        case 14:
//        case 15:
//        case 16:
//        case 17:{
//            OtherViewController *vc = [[OtherViewController alloc] initWithStyle:UITableViewStylePlain];
//            NSArray *idArr = @[@"000", @"129", @"120", @"118", @"125", @"30", @"111", @"33", @"31", @"121", @"123", @"119", @"112", @"32", @"124", @"28", @"6", @"26"];
//           
//            vc.ID = idArr[index];
//            
//            MLLog(@"----------------%@", vc.ID);
//            return vc;
//        }
//        default: {
//            return nil;
//            }
//            break;
//            
//    }
//}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}


- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    MLLog(@"%ld -- %@",[info[@"index"] integerValue], info[@"title"]);
    
    OtherViewController *vc = [OtherViewController new];
    vc.ID =  @[@"000", @"129", @"120", @"118", @"125", @"30", @"111", @"33", @"31", @"121", @"123", @"119", @"112", @"32", @"124", @"28", @"6", @"26"][[info[@"index"] integerValue]];
  
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
