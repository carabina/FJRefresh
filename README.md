# FJRefresh
> An extend pull-to-refresh component based on MJRefresh

# Usage

```objectivec
// For Refresh Header
__weak typeof(self) weakSelf = self;
self.tableView.mj_header = [PeapotRefreshHeader headerWithRefreshingBlock:^{
[weakSelf loadData:1 onLoadedData:^{
    [weakSelf.tableView reloadData];
    [weakSelf.tableView.mj_header endRefreshing];
    [(PeapotRefreshBackFooter*)weakSelf.tableView.mj_footer resetFooterState];
}];

}];

// For Refresh Footer
self.tableView.mj_footer = [PeapotRefreshBackFooter footerWithHintViewXib:@"NoMoreData"
    hintViewHeight:100.0
    refreshingBlock:^{
        [weakSelf loadData:weakSelf.page + 1 onLoadedData:^{
        [weakSelf.tableView reloadData];
        if (weakSelf.page == weakSelf.allpage) {
            // Show Hint Message When No More Data
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
            // Dont Show Any Message When No More Data
            // [(PeapotRefreshBackFooter*)weakSelf.tableView.mj_footer endRefreshingWithNoMoreDataNoHint];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}];

```


# Contribute

Feel free to open an issue or pull request, if you need help or there is a bug.

# Contact

- Powered by [Jeff NJUT](https://github.com/jeffnjut)
- If any bug or question, please email me [Jeff NJUT](mailto://jeff_njut@163.com)

# Todo

- Documentation

# License

FJRefresh is available under the MIT license. See the LICENSE file for more info.

The MIT License (MIT)

Copyright (c) 2017 Jeff

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
