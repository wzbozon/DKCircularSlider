//
//  DKViewController.m
//  DKCircularSlider
//
//  Created by Dennis Kutlubaev on 09/21/2017.
//

#import "DKViewController.h"


@interface DKViewController ()

@end


@implementation DKViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.circularSlider.clipsToBounds = NO;
    self.circularSlider.layer.masksToBounds = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
