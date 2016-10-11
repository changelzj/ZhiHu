
#import "SideTableView.h"

@implementation SideTableView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        dataSource = [[NSMutableArray alloc]init];
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.tableHeaderView = [self createHeaderView];
        
        [self requestData];
    }
    return self;
}





- (UIView *)createHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 190)];
    headerView.backgroundColor = [UIColor colorWithRed:22/255.0 green:160/255.0 blue:237/255.0 alpha:1];
    
    UIButton *touxiang = [UIButton buttonWithType:UIButtonTypeCustom];
    touxiang.frame = CGRectMake(10, 30, 40, 40);
    
    [touxiang setBackgroundImage:[UIImage imageNamed:@"menu_avatar.png"] forState:UIControlStateNormal];
    [touxiang setBackgroundImage:[UIImage imageNamed:@"menu_avatar.png"] forState:UIControlStateHighlighted];
    
    touxiang.layer.cornerRadius = 20;
    [headerView addSubview:touxiang];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(55, 38.5, 70, 25)];
    name.textColor = [UIColor whiteColor];
    name.text = @"请登录";
    [headerView addSubview:name];
    
    UIImageView *favImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90, 40, 40)];
    favImg.image = [UIImage imageNamed:@"favorites.png"];
    [headerView addSubview:favImg];
    
    UIButton *favBT = [UIButton buttonWithType:UIButtonTypeCustom];
    favBT.frame = CGRectMake(33, 90, 90, 40);
    [favBT setTitle:@"我的收藏" forState:UIControlStateNormal];
    [favBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView addSubview:favBT];
    
    UIImageView *dlImg = [[UIImageView alloc]initWithFrame:CGRectMake(125, 90, 40, 40)];
    dlImg.image = [UIImage imageNamed:@"download.png"];
    [headerView addSubview:dlImg];
    
    UIButton *dlBT = [UIButton buttonWithType:UIButtonTypeCustom];
    dlBT.frame = CGRectMake(145, 90, 90, 40);
    [dlBT setTitle:@"离线下载" forState:UIControlStateNormal];
    [dlBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView addSubview:dlBT];
    
    UIView *homeView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, self.frame.size.width, 50)];
    homeView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoHome)];
    
    [homeView addGestureRecognizer:tap];
    [headerView addSubview:homeView];
    
    
    UIImageView *homeImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 35, 35)];
    homeImg.image = [UIImage imageNamed:@"home.png"];
    [homeView addSubview:homeImg];
    
    UILabel *homeLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 7.5, 100, 35)];
    homeLab.textColor = headerView.backgroundColor;
    homeLab.text = @"首页";
    [homeView addSubview:homeLab];
    
    
    return headerView;
}





- (void)requestData
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"http://news-at.zhihu.com/api/4/themes" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
         NSArray *others = [responseObject objectForKey:@"others"];
         for (NSDictionary *dic in others)
         {
             SideModel *model = [[SideModel alloc]init];
             model.name = [dic objectForKey:@"name"];
             model.iid = [dic objectForKey:@"id"];
             model.ddescription = [dic objectForKey:@"description"];
             model.thumbnail = [dic objectForKey:@"thumbnail"];
             
             [dataSource addObject:model];
         }
        [self reloadData];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
         
    }];
}



- (void)gotoHome
{
    HomeController *homeController = [[HomeController alloc]init];
    homeController.drawerController = self.drawerController;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:homeController];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0 green:160/255.0 blue:237/255.0 alpha:1];
    navController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.drawerController setCenterViewController:navController];
    
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished)
     {
         
     }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SideModel *model = [dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[[OtherDetailController alloc]init]];
    
    navController.navigationBar.tintColor = [UIColor whiteColor];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0 green:160/255.0 blue:237/255.0 alpha:1];
    navController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    OtherDetailController *otherDetailController = navController.viewControllers.firstObject;
    otherDetailController.drawerController = self.drawerController;
    
    SideModel *model = [dataSource objectAtIndex:indexPath.row];
    
    otherDetailController.iid = model.iid;
    otherDetailController.ttitle = model.name;
    otherDetailController.desc = model.ddescription;
    otherDetailController.imgPath = model.thumbnail;
    
    [self.drawerController setCenterViewController:navController];
    
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished)
     {
         
     }];
}



- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if(scrollView.contentOffset.y < 0)
    {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}


@end




