#import <UIKit/UIKit.h>
#import "RegionEditorViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RegionEditorViewController *regionEditorViewController;

@end
