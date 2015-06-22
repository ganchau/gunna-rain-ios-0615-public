//
//  FISViewController.m
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import "Forecastr.h"

@interface FISViewController ()
{
    Forecastr *forecastr;
}

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    
    forecastr = [Forecastr sharedManager];
    forecastr.apiKey = @"fdffcfd11938d772582eff5cef0295b7";
    
    [forecastr getForecastForLatitude:45.5081
                            longitude:-73.5550
                                 time:nil
                           exclusions:nil
                               extend:nil
                              success:^(id JSON) {
                                  if ([JSON[@"currently"][@"precipProbability"] integerValue] == 1) {
                                      self.weatherStatus.text = @"Yep";
                                  } else {
                                      self.weatherStatus.text = @"Nope";
                                  }
                                  NSLog(@"JSON Response was: %@", JSON);
                              }
                              failure:^(NSError *error, id response) {
                                  NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error
                                                                                              withResponse:response]);
                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
