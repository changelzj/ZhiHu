
#import "HomeController.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation HomeController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationBarItems];
    
    dataSource = [[NSMutableArray alloc]init];
    imagesAndTitles = [[NSMutableArray alloc]init];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:204/255.0 green:193/255.0 blue:203/255.0 alpha:1];
    self.tableView.tableHeaderView = [self createImagesScroll];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reFresh) forControlEvents:UIControlEventValueChanged];
    
    isLoadMore = NO;
    [self requestDataWithPath:@"http://news-at.zhihu.com/api/4/news/latest"];
}






- (void)createNavigationBarItems
{
    self.navigationItem.title = @"首页";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"left_btn_normal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"left_btn_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(showSide) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}



- (void)reFresh
{
    isLoadMore = NO;
    [self requestDataWithPath:@"http://news-at.zhihu.com/api/4/news/latest"];
}


- (void)requestDataWithPath:(NSString *)path
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        if(isLoadMore == NO)
        {
            [dataSource removeAllObjects];
            [imagesAndTitles removeAllObjects];
            
            NSArray *topimages = [responseObject objectForKey:@"top_stories"];
            
            for (NSDictionary *dic in topimages)
            {
                HomeModel *model = [[HomeModel alloc]init];
                model.iid = [dic objectForKey:@"id"];
                model.title = [dic objectForKey:@"title"];
                model.images = [dic objectForKey:@"image"];
                [imagesAndTitles addObject:model];
            }
            
            [imagesScroll refreshData];
        }
        
        
        lastdate = [responseObject objectForKey:@"date"];
        
        NSMutableArray *subDatadource = [[NSMutableArray alloc]init];
        
        NSArray *array = [responseObject objectForKey:@"stories"];
        
        for(NSDictionary *dic in array)
        {
            HomeModel *model = [[HomeModel alloc]init];
            model.images = [[dic objectForKey:@"images"]firstObject];
            model.iid = [dic objectForKey:@"id"];
            model.multipic = [dic objectForKey:@"multipic"];
            model.title = [dic objectForKey:@"title"];
            
            [subDatadource addObject:model];
        }
        
        [dataSource addObject:@{lastdate:subDatadource}];
        
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [self.refreshControl endRefreshing];
    }];
}









- (ImagesScrollView *)createImagesScroll
{
    imagesScroll = [[ImagesScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 230)];
    imagesScroll.delegate = self;
    return imagesScroll;
}

#pragma mark - ImagesScrollViewDelegate

- (NSInteger)numberOfImages:(ImagesScrollView *)imagesScrollView
{
    return imagesAndTitles.count;
}


- (Content *)imagesScrollView:(ImagesScrollView *)imagesScrollView dataForImageAtindex:(NSInteger)index
{
    HomeModel *model = [imagesAndTitles objectAtIndex:index];
    
    Content *content = [[Content alloc]init];
    
    UIImageView *img = [[UIImageView alloc]init];
    [img sd_setImageWithURL:[NSURL URLWithString:model.images]];
    
    content.imageView = img;
    content.title = model.title;
    
    return content;
}


- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView didSelectImageAtIndex:(NSInteger)index
{
    HomeModel *model = [imagesAndTitles objectAtIndex:index];
    DetailController *detailController = [[DetailController alloc]init];
    detailController.iid = [NSString stringWithFormat:@"%ld",model.iid.longValue];
    [self.navigationController pushViewController:detailController animated:YES];
}




#pragma mark - UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 40;
    }
    else
    {
        return 100;
    }
    return 0;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [dataSource objectAtIndex:section];
    NSArray *array = dic.allValues.firstObject;
    return array.count+1;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"CELL2"];
    
    if(cell == nil)
    {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:193/255.0 blue:203/255.0 alpha:1];
    }
    
    if(cell2 == nil)
    {
        cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL2"];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.backgroundColor = [UIColor colorWithRed:204/255.0 green:193/255.0 blue:203/255.0 alpha:1];
        cell2.textLabel.textAlignment = NSTextAlignmentCenter;
        cell2.textLabel.textColor = [UIColor whiteColor];
    }
    
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.section];
    NSArray *array = dic.allValues.firstObject;
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if(indexPath.row > 0)
    {
        HomeModel *model = [array objectAtIndex:indexPath.row-1];
        [cell setCellWithModel:model];
    }
    else
    {
        cell2.textLabel.text = dic.allKeys.firstObject;
    }
    
    
    if(indexPath.section == dataSource.count-1)
    {
        if(indexPath.row == array.count)
        {
            isLoadMore = YES;
            [self requestDataWithPath:[NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@",lastdate]];
        }
    }
    
    if(indexPath.row > 0)
    {
        return cell;
    }
    else
    {
        return cell2;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.section];
    NSArray *array = dic.allValues.firstObject;
    
    if(indexPath.row > 0)
    {
        HomeModel *model = [array objectAtIndex:indexPath.row-1];
        DetailController *detailController = [[DetailController alloc]init];
        detailController.iid = [NSString stringWithFormat:@"%ld",model.iid.longValue];
        [self.navigationController pushViewController:detailController animated:YES];
    }
    
}




- (void)showSide
{
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished)
     {
         
     }];
}


- (void)hideSide
{

}



- (void)viewWillAppear:(BOOL)animated
{
    
}

@end




