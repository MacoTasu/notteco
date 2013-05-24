//
//  SGSelectViewController.m
//  SGSelectViewController
//
//  Created by Maco_Tasu on 12/11/18.
//  Copyright (c) 2012年 MacoTasu. All rights reserved.
//

#import "SGSelectViewController.h"
#import "AppDelegate.h"

@interface SGSelectViewController ()
- (id)init;
- (void)setImage;
- (void)loadImage;
- (void)viewDetail;
- (void)changeIcon:(id)sender;
- (void)highlightButton:(UIButton *)btn;
- (void)sgViewDissAppear;
- (void)endAnimation;
- (void)didEnd;
@end

#define VIEW_ORIGIN_X 28
#define VIEW_ORIGIN_Y 60
#define BUTTOM_MARGIN 0
#define TOP_MARGIN 3
#define MARGIN_X 10
#define MARGIN_Y 0


//-------------------------
// You should change the following two sizes
//    if you want to change the number of a party's icons or icons sizes.
//-------------------------
#define BTN_W_H 130
#define ONE_ROW_ICON 3

//-------------------------
// The number of buttons needs to be the same as the number of [NSDictionary count].
// Under the present circumstances, it is OK to 20 pieces.
//-------------------------
#define BUTTON_COUNT 6

@implementation SGSelectViewController{
    __strong NSArray *_ar;
    __strong NSArray *_arr;
    NSInteger _iconNumber;
    NSMutableArray *_iconArray;
    UIButton *_btn[BUTTON_COUNT];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //-------------------------
        // initialize
        //-------------------------
        [self setView:[[UIView alloc] init]];
        _iconArray = [[NSMutableArray alloc]init];
        _iconNumber = -1;
        
    }
    return self;
}

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        [self setImage];
        [self viewDetail];
        [self loadImage];
        
    }
    
    return self;
}


#pragma Icon

//-------------------------
// Set-Icon
//-------------------------
-(void)setImage{
    
    _ar = [NSArray arrayWithObjects:
           @"btn_cat",
           @"btn_dog",
           @"btn_goat",
           @"btn_horse",
           @"btn_monkey",
           @"btn_pig",nil];
    
    _arr = [NSArray arrayWithObjects:
           @"cat",
           @"dog",
           @"goat",
           @"horse",
           @"monkey",
           @"pig",nil];
}


#pragma self.view

//-------------------------
// self.view setting
//-------------------------
-(void)viewDetail{
    
    //x is Row count
    int x = 0;
    
    if([_ar count] % ONE_ROW_ICON != 0)
        x = [_ar count]/ONE_ROW_ICON + 1;
    else
        x = [_ar count]/ONE_ROW_ICON ;
    
    [self.view setAlpha:0.0];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    if( w == 480 ) {
        [self.view setFrame:CGRectMake(0, VIEW_ORIGIN_Y, 480, BUTTOM_MARGIN + (BTN_W_H+MARGIN_Y)*x)];
    } else {
        [self.view setFrame:CGRectMake(0, VIEW_ORIGIN_Y, 568, BUTTOM_MARGIN + (BTN_W_H+MARGIN_Y)*x)];
    }
    [self.view setClipsToBounds:true];
}




#pragma Menu Button

//-------------------------
// Icon load&set
//-------------------------
-(void)loadImage{
    
    _iconArray = [_ar mutableCopy];
    
    int index = 0;
    int row = 0;
    int count = 0;
    for (NSString *tmpStr in _iconArray){
        
        if(count<BUTTON_COUNT){
            _btn[count] = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btn[count] setFrame:CGRectMake(((((self.view.bounds.size.width-(BTN_W_H*ONE_ROW_ICON))/ONE_ROW_ICON)*index+1)+13),TOP_MARGIN+(MARGIN_Y+BTN_W_H)*row, BTN_W_H, BTN_W_H)];
            [_btn[count] setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_iconArray objectAtIndex:count]]] forState:UIControlStateNormal];
            [_btn[count] addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
            [_btn[count] setTag:count];
            [self.view addSubview:_btn[count]];
            
            index++;
            count++;
            
            if(index%ONE_ROW_ICON == 0){
                row++;
                index = 0;
            }
        }
        
    }
    
}


//-------------------------
// Icon change action
//-------------------------
-(void)changeIcon:(id)sender{
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}


//-------------------------
// HighLight Button
//-------------------------
-(void)highlightButton:(UIButton *)btn{
    
    for(int i = 0; i < BUTTON_COUNT; i++){
        
        int x = _btn[i].tag;
        
        if(btn.tag == x){
            _btn[x].highlighted = NO;
            [_btn[i] setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on.png",[_iconArray objectAtIndex:i]]] forState:UIControlStateNormal];
            _iconNumber = x;
        }
        else{
            //_btn[i].highlighted = YES;
            [_btn[i] setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_iconArray objectAtIndex:i]]] forState:UIControlStateNormal];
        }
    }
    
    [self performSelector:@selector(didEnd) withObject:nil afterDelay:0.1];
}


#pragma OK Button&Animation

//---------------------------
// DisAppear sgView animation
//---------------------------
-(void)sgViewDissAppear{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    [self.view setAlpha:0.0];
    
    [UIView commitAnimations];
}

//-------------------------
// Appear sgView animation
//-------------------------
-(void)sgViewAppear{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil];
    
    [self.view setAlpha:1.0];
    
    [UIView commitAnimations];
}

//-------------------------
// Tap OK Button Action
//-------------------------
-(void)didEnd{
    
    
    AppDelegate* d = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //[self sgViewDissAppear];
    [d.delegate didSelectedIcon:nil];
    [d.delegate2 didSelectedIcon:[_arr objectAtIndex:_iconNumber]];
  
}


//-------------------------
// After end animaiton
//-------------------------
-(void)endAnimation{

}



#pragma view cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
