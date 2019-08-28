//
//  CameraViewController.m
//  BankCardRecog
//


#import "PlateIDCameraViewController.h"
#import "PlateIDOverView.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
#import "PlateIDOCR.h"
#endif

#import "PlateResult.h"
#import "PlateFormat.h"
//#import "PlateIDResultViewController.h"

#import <CoreMotion/CoreMotion.h>
#import "PlateIDSlider.h"

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kFocalScale 1.0
#define kResolutionWidth 1920
#define kResolutionHeight 1080

//底部安全高度
#define KSAFEBOTTOMEHEIGHT ((kScreenHeight==812.0 || kScreenHeight==896.0)? 34:20)
//头部安全高度
#define KSAFETOPEHEIGHT ((kScreenHeight==812.0 || kScreenHeight==896.0)? 44:20)

int nRotate = 1;

@interface PlateIDCameraViewController ()<UIAlertViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureDevice *_device;
    AVCaptureConnection *_videoConnection;
    
    PlateIDOverView *_overView;
    BOOL _on;
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    PlateIDOCR *_plateIDRecog;
#endif
    UIButton *_flashBtn;
    UIButton *_backButton;
    UIButton *_photoBtn;
    UILabel *_tipsLabel;
    
    //识别结果
    NSArray *_results;
    //识别帧图像
    UIImage *_image;
    
    CAShapeLayer *_maskWithHole;//预览界面覆盖的半透明层
    
    
    
}
@property (assign, nonatomic) BOOL adjustingFocus;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic,assign) BOOL isProcessingImage;
//动作管理器指针
@property(nonatomic,strong)CMMotionManager *manager;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic, assign) CGRect recogArea;//设置识别区域


@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preview;

@property(nonatomic,strong)PlateIDSlider *slider;
@property(nonatomic,strong)UIImageView *panView;
@end

@implementation PlateIDCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _results = [NSArray array];
    
    //初始化识别框
    _overView = [[PlateIDOverView alloc] initWithFrame:self.view.bounds];
    
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
    
    
    //初始化识别核心
    [self initRecog];
    
    //初始化相机
    [self initialize];
#endif
    
}


#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kScreenWidth < 330) {
        self.adjustingFocus = YES;
    }
    self.navigationController.navigationBarHidden = YES;
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    //注册通知,观察是否聚焦成功
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    
    [_session startRunning];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.manager = [[CMMotionManager alloc] init];
    if (_manager.accelerometerAvailable == YES) {
        _manager.accelerometerUpdateInterval = 1.0;
        [_manager startAccelerometerUpdates];
    }else{
        NSLog(@"设备不支持加速计");
    }
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:weakSelf selector:@selector(updateDisPlay) userInfo:nil repeats:YES];
}



- (void)updateDisPlay{
    if (_manager.accelerometerAvailable == YES) {
        CMAccelerometerData *accelerometerData = _manager.accelerometerData;
        //重力加速度三维分量
        //                        NSLog(@"%f\n,%f\n,%f\n",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
        if (accelerometerData.acceleration.x > -0.4 && accelerometerData.acceleration.x < 0.4) {
            nRotate = 1;
            _overView.nrotate = nRotate;
            _overView.smallrect = [_overView setRecogAreaWithNrotate:nRotate];
            [self drawShapeLayerWithSmallrect:_overView.smallrect First:NO];
            _overView.maxrect = [_overView getMaxrect];
            [self resetControlFrameWithNrotate:nRotate maxrect:_overView.maxrect];
            _tipsLabel.transform = CGAffineTransformMakeRotation(0);
        }else if(accelerometerData.acceleration.x > -1 && accelerometerData.acceleration.x <-0.6){
            nRotate = 0;
            _overView.nrotate = nRotate;
            _overView.smallrect = [_overView setRecogAreaWithNrotate:nRotate];
            [self drawShapeLayerWithSmallrect:_overView.smallrect First:NO];
            _overView.maxrect = [_overView getMaxrect];
            [self resetControlFrameWithNrotate:nRotate maxrect:_overView.maxrect];
            _tipsLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else if (accelerometerData.acceleration.x > 0.6 && accelerometerData.acceleration.x < 1){
            nRotate = 2;
            _overView.nrotate = nRotate;
            _overView.smallrect = [_overView setRecogAreaWithNrotate:nRotate];
            [self drawShapeLayerWithSmallrect:_overView.smallrect First:NO];
            _overView.maxrect = [_overView getMaxrect];
            [self resetControlFrameWithNrotate:nRotate maxrect:_overView.maxrect];
            _tipsLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
            
        }
        
        //        else if (accelerometerData.acceleration.x > -0.2 && accelerometerData.acceleration.x < 0){
        //            //                        _videoConnection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        //
        //            nRotate = 3;
        //            _overView.nrotate = nRotate;
        //            _overView.smallrect = [_overView setRecogAreaWithNrotate:nRotate];
        //            [self drawShapeLayerWithSmallrect:_overView.smallrect First:NO];
        //            _overView.maxrect = [_overView getMaxrect];
        //            [self resetControlFrameWithNrotate:nRotate maxrect:_overView.maxrect];
        //            _tipsLabel.transform = CGAffineTransformMakeRotation(M_PI);
        //        }

        
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
   [_session stopRunning];

}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    
    [_device lockForConfiguration:nil];
    if (_on) {
        [_device setTorchMode: AVCaptureTorchModeOff];
    }
    [_device unlockForConfiguration];
    
    [_manager stopAccelerometerUpdates];
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer =nil;
    }
}

//初始化识别核心
- (void) initRecog
{
    _plateIDRecog = [[PlateIDOCR alloc] init];
    /*在此填写开发码，初始化识别核心*/
    int init = [_plateIDRecog initPalteIDWithDevcode:@"5YYX5LQS5PIT5RO" RecogType:self.recogMode];
    NSLog(@"\n核心初始化返回值 = %d\n返回值为0成功 其他失败\n\n常见错误：\n-10601 开发码错误\n核心初始化方法- (int) initPalteIDWithDevcode: (NSString *)devcode RecogType:(int) type;参数为开发码\n\n-10602 Bundle identifier错误\n-10605 Bundle display name错误\n-10606 CompanyName错误\n请检查授权文件（wtproject.lsc）绑定的信息与Info.plist中设置是否一致!!!",init);
    
    //车牌识别设置
    [_plateIDRecog setPlateFormat:[self getPlateFormat]];
    
}

//车牌识别设置
- (PlateFormat *)getPlateFormat {
    PlateFormat *plateFormat = [[PlateFormat alloc] init];
    /*
     *************用到哪个设置哪个，设置越多，识别越慢,阈值必须设置
     armpolice;// 单层武警车牌是否开启:1是；0不是
     armpolice2;// 双层武警车牌是否开启:1是；0不是
     embassy;// 使馆车牌是否开启:1是；0不是
     individual;// 是否开启个性化车牌:1是；0不是
     nOCR_Th;// 识别阈值(取值范围0-9,2:默认阈值   0:最宽松的阈值   9:最严格的阈值)  ***必须设置
     int nPlateLocate_Th;//定位阈值(取值范围0-9,5:默认阈值   0:最宽松的阈值  9:最严格的阈值) ***必须设置
     int tworowyellow;//双层黄色车牌是否开启:1是；0不是
     int tworowarmy;// 双层军队车牌是否开启:1是；0不是
     NSString *szProvince;// 省份顺序
     int mtractor;// 农用车车牌是否开启:1是；0不是
     civilAviation;// 民航车牌是否开启：1是；0不是
     consulate;// 领事馆车牌是否开启：1是；0不是
     newEnergy;// 新能源车牌是否开启：1是；0不是
     */
    
    plateFormat.nOCR_Th = 2;
    plateFormat.nPlateLocate_Th = 5;
    plateFormat.armpolice = 1;
    plateFormat.armpolice2 = 1;
    plateFormat.embassy = 1;
    plateFormat.individual = 1;
    plateFormat.tworowarmy = 1;
    plateFormat.tworowyellow = 1;
    plateFormat.consulate = 1;
    plateFormat.newEnergy = 1;
    return plateFormat;
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
}

//初始化相机
- (void) initialize
{
    //判断摄像头授权
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在iOS '设置-隐私-相机' 中打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == AVCaptureDevicePositionBack){
            _device = device;
            _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    [_session addInput:_captureInput];
    
    ///out put
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    //    dispatch_release(queue);
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [_session addOutput:captureOutput];
    
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    
    for (AVCaptureConnection *connection in captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                _videoConnection = connection;
                break;
            }
        }
        if (_videoConnection) { break; }
    }
    
    [_session addOutput:_captureOutput];
    
    //设置相机预览层
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_preview];
    [_session startRunning];
    
    //设置覆盖层
    [self drawShapeLayerWithSmallrect:_overView.smallrect First:YES];
    
    _overView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_overView];
    //
    // 拍照按钮
    if (self.isPphotographRecog) {
        _photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-30,kScreenHeight-60-KSAFEBOTTOMEHEIGHT,60, 60)];
        [_photoBtn setImage:[UIImage imageNamed:@"take_pic_btn.png"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(photoBtn) forControlEvents:UIControlEventTouchUpInside];
        [_photoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.view addSubview:_photoBtn];
    }
    
    
    //9.创建slider
    _slider = [[PlateIDSlider alloc] init];
    [self resetControlFrameWithNrotate:1 maxrect:[_overView getMaxrect]];
    _slider.minimumValue = 1.0;
    _slider.maximumValue = 9.0;
    _slider.value = 1.0;
    _slider.continuous = YES;
    _slider.minimumTrackTintColor = [UIColor colorWithRed:80/250.0 green:205/250.0 blue:204/250.0 alpha:1.0];
    _slider.maximumTrackTintColor = [UIColor colorWithRed:142/250.0 green:142/250.0 blue:142/250.0 alpha:1.0];
    [_slider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"camera_back.png"] forState:UIControlStateNormal];
    _backButton.frame = CGRectMake(10, KSAFETOPEHEIGHT, 40, 40);
    [_backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    //闪光灯按钮
    _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flashBtn setImage:[UIImage imageNamed:@"camera_flash_on.png"] forState:UIControlStateNormal];
    [_flashBtn setImage:[UIImage imageNamed:@"camera_flash_off.png"] forState:UIControlStateSelected];
    _flashBtn.frame = CGRectMake(kScreenWidth-50, KSAFETOPEHEIGHT, 40, 40);
    [_flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashBtn];
    _on = NO;
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.frame = CGRectMake(0, 0, 300, 30);
    CGPoint center = self.view.center;
    _tipsLabel.center = center;
    _tipsLabel.text = @"请将车牌对准此取景框";
    _tipsLabel.textColor = [UIColor whiteColor];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_tipsLabel];
}

- (void)photoBtn {
    self.isProcessingImage = YES;
    
}

//从摄像头缓冲区获取图像
#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (self.isPphotographRecog) {
        if (self.isProcessingImage) {
            //快门声音
            AudioServicesPlaySystemSound(1108);
            
            //获取当前图片
            UIImage *tempImage = [self imageFromSampleBuffer:sampleBuffer];
            
            //停止取景
            [_session stopRunning];
            
            //调用核心识别方法
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self readyToGetImageEx:tempImage];
            });
            
            return;

        }

    } else {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        
        self.recogArea = [self setRecogParametersAndCropFrameWithRect:_overView.smallrect];
        
        //识别车牌图像
        _results = [_plateIDRecog recogImageWithBuffer:baseAddress recogCount:1 nWidth:(int)width nHeight:(int)height recogRange:self.recogArea confidence:75 nRotate:nRotate nScale:1];
        if (_results.count > 0) {
            // 停止取景
            [_session stopRunning];
            
            //根据当前帧数据生成UIImage图像，保存图像使用
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            
            CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,bytesPerRow, colorSpace, kCGBitmapByteOrder32Little |kCGImageAlphaPremultipliedFirst);
            
            CGImageRef quartzImage = CGBitmapContextCreateImage(context);
            CGContextRelease(context);
            CGColorSpaceRelease(colorSpace);
            /*
             该图片用于快速模式，即初始化设置为0时使用。
             */
            UIImage *img = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
            CGImageRelease(quartzImage);
            _image = [self getImgByNrotate:nRotate :img];
            //识别完成，展示结果
            [self performSelectorOnMainThread:@selector(showResults) withObject:nil waitUntilDone:NO];
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);

    }
}

// 拍照识别获取最终结果
- (void)readyToGetImageEx:(UIImage *)img {
    _results = [_plateIDRecog recogWithImage:img recogCount:1 nRotate:nRotate];
    NSString *allResult = @"";
    PlateResult *plateResult1;
    for (PlateResult *plateResult in _results) {
        
        allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"车牌号:%@\n 车牌颜色:%@ 可信度:%d 识别时间%d\n", plateResult.license, plateResult.color,plateResult.nConfidence, plateResult.nTime]];
        NSLog(@"%@", allResult);
        
        plateResult1 = plateResult;
        
    }
    
//    PlateIDResultViewController *result = [[PlateIDResultViewController alloc] init];
//    result.plateResult = plateResult1;
//    UIImage *finallImg = [self getImgByNrotate:nRotate :img];
//    result.img = finallImg;
//    [self.navigationController pushViewController:result animated:YES];
//    self.isProcessingImage = NO;
}

// 扫描识别获取最终结果
- (void) showResults
{
    
    NSString *allResult = @"";
    for (PlateResult *plateResult in _results) {
        
        allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"车牌号:%@\n 车牌颜色:%@ 可信度:%d 识别时间%d\n", plateResult.license, plateResult.color,plateResult.nConfidence, plateResult.nTime]];
        NSLog(@"%@", allResult);
        
        /*
         若采用精准模式识别，即初始化设置参数为2，才有图片返回值
         */
        UIImage *image = plateResult.nCarImage;
        
//        PlateIDResultViewController *result = [[PlateIDResultViewController alloc] init];
//        result.plateResult = plateResult;
//        if (self.recogMode == 2) {
//            result.img = image;
//        }else {
//            result.img = _image;
//        }
//        [self.navigationController pushViewController:result animated:YES];
    }
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_session startRunning];
}

//闪光灯按钮点击事件
- (void)openFlash:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (![_device hasTorch]) {
        //NSLog(@"no torch");
    }else{
        [_device lockForConfiguration:nil];
        if (!_on) {
            [_device setTorchMode: AVCaptureTorchModeOn];
            _on = YES;
        }else{
            [_device setTorchMode: AVCaptureTorchModeOff];
            _on = NO;
        }
        [_device unlockForConfiguration];
    }
}

- (void) backToMain
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)sliderValueChanged:(UISlider *)paramSender{
    if ([paramSender isEqual:_slider]) {
        //        NSLog(@"New value=%f",paramSender.value);
        [CATransaction begin];
        [CATransaction setAnimationDuration:.1];
        [_preview setAffineTransform:CGAffineTransformMakeScale(paramSender.value, paramSender.value)];
        [CATransaction commit];
        
    }
}

//重绘覆盖层
- (void)drawShapeLayerWithSmallrect:(CGRect)samllrect First:(BOOL)isFirst{
    if (!_maskWithHole) {
        _maskWithHole = [CAShapeLayer layer];
    }
    
    CGRect biggerRect = self.view.bounds;
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen] scale] >= 2) {
        offset = 0.5;
    }
    
    //设置检边视图层
    CGRect smallFrame = samllrect;
    CGRect smallerRect = CGRectInset(smallFrame, -offset, -offset) ;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [_maskWithHole setPath:[maskPath CGPath]];
    [_maskWithHole setFillRule:kCAFillRuleEvenOdd];
    [_maskWithHole setFillColor:[[UIColor colorWithWhite:0 alpha:0.35] CGColor]];
    if (isFirst) {
        [self.view.layer addSublayer:_maskWithHole];
        [self.view.layer setMasksToBounds:YES];
    }
    
}

//重置控件位置
- (void)resetControlFrameWithNrotate:(int)nrotate maxrect:(CGRect)maxrect {
    if (nrotate == 1) {
        _slider.nrotate = nrotate;
        _slider.frame = CGRectZero;
        _slider.transform = CGAffineTransformMakeRotation(0);
        _backButton.transform = CGAffineTransformMakeRotation(0);
        _flashBtn.transform = CGAffineTransformMakeRotation(0);
        if (self.isPphotographRecog) {
            _photoBtn.transform = CGAffineTransformMakeRotation(0);
        }
        _slider.frame = CGRectMake(maxrect.origin.x, maxrect.origin.y + maxrect.size.height + 60, maxrect.size.width, 20);
        
    }else if (nrotate == 3) {
        _slider.nrotate = nrotate;
        _slider.frame = CGRectZero;
        _slider.transform = CGAffineTransformMakeRotation(-M_PI);
        if (self.isPphotographRecog) {
            _photoBtn.transform = CGAffineTransformMakeRotation(M_PI);
        }
        _slider.frame = CGRectMake(maxrect.origin.x, maxrect.origin.y - 60, maxrect.size.width, 20);
        
    }else if (nrotate == 2) {
        _slider.nrotate = nrotate;
        _slider.frame = CGRectZero;
        
        _slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _backButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        _flashBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
        if (self.isPphotographRecog) {
            _photoBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        _slider.frame = CGRectMake(maxrect.origin.x + maxrect.size.width + 30, maxrect.origin.y, 20, maxrect.size.height);
        
    } else {
        _slider.nrotate = nrotate;
        _slider.frame = CGRectZero;
        _slider.transform = CGAffineTransformMakeRotation(M_PI_2);
        _backButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        _flashBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
        if (self.isPphotographRecog) {
            _photoBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        _slider.frame = CGRectMake(maxrect.origin.x - 50, maxrect.origin.y, 20, maxrect.size.height);
    }
}

//数据帧转图片
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(quartzImage);
    
    return (image);
}

// 设置识别区域
- (CGRect)setRecogParametersAndCropFrameWithRect:(CGRect)rect {
    CGFloat tWidth = (kFocalScale-1)*kScreenWidth*0.5;
    CGFloat tHeight = (kFocalScale-1)*kScreenHeight*0.5;
    
    CGPoint pLTopPoint = CGPointMake((CGRectGetMinX(rect)+tWidth)/kFocalScale, (CGRectGetMinY(rect)+tHeight)/kFocalScale);
    CGPoint pLDownPoint = CGPointMake((CGRectGetMinX(rect)+tWidth)/kFocalScale, (CGRectGetMaxY(rect)+tHeight)/kFocalScale);
    CGPoint pRTopPoint = CGPointMake((CGRectGetMaxX(rect)+tWidth)/kFocalScale, (CGRectGetMinY(rect)+tHeight)/kFocalScale);
    CGPoint pRDownPoint = CGPointMake((CGRectGetMaxX(rect)+tWidth)/kFocalScale, (CGRectGetMaxY(rect)+tHeight)/kFocalScale);
    
    
    CGFloat sTop = 0.0, sBottom = 0.0, sLeft = 0.0, sRight = 0.0;
    CGPoint iLTopPoint,iLDownPoint,iRTopPoint,iRDownPoint;
    
    
    iLTopPoint = [_preview captureDevicePointOfInterestForPoint:pRTopPoint];
    iLDownPoint = [_preview captureDevicePointOfInterestForPoint:pLTopPoint];
    iRTopPoint = [_preview captureDevicePointOfInterestForPoint:pRDownPoint];
    iRDownPoint = [_preview captureDevicePointOfInterestForPoint:pLDownPoint];
    
    CGRect recogArea;
    if (nRotate == 3 || nRotate == 1) {
        sTop = iLTopPoint.x*kResolutionWidth;
        sBottom = iRTopPoint.x*kResolutionWidth;
        sLeft = (1-iLDownPoint.y)*kResolutionHeight;
        sRight = (1-iLTopPoint.y)*kResolutionHeight;
        recogArea = CGRectMake(sLeft, sTop, sRight - sLeft, sBottom - sTop);
    } else if (nRotate == 0) {
        sTop = iLTopPoint.y*kResolutionHeight;
        sBottom = iLDownPoint.y*kResolutionHeight;
        sLeft = iLTopPoint.x*kResolutionWidth;
        sRight = iRTopPoint.x*kResolutionWidth;
        recogArea = CGRectMake(sLeft, sTop, sRight - sLeft, sBottom - sTop);
    } else if (nRotate == 2){
        sTop = (1 - iLDownPoint.y)*kResolutionHeight;
        sBottom = (1-iLTopPoint.y)*kResolutionHeight;
        sLeft = (1 - iRTopPoint.x)*kResolutionWidth;
        sRight = (1 - iLTopPoint.x)*kResolutionWidth;
        recogArea = CGRectMake(sLeft, sTop, sRight - sLeft, sBottom - sTop);
        
    }
    
    return recogArea;
    
}

- (UIImage *)getImgByNrotate:(int)nRotate :(UIImage *)image {
    
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (nRotate) {
        case 3:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case 1:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case 2:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    //    CGContextRelease(context);
    UIGraphicsEndImageContext();
    return newPic;
}

- (void)dealloc {
    [_plateIDRecog uninitPlateIDSDK];
}
#endif


@end
