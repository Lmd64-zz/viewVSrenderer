#import "RegionCircleView.h"

@interface RegionCircleView ()
@property (nonatomic,strong) CAShapeLayer *shape;
@end

@implementation RegionCircleView

// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark mark - lifecycle methods
// //////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCircle:(MKCircle *)circle{
    
    self = [super initWithCircle:circle];
    
    if (self){

        double mapRadius = self.circle.radius * MKMapPointsPerMeterAtLatitude([[self overlay] coordinate].latitude);

        self.shape = [CAShapeLayer layer];
        [self.layer addSublayer:self.shape];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rect = CGRectMake(0, 0, mapRadius * 2 , mapRadius * 2 );
        CGPathAddEllipseInRect(path, NULL, rect);
        self.shape.fillColor = [UIColor colorWithWhite:0.0 alpha:0.333].CGColor;
        self.shape.path = path;
        CGPathRelease(path);

    }
    return self;
}

@end
