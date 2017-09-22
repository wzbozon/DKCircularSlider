//
//  DKViewController.h
//  DKCircularSlider
//
//  Created by Dennis Kutlubaev on 09/21/2017.
//

@import UIKit;
@import DKCircularSlider;


@interface DKViewController : UIViewController

@property (nonatomic, weak) IBOutlet DKCircularSlider *circularSlider;
@property (nonatomic, weak) IBOutlet UILabel *presetTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *degreeLabel;
@property (nonatomic, weak) IBOutlet UISlider *allowedMaxValueSlider;

- (IBAction)increaseValueClicked:(id)sender;

- (IBAction)decreaseValueClicked:(id)sender;

- (IBAction)disableClicked:(id)sender;

- (IBAction)sliderValueChanged:(id)sender;

- (IBAction)allowedMaxValueSliderValueChanged:(id)sender;

- (IBAction)constantValueSwitched:(id)sender;

@end
