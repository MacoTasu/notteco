#import <UIKit/UIKit.h>



@protocol Delegate <NSObject>
-(void)didSelectedIcon:(id)sender;
@end


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (assign)id delegateWitch;
@property (assign)id <Delegate>delegate;
@property (assign)id <Delegate>delegate2;
@property (assign)id delegateLeft;
@property (assign)id delegateRight;

@end
