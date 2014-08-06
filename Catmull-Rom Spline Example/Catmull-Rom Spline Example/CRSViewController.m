//
//  CRSViewController.m
//  Catmull-Rom Spline Example
//
//  Created by John Yorke on 06/08/2014.
//  Copyright (c) 2014 John Yorke. All rights reserved.
//

#import "CRSViewController.h"

@interface CRSViewController ()

@property (strong, nonatomic) UIView *lineView;

@end

@implementation CRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    }
    
    [self createArrayAndAddToView];
}

- (void)createArrayAndAddToView
{
    self.lineView.layer.sublayers = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createArrayAndAddToView)];
    [self.lineView addGestureRecognizer:tap];
    
    [self.view addSubview:self.lineView];
    
    // Create a sample array of points
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    int numberOfPoints = 15;
    for (int i = 0; i <= numberOfPoints; i++) {
        int xSpacing = self.lineView.frame.size.width / numberOfPoints * i;
        int yRandom = arc4random() % 20;
        CGPoint point = CGPointMake(xSpacing, i * yRandom);
        [mutableArray addObject:[NSValue valueWithCGPoint:point]];
    }
    NSArray *points = [NSArray arrayWithArray:mutableArray];
    
    [self addBezierPathBetweenPoints:points toView:self.lineView withColor:[UIColor blackColor] andStrokeWidth:4];
}

- (void)addBezierPathBetweenPoints:(NSArray *)points
                            toView:(UIView *)view
                         withColor:(UIColor *)color
                    andStrokeWidth:(NSUInteger)strokeWidth
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float granularity = 100;
    
    [path moveToPoint:[[points firstObject] CGPointValue]];
    
    for (int index = 1; index < points.count - 2 ; index++) {
        
        CGPoint point0 = [[points objectAtIndex:index - 1] CGPointValue];
        CGPoint point1 = [[points objectAtIndex:index] CGPointValue];
        CGPoint point2 = [[points objectAtIndex:index + 1] CGPointValue];
        CGPoint point3 = [[points objectAtIndex:index + 2] CGPointValue];
        
        for (int i = 1; i < granularity ; i++) {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi;
            pi.x = 0.5 * (2*point1.x+(point2.x-point0.x)*t + (2*point0.x-5*point1.x+4*point2.x-point3.x)*tt + (3*point1.x-point0.x-3*point2.x+point3.x)*ttt);
            pi.y = 0.5 * (2*point1.y+(point2.y-point0.y)*t + (2*point0.y-5*point1.y+4*point2.y-point3.y)*tt + (3*point1.y-point0.y-3*point2.y+point3.y)*ttt);
            
//            if (pi.y > view.frame.size.width) {
//                pi.y = view.frame.size.width;
//            }
//            else if (pi.y < 0){
//                pi.y = 0;
//            }
            
            if (pi.x > point0.x) {
                [path addLineToPoint:pi];
            }
        }
        
        [path addLineToPoint:point2];
    }
    
    [path addLineToPoint:[[points objectAtIndex:[points count] - 1] CGPointValue]];
    
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    
    shapeView.path = [path CGPath];
    
    shapeView.strokeColor = color.CGColor;
    shapeView.fillColor = [UIColor clearColor].CGColor;
    shapeView.lineWidth = strokeWidth;
    [shapeView setLineCap:kCALineCapRound];
    
    [view.layer addSublayer:shapeView];
}


@end
