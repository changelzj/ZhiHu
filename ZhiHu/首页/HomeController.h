
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ImagesScrollView.h"
#import "DetailController.h"
#import "HomeCell.h"
#import "HomeModel.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MMDrawerController.h"

@interface HomeController : UITableViewController <ImagesScrollViewDelegate>

{
    NSMutableArray *dataSource;
    NSMutableArray *imagesAndTitles;
        
    UIView *sideBackView;
    ImagesScrollView *imagesScroll;
        
    BOOL isLoadMore;
    NSString *lastdate;
}

@property (nonatomic, strong) MMDrawerController *drawerController;

@end


