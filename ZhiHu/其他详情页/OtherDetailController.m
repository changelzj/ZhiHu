
#import "OtherDetailController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation OtherDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:204/255.0 green:193/255.0 blue:203/255.0 alpha:1];
    dataSource = [[NSMutableArray alloc]init];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(reFresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = [self createImagesScroll];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self createNavigationBarItems];
    [self requestData];
}


- (ImagesScrollView *)createImagesScroll
{
    ImagesScrollView *imagesScroll = [[ImagesScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 230)];
    imagesScroll.delegate = self;
    [imagesScroll refreshData];
    return imagesScroll;
}

- (NSInteger)numberOfImages:(ImagesScrollView *)imagesScrollView
{
    return 1;
}

- (Content *)imagesScrollView:(ImagesScrollView *)imagesScrollView dataForImageAtindex:(NSInteger)index
{
    Content *content = [[Content alloc]init];
    content.title = self.desc;
    UIImageView *img = [[UIImageView alloc]init];
    [img sd_setImageWithURL:[NSURL URLWithString:self.imgPath]];
    content.imageView = img;
    return content;
}

- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView didSelectImageAtIndex:(NSInteger)index
{
    
}

- (void)createNavigationBarItems
{
    self.navigationItem.title = self.ttitle;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"left_btn_normal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"left_btn_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(showSide) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}



- (void)showSide
{
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished)
     {
         
     }];
}

- (void)reFresh
{
    [self requestData];
}


- (void)requestData
{
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",self.iid];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if(dataSource.count != 0)
        {
            [dataSource removeAllObjects];
        }
        
        NSArray *array = [responseObject objectForKey:@"stories"];
        
        for (NSDictionary *dic in array)
        {
            OtherDetailModel *model = [[OtherDetailModel alloc]init];
            model.iid = [dic objectForKey:@"id"];
            model.title = [dic objectForKey:@"title"];
            model.imgPath = [[dic objectForKey:@"images"] firstObject];
            [dataSource addObject:model];
        }
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [self.refreshControl endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherDetailModel *model = [dataSource objectAtIndex:indexPath.row];
    
    if(model.imgPath != nil)
    {
        return 100;
    }
    else
    {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if(cell == nil)
    {
        cell = [[OtherDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    OtherDetailModel *model = [dataSource objectAtIndex:indexPath.row];
    
    for(UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    [cell setCell:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailController *controller = [[DetailController alloc]init];
    controller.iid = [[dataSource objectAtIndex:indexPath.row] iid];
    [self.navigationController pushViewController:controller animated:YES];
}

@end


