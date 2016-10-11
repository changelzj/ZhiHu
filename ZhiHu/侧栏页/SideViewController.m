
#import "SideViewController.h"

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation SideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.sideTable = [[SideTableView alloc]initWithFrame:CGRectMake(0, 0, 250, HEIGHT) style:UITableViewStylePlain];
    

    [self.view addSubview:self.sideTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
