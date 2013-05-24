//
//  AnimalViewController.m
//  notteco
//
//  Created by Hisayo on 2013/01/18.
//  Copyright (c) 2013年 Hisayo. All rights reserved.
//

#import "AnimalViewController.h"
#import "SGSelectViewController.h"

@interface AnimalViewController ()
@end

@implementation AnimalViewController{
    SGSelectViewController  *_sg;
}

// 横向き
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
- (void)viewDidLoad
{
    _sg = [[SGSelectViewController alloc]init];
    
    [self.view addSubview:_sg.view];
    [_sg sgViewAppear];
    
    AppDelegate *d = [[UIApplication sharedApplication]delegate];
    [d setDelegate:self];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSelectedIcon:(NSString*)sender{
    NSLog(@"delegate");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
