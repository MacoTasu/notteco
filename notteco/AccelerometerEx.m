#import "AccelerometerEx.h"
#import "AnimalViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

#define FILTERING_FACTOR 0.1

@implementation AccelerometerEx{
    UILabel*  _label;
    float     _aX;
    float     _aY;
    float     _aZ;
    NSString* _orientation;
    UIImage*  _image;
    __strong AccelerometerEx *_acce;
    NSString* right;
    NSString* left;
}

// 横向き
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//AudioPlayerの生成
- (AVAudioPlayer*)makeAudioPlayer:(NSString*)res {
    NSString* path=[[NSBundle mainBundle] pathForResource:res ofType:@""];
    NSURL* url=[NSURL fileURLWithPath:path];
    
    return [[[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL] autorelease];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    backbtn.hidden = YES;
    
    [super viewDidLoad];
    
    NSLog(@"viewDid");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"flg"];
    [defaults synchronize];
    
    //BGM
    _player01= [[self makeAudioPlayer:@"train.wav"] retain];
    _player02= [[self makeAudioPlayer:@"select.mp3"] retain];

    //写真とるよの画像を設定
    backimage.image = [UIImage imageNamed:@"takeapic.png"];
    imageview1.userInteractionEnabled = YES; //画像のタッチを許可するよ
    imageview1.multipleTouchEnabled = YES; //いろんなタッチの方法を許可するよ
    
    UITapGestureRecognizer *singleTap1 = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTap:)]autorelease];
    [imageview1 addGestureRecognizer:singleTap1];
    
    imageview2.userInteractionEnabled = YES; //画像のタッチを許可するよ
    imageview2.multipleTouchEnabled = YES; //いろんなタッチの方法を許可するよ
    
    UITapGestureRecognizer *singleTap2 = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTap:)]autorelease];
    [imageview2 addGestureRecognizer:singleTap2];
    
    AppDelegate* d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [d setDelegate2:self];
}

-(void)didSelectedIcon:(id)sender{
    
    AppDelegate* d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if([(NSString*)d.delegateWitch isEqualToString:@"left"]){
        imageviewleft.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",(NSString*)sender]];
        d.delegateLeft = (NSString*)sender;
        NSLog(@"%@",d.delegateLeft);
    }else{
        imageviewright.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",(NSString*)sender]];
        d.delegateRight = (NSString*)sender;
        NSLog(@"%@",d.delegateRight);
    }
}

-(void)leftTap:(UIGestureRecognizer *)gesture{
    AnimalViewController *m = [[AnimalViewController alloc]initWithNibName:@"AnimalViewController" bundle:nil];
    m.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:m animated:YES completion:nil];
    [m release];
    
    AppDelegate* d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    d.delegateWitch = @"left";
}

-(void)rightTap:(UIGestureRecognizer *)gesture{
    AnimalViewController *m = [[AnimalViewController alloc]initWithNibName:@"AnimalViewController" bundle:nil];
    m.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:m animated:YES completion:nil];
    [m release];
    
    AppDelegate* d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    d.delegateWitch = @"right";
}


-(void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [_player02 play];
    _player02.numberOfLoops = -1;
    
    if(![[defaults objectForKey:@"flg"] isEqualToString:@"1"] || faceimage.image == nil){
        // ソースタイプを決定する
        UIImagePickerControllerSourceType   sourceType = 0;
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        // 使用可能かどうかチェックする
        if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            return;
        }
        
        // イメージピッカーを作る
        UIImagePickerController*    imagePicker;
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        //imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kao.png"]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imagePicker.cameraOverlayView = imageview;

        [defaults setObject:@"1" forKey:@"flg"];
        [defaults synchronize];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
         //出発ボタンの画像を設定
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_go.png"] forState:UIControlStateNormal];
    }
    
    [super viewDidAppear:YES];
}

//メモリの解放
- (void)dealloc {
    [_label release];
    [_orientation release];
    [imageviewleft release];
    [imageviewright release];
    [faceimage release];
    [super dealloc];
}


//加速度通知時に呼ばれる
- (void)accelerometer:(UIAccelerometer*)accelerometer
        didAccelerate:(UIAcceleration*)acceleration {

    //加速度にローパスフィルタをあてる
    _aX=(acceleration.x*FILTERING_FACTOR)+(_aX*(1.0-FILTERING_FACTOR));
    _aY=(acceleration.y*FILTERING_FACTOR)+(_aY*(1.0-FILTERING_FACTOR));
    _aZ=(acceleration.z*FILTERING_FACTOR)+(_aZ*(1.0-FILTERING_FACTOR));
    
    if((_aY<-0.5 || 0.5<_aY) && [_acce retainCount] == 0){
        if(!_acce){
            NSLog(@"ふつうでござるっ");
            _acce = [[AccelerometerEx alloc]init];
        }
        [_acce changeAnimation:nil];
    }
}

//泣くアニメーションを動かすメソッド
-(void)changeAnimation:(id)sender{
        NSLog(@"よばれた");
        [UIView animateWithDuration:3 animations:^(void){
        NSLog(@"なくっ");
        
        //------------------
        // left
        //------------------
        [imageviewleft stopAnimating];
        UIImage *im1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sad00.png",left]];
        UIImage *im2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sad01.png",left]];
        UIImage *im3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sad02.png",left]];
        NSArray *ims = @[im1, im2, im3,im1, im2, im3 ,im1, im2, im3  ];
        imageviewleft.animationImages = ims;
        imageviewleft.animationDuration = 0.7; //0.7ぐらいがちょうどいい！
        imageviewleft.animationRepeatCount = 0;
        [imageviewleft startAnimating];
        
        //------------------
        // right
        //------------------
        [imageviewright stopAnimating];
        UIImage *im5 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sad00.png",right]];
        UIImage *im6 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sad01.png",right]];
        UIImage *im7 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sad02.png",right]];
        NSArray *imss = @[im5, im6, im7];
        imageviewright.animationImages = imss;
        imageviewright.animationDuration = 0.7; //0.7ぐらいがちょうどいい！
        imageviewright.animationRepeatCount = 0;
        [imageviewright startAnimating];
        
        
    } completion:^(BOOL finished){
        //-----------------
        // right
        //-----------------
        UIImage *im1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal01.png",right]];
        UIImage *im2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",right]];
        UIImage *im3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal02.png",right]];
        UIImage *im4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",right]];
        NSArray *ims = @[im1, im2, im3, im4];
        imageviewright.animationImages = ims;
        imageviewright.animationDuration = 0.7; //0.7ぐらいがちょうどいい！
        imageviewright.animationRepeatCount = 0;
        [imageviewright startAnimating];
        
        //------------------
        // left
        //------------------
        UIImage *im5 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal01.png",left]];
        UIImage *im6 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",left]];
        UIImage *im7 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal02.png",left]];
        UIImage *im8 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",left]];
        NSArray *imss = @[im5, im6, im7,im8];
        imageviewleft.animationImages = imss;
        imageviewleft.animationDuration = 0.7; //0.7ぐらいがちょうどいい！
        imageviewleft.animationRepeatCount = 0;
        [imageviewleft startAnimating];
        
        if([_acce retainCount]!= 0)
            _acce = nil;
    }];
}

-(IBAction)start:(id)sender{
    
    
    AppDelegate* d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if(d.delegateLeft && d.delegateRight){
         backbtn.hidden = NO;
        [_player02 stop];
        [_player01 play];
        _player01.numberOfLoops = -1;
        
        btn.hidden = YES;
        //スタートした時にこれ回す
        //値の初期化
        _aX=0;
        _aY=0;
        _aZ=0;
        _orientation=@"";
        
        //加速度通知の開始(1)
        UIAccelerometer* accelermeter= [UIAccelerometer sharedAccelerometer];
        accelermeter.updateInterval=0.1f;
        accelermeter.delegate=self;
        
        //端末回転通知の開始(4)
        [[UIDevice currentDevice]
         beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didRotate:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        
        //------------------------
        // right
        //------------------------
        UIImage *im1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal01.png",(NSString*)d.delegateRight]];
        UIImage *im2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",(NSString*)d.delegateRight]];
        UIImage *im3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal02.png",(NSString*)d.delegateRight]];
        UIImage *im4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",(NSString*)d.delegateRight]];
        NSArray *ims = @[im1, im2, im3, im4];
        imageviewright.animationImages = ims;
        imageviewright.animationDuration = 0.7; //0.7ぐらいがちょうどいい！
        imageviewright.animationRepeatCount = 0;
        imageviewright.contentMode = UIViewContentModeScaleAspectFit;
        [imageviewright startAnimating];  // アニメーションを開始したい時に呼ぶ
        
        //------------------------
        // left
        //------------------------
        UIImage *im5 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal01.png",(NSString*)d.delegateLeft]];
        UIImage *im6 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",(NSString*)d.delegateLeft]];
        UIImage *im7 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal02.png",(NSString*)d.delegateLeft]];
        UIImage *im8 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal00.png",(NSString*)d.delegateLeft]];
        NSArray *imss = @[im5, im6, im7, im8];
        imageviewleft.animationImages = imss;
        imageviewleft.animationDuration = 0.7; //0.7ぐらいがちょうどいい！
        imageviewleft.animationRepeatCount = 0;
        imageviewleft.contentMode = UIViewContentModeScaleAspectFit;
        [imageviewleft startAnimating];  // アニメーションを開始したい時に呼ぶ
    }else{
        // 複数行で書くボテン
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"あれれ？";
        alert.message = @"おともだちを２ひきのせてね！";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // イメージピッカーを隠す
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // オリジナル画像を取得する
    UIImage*    originalImage;
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 画像を表示する
    faceimage.image = originalImage;
    
    //写真とるよの画像を設定
    backimage.image = [UIImage imageNamed:@"train.png"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    // イメージピッカーを隠す
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)backBtn:(id)sender{
    
    backbtn.hidden = YES;
    
    ViewController *viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
    
    //BGMとめたいぜ
    [_player01 stop];
}


@end