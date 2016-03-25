//
//  ShangPinDetailSecondCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ShangPinDetailSecondCell.h"
#import "ShangPinDetailModel.h"
#import "CommentsModel.h"
#import "CommentTVCell.h"
#import "BaseNetWorkManager.h"

#define CommentsUrlStr @"http://api.liwushuo.com/v2/items/%@/comments?limit=20&offset=%ld"

@interface ShangPinDetailSecondCell ()<UIScrollViewDelegate, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *commentsArr;//评论数据源
@end
static NSInteger offset = 0;
@implementation ShangPinDetailSecondCell
//开辟数据源空间
- (NSMutableArray *)commentsArr {
    if (!_commentsArr) {
        self.commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
}

- (void)awakeFromNib {
    // Initialization code
}


- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH- 64 - 30)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kWindowW * 2, 200);
        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kWindowW, 0, kWindowW, kWindowH - 64 - 30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CommentTVCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentTVCell"];
        _tableView.scrollEnabled = NO;
        
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:view];
        
        
    }
    return _tableView;
}


//webView
- (UIWebView *)webView {
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - 64 - 30)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.backgroundColor = [UIColor yellowColor];
    }
    return _webView;
}





//重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.webView];
        [self.scrollView addSubview:self.tableView];
        
        //添加观察者,改变scrollView偏移量
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollViewOffset:) name:@"changeScrollViewOffset" object:nil];
    }
    
    return self;
}



//观察者方法
- (void)changeScrollViewOffset:(NSNotification *)notification {
    CGPoint offset = [notification.userInfo[@"offset"] CGPointValue];
    [self.scrollView setContentOffset:offset animated:YES];
}

//scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        //注册通知中心并发送通知,改变指示条偏移量, 当手动滑动切换页面时让指示条随着动
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIndicateViewOffset" object:self userInfo:@{@"offset":[NSString stringWithFormat:@"%f", offset]}];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndDecelerating:scrollView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / kWindowW;
        
        if (0 == index) {
            self.scrollView.frame = CGRectMake(0, 0, kWindowW, self.webView.scrollView.contentSize.height);
            self.webView.frame = CGRectMake(0, 0, kWindowW, self.webView.scrollView.contentSize.height);
            
            if (self.shangPinDetailWebViewBolck) {
                self.shangPinDetailWebViewBolck(self.webView.scrollView.contentSize.height);
            }
        } else {
            if (self.tableView.contentSize.height < kWindowH - 64 - 30) {
                self.scrollView.frame = CGRectMake(0, 0, kWindowW, kWindowH - 64 - 30);
                self.tableView.frame = CGRectMake(kWindowW, 0, kWindowW, kWindowH - 64 - 30);
                if (self.shangPinDetailWebViewBolck) {
                    self.shangPinDetailWebViewBolck(kWindowH - 64 - 30);
                }
            } else {
                self.scrollView.frame = CGRectMake(0, 0, kWindowW, self.tableView.contentSize.height);
                self.tableView.frame = CGRectMake(kWindowW, 0, kWindowW, self.tableView.contentSize.height);
                if (self.shangPinDetailWebViewBolck) {
                    self.shangPinDetailWebViewBolck(self.tableView.contentSize.height);
                }
            }
            
        }
        
    }
}



//重写setModel方法,为cell赋值 加载web数据


- (void)setModel:(ShangPinDetailModel *)model {
    _model = model;
    [self.webView loadHTMLString:model.detail_html baseURL:nil];
}


//webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGFloat htmlHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    self.webView.frame = CGRectMake(0, 0, kWindowW, htmlHeight);
    self.scrollView.frame = CGRectMake(0, 0, kWindowW, htmlHeight);
    if (self.shangPinDetailWebViewBolck) {
        self.shangPinDetailWebViewBolck(htmlHeight);
    }
}

- (void)setUrlID:(NSString *)urlID {
    _urlID = urlID;
    // 读取评论数据
    [self commentsDataRequestWithUrlStr:[NSString stringWithFormat:CommentsUrlStr, urlID, offset]];
}


//评论数据请求
- (void)commentsDataRequestWithUrlStr:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        
        NSArray *dataArr = data[@"data"][@"comments"];
        for (NSDictionary *dic in dataArr) {
            CommentsModel *model = [CommentsModel objectFromDictionary:dic];
            [self.commentsArr addObject:model];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}



//tableView代理方法

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArr.count;
}

//cell配置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTVCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tempModel = self.commentsArr[indexPath.row];
    return cell;
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
