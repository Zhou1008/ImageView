//
//  ViewController.m
//  ImageView
//
//  Created by admin on 17/10/24.
//  Copyright © 2017年 voquan. All rights reserved.
//

#import "ViewController.h"
#import "ImageMaskView.h"

@interface ViewController ()<ImageMaskFilledDelegate>
@property(nonatomic, strong)ImageMaskView *baseImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *beforeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    beforeImage.frame = CGRectMake(10, 60, self.view.frame.size.width-20, 100);
    beforeImage.center = self.view.center;
    [self.view addSubview:beforeImage];
    
    beforeImage.layer.borderColor = [UIColor grayColor].CGColor;
    beforeImage.layer.borderWidth = 1;
    
    
    //创建ImageMaskView
    _baseImage = [[ImageMaskView alloc] initWithImage:[UIImage imageNamed:@"base"]];
    _baseImage.alpha = 1.0;
    _baseImage.frame = CGRectMake(10, 60, self.view.frame.size.width-20, 100);
    _baseImage.center = self.view.center;
    [self.view addSubview:_baseImage];
    
    //设置画笔的半径
    _baseImage.radius = 10;
    [_baseImage beginInteraction];
    _baseImage.imageMaskFilledDelegate = self;
}

#pragma mark ImageMaskFilledDelegate
- (void) imageMaskView:(ImageMaskView *)maskView clearPercentDidChanged:(float)clearPercent{
    if (clearPercent > 50) {
        [UIView animateWithDuration:2
                         animations:^{
                             _baseImage.userInteractionEnabled = NO;
                             _baseImage.alpha = 0;
                             _baseImage.imageMaskFilledDelegate = nil;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
