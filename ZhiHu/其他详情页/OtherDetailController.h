
#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "AFNetworking.h"
#import "OtherDetailModel.h"
#import "ImagesScrollView.h"
#import "OtherDetailCell.h"
#import "UIImageView+WebCache.h"
#import "DetailController.h"

@interface OtherDetailController : UITableViewController <ImagesScrollViewDelegate>
{
    NSMutableArray *dataSource;
}

@property (nonatomic, strong) NSString *iid;
@property (nonatomic, strong) NSString *ttitle;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imgPath;

@property (nonatomic, strong) MMDrawerController *drawerController;

@end


