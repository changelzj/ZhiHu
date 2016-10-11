
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "SideModel.h"
#import "MMDrawerController.h"
#import "HomeController.h"
#import "OtherDetailController.h"

@interface SideTableView : UITableView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

{
    NSMutableArray *dataSource;
}

@property (nonatomic, strong) MMDrawerController *drawerController;

@end
