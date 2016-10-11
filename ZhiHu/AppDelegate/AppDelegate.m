
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.window = [[UIWindow alloc]init];
    
    HomeController *homeController = [[HomeController alloc]init];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:homeController];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0 green:160/255.0 blue:237/255.0 alpha:1];
    navController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    SideViewController *side = [[SideViewController alloc]init];

    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:navController leftDrawerViewController:side];
    
    side.sideTable.drawerController = drawerController;
    homeController.drawerController = drawerController;
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setShowsShadow:YES];
    [drawerController setMaximumLeftDrawerWidth:250.0];

    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
