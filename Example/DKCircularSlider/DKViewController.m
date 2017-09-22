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
    
    self.degreeLabel.text = @"\u00B0C";
    
    [self updateTemperatureLabel];
}


- (void)updateTemperatureLabel
{
    NSInteger value = self.circularSlider.constantValue ? self.circularSlider.constantValue : self.circularSlider.value;
    self.presetTempLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)increaseValueClicked:(id)sender
{
    NSInteger newValue = self.circularSlider.value + 5;
    self.circularSlider.value = newValue;
}


- (IBAction)decreaseValueClicked:(id)sender
{
    NSInteger newValue = self.circularSlider.value - 5;
    self.circularSlider.value = newValue;
}


- (IBAction)disableClicked:(id)sender
{
    self.circularSlider.enabled = ! self.circularSlider.enabled;
    
    self.degreeLabel.hidden = ! self.circularSlider.enabled;
    self.presetTempLabel.hidden = self.degreeLabel.hidden;
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = self.circularSlider.enabled ? @"Disable" : @"Enable";
    [button setTitle:buttonTitle forState:UIControlStateNormal];
}


- (IBAction)sliderValueChanged:(id)sender
{
    [self updateTemperatureLabel];
}


- (IBAction)allowedMaxValueSliderValueChanged:(id)sender
{
    self.circularSlider.maxAllowedValue = (long)self.allowedMaxValueSlider.value;
}


- (IBAction)constantValueSwitched:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    
    self.circularSlider.constantValue = switchView.on ? 5 : 0;
    
    [self updateTemperatureLabel];
}


@end
