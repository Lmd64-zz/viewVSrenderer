#import "MKGeometryExtensions.h"

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@implementation MKGeometryExtensions

//CGFloat CGPointDistanceBetween(CGPoint p1, CGPoint p2){
//    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p2.y,2));
//}
//
//CLLocationCoordinate2D MKCoordinateOffsetFromCoordinate(CLLocationCoordinate2D coordinate,
//                                                        CLLocationDistance offsetLatMeters,
//                                                        CLLocationDistance offsetLongMeters) {
//    MKMapPoint offsetPoint = MKMapPointForCoordinate(coordinate);
//    CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(coordinate.latitude);
//    offsetPoint.y += offsetLatMeters / metersPerPoint;
//    offsetPoint.x += offsetLongMeters / metersPerPoint;
//    CLLocationCoordinate2D offsetCoordinate = MKCoordinateForMapPoint(offsetPoint);
//    return offsetCoordinate;
//}
//
//
//double getZoomScaleForMapView(MKMapView *mapview){
//    CLLocationDegrees longitudeDelta = mapview.region.span.longitudeDelta;
//    CGFloat mapWidthInPixels = mapview.bounds.size.width;
//    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (45.0 * mapWidthInPixels);
//    return zoomScale;
//}

@end
