//
//  DKCircularSlider.m
//  CircularSlider
//
//  Created by Dennis Kutlubaev on 4/9/13.
//

#import "DKCircularSlider.h"

#define MIN_ANGLE -M_PI/6
#define MAX_ANGLE (7*M_PI)/6

// Converts degrees to radians.
#define degreesToRadians(angleDegrees) (angleDegrees * M_PI / 180.0)

// Converts radians to degrees.
#define radiansToDegrees(angleRadians) (angleRadians * 180.0 / M_PI)

@interface DKCircularSlider()

@property (nonatomic, assign) CGFloat knobAngle;

@property (nonatomic, assign) NSInteger maxRadius;

@property (nonatomic, assign) NSInteger barRadius;

@end


@implementation DKCircularSlider

static CGPoint barCenter, knobCenter;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //if (self.value == 0) self.value = floor((self.maxValue + self.minValue) / 2);
    
    // Calclulate initial angle from initial value
    float percentDone = 1 - (self.value - self.minValue) / (self.maxValue - self.minValue);
    self.knobAngle = MIN_ANGLE+(percentDone*(MAX_ANGLE-MIN_ANGLE));
}


- (void)drawRect:(CGRect)rect
{
    //gets bar and knob coordinates based on the rectangle they're being drawn in
    barCenter.x = CGRectGetMidX(rect);
    barCenter.y = CGRectGetMidY(rect);
    self.maxRadius = (CGRectGetHeight(rect) <= CGRectGetWidth(rect))?CGRectGetHeight(rect)/2:CGRectGetWidth(rect)/2; //gets the width or height, whichever is smallest, and stores it in radius
    self.barRadius = self.maxRadius * 0.9;
    
    //finds the center of the knob by converting from polar to cartesian coordinates
    knobCenter.x = barCenter.x+(self.barRadius*cosf(self.knobAngle));
    knobCenter.y = barCenter.y-(self.barRadius*sinf(self.knobAngle));
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw the slider bar
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //GContextAddArc(context,barCenter.x,barCenter.y,self.barRadius,fmodf(MIN_ANGLE+M_PI, 2*M_PI),fmodf(-knobAngle, 2*M_PI),0);
    //CGContextDrawPath(context, kCGPathStroke);
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //CGContextAddArc(context,barCenter.x,barCenter.y,self.barRadius,fmodf(-knobAngle, 2*M_PI),fmodf(MAX_ANGLE+M_PI, 2*M_PI),0);
    //CGContextAddArc(context,barCenter.x,barCenter.y,self.barRadius*1.05,fmodf(MIN_ANGLE, 2*M_PI),fmodf(MAX_ANGLE+M_PI, 2*M_PI),0);
    //CGContextClip(context);
    CGContextAddArc(context,barCenter.x,barCenter.y,self.barRadius,fmodf(MIN_ANGLE+M_PI, 2*M_PI),fmodf(MAX_ANGLE+M_PI, 2*M_PI),0);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    //draw the knob
    if (! self.disabled)
    {
        CGContextSetLineWidth(context, 1.0);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0 , 1), 1.0, [UIColor blackColor].CGColor);
        CGContextAddArc(context, knobCenter.x, knobCenter.y, self.knobRadius, 0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFill);
        CGContextRestoreGState(context);
    }
    
    /*
     //draw gradient in the knob
     CGContextClip(context);
     CGPoint knobTop = {knobCenter.x, knobCenter.y-self.knobRadius}, knobBottom = {knobCenter.x, knobCenter.y+self.knobRadius};
     CGFloat locations[2] = {0.0 ,1.0};
     CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects:[UIColor lightGrayColor].CGColor, [UIColor whiteColor].CGColor, nil];
     CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
     CGGradientRef gradient = CGGradientCreateWithColors(colorSpc, colors, locations);
     
     CGContextDrawLinearGradient(context, gradient, knobTop, knobBottom, 0);
     //CGContextDrawRadialGradient(context, gradient, knobCenter, self.knobRadius*.5, knobCenter, self.knobRadius, 0);
     */
    //CGContextDrawPath(context, kCGPathStroke);
    //CGContextDrawPath(context, kCGPathFill);
    
    // Min and Max value labels
    if (! self.disabled)
    {
        // Polar -> Cartesian coordinates
        double phi2 = MIN_ANGLE;
        double phi1 = MAX_ANGLE;
        //double x = self.barRadius + self.barRadius * cos(phi1);
        //double y = self.barRadius - self.barRadius * sin(phi1);
        CGPoint P1 = CGPointMake(self.maxRadius + self.barRadius * cos(phi1), self.maxRadius - self.barRadius * sin(phi1));
        CGPoint P2 = CGPointMake(self.maxRadius + self.barRadius * cos(phi2), self.maxRadius - self.barRadius * sin(phi2));
        
        // Dots
        CGContextSetLineWidth(context, 5.0);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        
        CGContextAddArc(context, P1.x, P1.y, 5, 0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextAddArc(context, P2.x, P2.y, 5, 0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFill);
        
        NSString *minValueString = [NSString stringWithFormat:@"%ld", self.minValue];
        NSString *maxValueString = [NSString stringWithFormat:@"%ld", self.maxValue];
        
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor] };
        NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:minValueString attributes:attributes];
        [attributedString1 drawAtPoint:CGPointMake(P1.x - 5, P1.y + 20)];
        
        NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithString:maxValueString attributes:attributes];
        [attributedString2 drawAtPoint:CGPointMake(P2.x - 5, P2.y + 20)];
    }
}


- (void)setValue:(NSInteger)value
{
    _value = value;
    
    NSAssert(value >= self.minValue && value <= self.maxValue, @"Начальное значение не может быть больше максимума и меньше минимума");
    float percentDone = 1 - (value - self.minValue)/(self.maxValue - self.minValue);
    self.knobAngle = MIN_ANGLE + (percentDone * (MAX_ANGLE - MIN_ANGLE));
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1)
        return;
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    self.isKnobBeingTouched = false;
    CGFloat xDist = touchLocation.x - knobCenter.x;
    CGFloat yDist = touchLocation.y - knobCenter.y;
    if (sqrt((xDist*xDist)+(yDist*yDist)) <= self.knobRadius * 3) //if the touch is within the slider knob
    {
        self.isKnobBeingTouched = true;
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isKnobBeingTouched)
    {
        CGPoint touchLocation = [[touches anyObject] locationInView:self];
        float touchVector[2] = {touchLocation.x-knobCenter.x, touchLocation.y-knobCenter.y}; //gets the vector of the difference between the touch location and the knob center
        float tangentVector[2] = {knobCenter.y-barCenter.y, barCenter.x-knobCenter.x}; //gets a vector tangent to the circle at the center of the knob
        float scalarProj = (touchVector[0]*tangentVector[0] + touchVector[1]*tangentVector[1])/sqrt((tangentVector[0]*tangentVector[0])+(tangentVector[1]*tangentVector[1])); //calculates the scalar projection of the touch vector onto the tangent vector
        self.knobAngle += scalarProj/self.barRadius;
        
        if (self.knobAngle > MAX_ANGLE) //ensure knob is always on the bar
            self.knobAngle = MAX_ANGLE;
        if (self.knobAngle < MIN_ANGLE)
            self.knobAngle = MIN_ANGLE;
        
        self.knobAngle = fmodf(self.knobAngle, 2*M_PI); //ensures knobAngle is always between 0 and 2*Pi
        
        [self setNeedsDisplay];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isKnobBeingTouched = false;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isKnobBeingTouched = false;
}


- (void)setKnobAngle:(CGFloat)knobAngle
{
    _knobAngle = knobAngle;
    
    float percentDone = 1 - (_knobAngle - MIN_ANGLE) / (MAX_ANGLE - MIN_ANGLE);

    _value = self.minValue + percentDone * (self.maxValue - self.minValue);
}


- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    
    [self setNeedsDisplay];
}


@end
