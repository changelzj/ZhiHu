
#import "DetailController.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation DetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:webView];
    
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.square = YES;
    [self.view addSubview:hud];
    
    [self requestData];
}




- (void)requestData
{
    [self showHUD];
    
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@",self.iid];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSString *imagePath = [responseObject objectForKey:@"image"];
        NSString *title = [responseObject objectForKey:@"title"];
        
        NSString *CSS = [[responseObject objectForKey:@"css"] firstObject];
        CSS = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"%@\" type=\"type/css\"/>",CSS];
        
        NSString *HTML = [responseObject objectForKey:@"body"];
        
        HTML = [HTML stringByReplacingOccurrencesOfString:@"<div class=\"img-place-holder\"></div>"
                 withString:[NSString stringWithFormat:@"<div style='width:100%%; height:250px; background-image:url(%@); background-size:cover;'> <div style='position:absolute; top:180px; left:10px; font-size:20px; color:white; height:50px;'>%@</div></div>",imagePath,title]];
        
        HTML = [NSString stringWithFormat:@"%@%@",CSS,HTML];
        
        [webView loadHTMLString:HTML baseURL:nil];
        
         [self hideHUD];
    }
     
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
         [self hideHUD];
    }];
}


- (void)showHUD
{
    
    hud.label.text = NSLocalizedString(@"正在加载", @"");
    
    [hud showAnimated:YES];
}

- (void)hideHUD
{
    [hud hideAnimated:YES afterDelay:2];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
