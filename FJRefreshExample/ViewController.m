//
//  ViewController.m
//  FJRefresh
//
//  Created by Jeff on 2017/3/28.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>

#import "PeapotRefreshHeader.h"
//#import "PeapotRefreshAutoFooter.h"
#import "PeapotRefreshBackFooter.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger allpage;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44.0;
    
    __weak typeof(self) weakSelf = self;
    
    [self loadData:1 onLoadedData:^{
        [self.tableView reloadData];
    }];
    
    self.tableView.mj_header = [PeapotRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:1 onLoadedData:^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [(PeapotRefreshBackFooter*)weakSelf.tableView.mj_footer resetFooterState];
        }];
        
    }];

    self.tableView.mj_footer = [PeapotRefreshBackFooter footerWithHintViewXib:@"NoMoreData"
                                                               hintViewHeight:100.0
                                                              refreshingBlock:^{
                                                                  [weakSelf loadData:weakSelf.page + 1 onLoadedData:^{
                                                                      [weakSelf.tableView reloadData];
                                                                      if (weakSelf.page == weakSelf.allpage) {
                                                                          [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                          // [(PeapotRefreshBackFooter*)weakSelf.tableView.mj_footer endRefreshingWithNoMoreDataNoHint];
                                                                      }else{
                                                                          [weakSelf.tableView.mj_footer endRefreshing];
                                                                      }
                                                                  }];
                                                              }];
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)loadData:(NSUInteger)page onLoadedData:(void(^)(void))onLoadedData{
    
    if (page == 0) {
        assert(@"page error");
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (page == 1) {
            [self.dataSource removeAllObjects];
            [self addData];
            self.page = 1;
            self.allpage = 2;
        }else{
            [self addData];
            self.page += 1;
        }
        
        NSLog(@"Current Page : %d", (int)self.page);
        
        onLoadedData == nil ? : onLoadedData();
        
    });
}

- (void)addData{
    int index = (int)[self.dataSource count];
    for (int i = index ; i < index + 10; i++) {
        [self.dataSource addObject:[NSNumber numberWithInt:i]];
    }
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
