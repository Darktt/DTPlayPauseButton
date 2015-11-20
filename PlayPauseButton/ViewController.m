//
//  ViewController.m
//  PlayPauseButton
//
//  Created by Darktt on 15/11/13.
//  Copyright © 2015年 Darktt. All rights reserved.
//

#import "ViewController.h"
#import "DTPlayPauseButton.h"

@interface ViewController ()
{
    IBOutlet DTPlayPauseButton *_playPauseButton;
}

- (IBAction)playPauseHandler:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playPauseHandler:(DTPlayPauseButton *)sender
{
    NSLog(@"%@", sender.playing? @"Playing": @"Paused");
    
    if (sender.playing) {
        UIColor *tintColor = [UIColor redColor];
        
        [sender setTintColor:tintColor];
    } else {
        UIColor *tintColor = [UIColor whiteColor];
        
        [sender setTintColor:tintColor];
    }
}

@end
