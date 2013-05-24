#import "ViewController.h"
#import "AccelerometerEx.h"

@interface ViewController ()
-(IBAction)startBtn;
@property(nonatomic,strong)AVAudioPlayer *audio;

@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 横向き
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //start bgm
    NSString *path = [[NSBundle mainBundle] pathForResource:@"top" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audio= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audio play];
    _audio.numberOfLoops = -1;
    
    [self loadSounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     AudioServicesDisposeSystemSoundID(soundId);
    // Dispose of any resources that can be recreated.
}


-(IBAction)startBtn{
    
    AccelerometerEx *acceView = [[AccelerometerEx alloc]initWithNibName:@"AccelerometerEx" bundle:nil];
    [self presentViewController:acceView animated:YES completion:nil];
    
    //stop bgm
    [_audio stop];
    [self beep];
}

-(void)beep
{
    //音を鳴らす。
    AudioServicesPlaySystemSound(soundId);
}


-(void) loadSounds
{
    //パス取得
    NSString*path = [[NSBundle mainBundle] pathForResource:@"enter" ofType:@"mp3"];
    NSURL*url = [NSURL fileURLWithPath:path];
    //ロード
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
}


@end
