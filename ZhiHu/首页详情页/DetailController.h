
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface DetailController : UIViewController

{
    UIWebView *webView;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) NSString *iid;

@end


