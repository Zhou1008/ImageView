# ImageView
简单快速实现刮刮乐功能
目前很多项目中都会用到“刮刮乐”这个功能点，处于此整理出了一套比较easy的实现方法。

在这里我主要用到了ImageMaskView这个类，下面来说说具体操作：

将项目中的Tools工具直接拖入到工程，ImageMaskView类作为VC的一个属性并遵循ImageMaskFilledDelegate的代理方法：

    @interface ViewController ()<ImageMaskFilledDelegate>
    @property(nonatomic, strong)ImageMaskView *baseImage;

图片的有两层，第一层为上面的覆盖层_baseImage，第二层为刮刮乐刮开后显示的图片层beforeImage：
      
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

实现基本UI后，设置画笔半径radius大小：

    //设置画笔的半径
      _baseImage.radius = 10;
调用ImageMaskView的beginInteraction方法：

    // Initialization code
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.imageMaskFilledDelegate = self.imageMaskFilledDelegate ? self.imageMaskFilledDelegate : nil;
    self.radius = self.radius > 0 ? self.radius : 20;

    // Initalize bitmap context
    CGSize size = self.image.size;
    self.colorSpace = CGColorSpaceCreateDeviceRGB();
    self.imageContext = CGBitmapContextCreate(0,size.width,
                                              size.height,
                                              8,
                                              size.width*4,
                                              colorSpace,
                                              kCGImageAlphaPremultipliedLast	);
    CGContextDrawImage(self.imageContext, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);

    int blendMode = kCGBlendModeClear;
    CGContextSetBlendMode(self.imageContext, (CGBlendMode) blendMode);

    tilesX = size.width / (2 * self.radius);
    tilesY = size.height / (2 * self.radius);

    self.maskedMatrix = [[Matrix alloc] initWithMax:MySizeMake(tilesX, tilesY)];
    self.tilesFilled = 0;

最重要的是要要设置代理：
  
    _baseImage.imageMaskFilledDelegate = self;

实现代理方法：

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

GIF图片：


博客地址，点击[这里](http://www.jianshu.com/p/ce89d62654f7)
