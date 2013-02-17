#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AudioToolbox/AudioServices.h>

@interface AnimalViewController : UIViewController<Delegate>{
     SystemSoundID soundId;
}
@property(assign)id<Delegate>delegate;
@end
