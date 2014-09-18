//
//  DetailViewController.m
//  RottenTomatoes
//
//  Created by Suraj Sirpilli on 9/17/14.
//  Copyright (c) 2014 jarusElyk. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterImg;
@property (weak, nonatomic) IBOutlet UITextView *mDetail;
@property (weak, nonatomic) IBOutlet UILabel *movieDetail;
@end

@implementation DetailViewController

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
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedView:)];
    [self.view addGestureRecognizer:swipe];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *desc = [userDefaults objectForKey:@"det"];
    self.mDetail.text = desc;
    NSString *imgURL = [userDefaults objectForKey:@"img"];
    [self.posterImg setImageWithURL:[NSURL URLWithString:imgURL]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) swipedView:(UISwipeGestureRecognizer*) recognizer {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
