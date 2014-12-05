//
//  PPSViewController.m
//  PPSTest1
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 DigitalOcean. All rights reserved.
//

#import "PPSViewController.h"
#import "PPSSignatureView.h"

@interface PPSViewController ()
{
    PPSSignatureView *_ppsSignView;
}

@end

@implementation PPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _ppsSignView = [[PPSSignatureView alloc] initWithFrame:self.view.bounds context:context];
    _ppsSignView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_ppsSignView];
    
    UIButton *snap = [UIButton buttonWithType:UIButtonTypeCustom];
    snap.frame = CGRectMake(self.view.frame.size.width * 0.5 - 100, self.view.frame.size.height - 80, 200, 40);
    snap.backgroundColor = [UIColor redColor];
    [snap setTitle:@"点击获取图片并缩放" forState:UIControlStateNormal];
    [snap setTitle:@"缩放吧" forState:UIControlStateDisabled];
    [snap addTarget:self action:@selector(closePPSAndMovePinchImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:snap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePPSAndMovePinchImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_ppsSignView.snapshot];
    imageView.frame = _ppsSignView.frame;
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    imageView.userInteractionEnabled = YES;
    [_ppsSignView removeFromSuperview];
    
    UIPanGestureRecognizer *aPn = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [imageView addGestureRecognizer:aPn];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePinch:)];
    [imageView addGestureRecognizer:pinchGestureRecognizer];
    
    [self.view addSubview:imageView];
    
}

- (void) move:(UIPanGestureRecognizer *)aGesture{
    if (aGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [aGesture locationInView:self.view];
        [self.view bringSubviewToFront:aGesture.view];
        aGesture.view.center=translation;
    }
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

@end
