//
//  CameraViewController.h
//  BankCardRecog
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>

@interface PlateIDCameraViewController : UIViewController
@property (nonatomic, assign) int recogMode; //识别类型
@property (nonatomic, assign) BOOL isPphotographRecog;// 是否是拍照识别
@end
