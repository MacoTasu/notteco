#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface AccelerometerEx : UIViewController <UIAccelerometerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,Delegate>{
    IBOutlet UIImageView *imageviewleft;
    IBOutlet UIImageView *imageviewright;
    IBOutlet UIImageView *imageview1;
    IBOutlet UIImageView *imageview2;
    IBOutlet UIImageView *faceimage;
    IBOutlet UIImageView * backimage;
    IBOutlet UIButton *btn;
    IBOutlet UIButton *backbtn;

    AVAudioPlayer* _player01;
    AVAudioPlayer* _player02;
}
-(IBAction)start:(id)sender;
-(IBAction)backBtn:(id)sender;

@end
