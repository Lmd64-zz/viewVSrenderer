#import <MapKit/MapKit.h>
#import "MKGeometryExtensions.h"
#import "RegionEditorViewController.h"
#import "RegionCircleView.h"
#import "RegionCircleRenderer.h"

#define isQuickDeleteEnabled YES
#define canAddMultipleRegions NO

@interface RegionEditorViewController () <MKMapViewDelegate> {
    UIPanGestureRecognizer *panGestureRecognizer;
    UIButton *toggleOverlayButton;
    BOOL usingOverlays;
}
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic,strong) MKCircle *circle;
@property (nonatomic,assign) CLLocationCoordinate2D circleCoordinate;
@property (nonatomic,assign) CLLocationDistance circleRadius;
@property (nonatomic,strong) RegionCircleView *circleView;
@property (nonatomic,strong) RegionCircleRenderer *circleRenderer;
@end

@implementation RegionEditorViewController

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - view lifecycle methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad{
    [super viewDidLoad];

    _circleRadius = 1000;
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    [self.view addSubview:self.mapView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:@{@"mapView":self.mapView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:@{@"mapView":self.mapView}]];

    toggleOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleOverlayButton addTarget:self action:@selector(didTapToggleOverlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [toggleOverlayButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [toggleOverlayButton setTitle:@"Using Overlay" forState:UIControlStateNormal];
    [toggleOverlayButton setBackgroundColor:[UIColor lightGrayColor]];
    [toggleOverlayButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [toggleOverlayButton.layer setCornerRadius:4.0];
    [toggleOverlayButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.view addSubview:toggleOverlayButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[toggleOverlayButton]" options:0 metrics:nil views:@{@"toggleOverlayButton":toggleOverlayButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toggleOverlayButton]-|" options:0 metrics:nil views:@{@"toggleOverlayButton":toggleOverlayButton,@"toplayoutguide":self.topLayoutGuide}]];
    usingOverlays = YES;
    [self updateToggleOverlayButton];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanGesture:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.delaysTouchesEnded = NO;
    panGestureRecognizer.delaysTouchesBegan = NO;
    [self.mapView addGestureRecognizer:panGestureRecognizer];

}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - create circle methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createCircleAtCoordinate:(CLLocationCoordinate2D)coordinate{
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:_circleRadius];
    [self updateOverlayWithCircle:circle];
    [self centerMapViewOnCircle];
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - mapview delegate methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self createCircleAtCoordinate:userLocation.coordinate];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if (usingOverlays){
        if ([overlay isKindOfClass:[MKCircle class]]){
            MKCircle *circle = (MKCircle*)overlay;
            self.circleView = [[RegionCircleView alloc] initWithCircle:circle];
            return (MKOverlayRenderer*)self.circleView;
        }
    } else {
        if ([overlay isKindOfClass:[MKCircle class]]){
            MKCircle *circle = (MKCircle*)overlay;
            self.circleRenderer = [[RegionCircleRenderer alloc] initWithCircle:circle];
            [self.circleRenderer setFillColor:[UIColor colorWithWhite:0.0 alpha:0.333]];
            return (RegionCircleRenderer*)self.circleRenderer;
        }
    }
    return nil;
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - pan gesture method
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPanGesture:(UIPanGestureRecognizer*)gesture{
    
    if ([gesture state]==UIGestureRecognizerStateChanged){
        CGPoint location = [gesture locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
        [self updateEditingRegionSizeWithHandleCoordinate:coordinate];
        
    } else if ([gesture state]==UIGestureRecognizerStateEnded){
        [self centerMapViewOnCircle];
    }
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - button methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didTapToggleOverlayButton:(id)sender{
    usingOverlays = !usingOverlays;
    [self updateToggleOverlayButton];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self createCircleAtCoordinate:_circleCoordinate];
}
- (void)updateToggleOverlayButton{
    if (usingOverlays){
        [toggleOverlayButton setTitle:@"Using MKOverlayView" forState:UIControlStateNormal];
    } else {
        [toggleOverlayButton setTitle:@"Using MKOverlayRenderer" forState:UIControlStateNormal];
    }
}

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - custom mapview methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateOverlayWithCircle:(MKCircle*)circle{
    _circleCoordinate = circle.coordinate;
    _circleRadius = circle.radius;
    
    [self.mapView removeOverlay:self.circle];
    if (usingOverlays){
        [self.mapView addOverlay:circle];
    } else {
        [self.mapView addOverlay:circle level:MKOverlayLevelAboveLabels];
    }
    self.circle = circle;
}

- (void)updateEditingRegionSizeWithHandleCoordinate:(CLLocationCoordinate2D)coordinate{
    CLLocation *coordinateLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:self.circle.coordinate.latitude longitude:self.circle.coordinate.longitude];
    CLLocationDistance radius = [centerLocation distanceFromLocation:coordinateLocation];
    if (radius==0){
        radius = _circleRadius;
    }
    _circleRadius = MAX(kMinimumRegionRadius,radius);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.circle.coordinate radius:_circleRadius];
    [self updateOverlayWithCircle:circle];
}

- (void)centerMapViewOnCircle{
    MKMapRect visibleMapRect = self.circle.boundingMapRect;
    if (self.circleRadius > 6000000){
        visibleMapRect = MKMapRectWorld;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.mapView setVisibleMapRect:visibleMapRect];
    }];
}

@end
