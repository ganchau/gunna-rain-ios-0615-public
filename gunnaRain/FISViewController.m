//
//  FISViewController.m
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import "Forecastr+CLLocation.h"

@interface FISViewController () <CLLocationManagerDelegate>
{
    Forecastr *forecastr;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FISViewController

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [forecastr flushCache];

	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
    
    
    
    
    
    forecastr = [Forecastr sharedManager];
    forecastr.apiKey = @"fdffcfd11938d772582eff5cef0295b7";
    
    [forecastr getForecastForLocation:self.locationManager.location
                                 time:nil
                           exclusions:nil
                               extend:nil
                              success:^(id JSON) {
                                  NSUInteger precipitationProbability = [JSON[@"currently"][@"precipProbability"] integerValue];
                                  if (precipitationProbability == 1) {
                                      self.weatherStatus.text = @"Yep";
                                      self.weatherStatus.textColor = [UIColor redColor];
                                  } else if (precipitationProbability == 0.5) {
                                      self.weatherStatus.text = @"Maybe";
                                      self.weatherStatus.textColor = [UIColor blackColor];
                                  } else {
                                      self.weatherStatus.text = @"Nope";
                                      self.weatherStatus.textColor = [UIColor greenColor];
                                  }
                                  NSLog(@"JSON Response was: %@", JSON);
                              }
                              failure:^(NSError *error, id response) {
                                  NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error
                                                                                              withResponse:response]);
                              }];

    
    
//    [forecastr getForecastForLatitude:45.5081
//                            longitude:-73.5550
//                                 time:nil
//                           exclusions:nil
//                               extend:nil
//                              success:^(id JSON) {
//                                  NSUInteger precipitationProbability = [JSON[@"currently"][@"precipProbability"] integerValue];
//                                  if (precipitationProbability == 1) {
//                                      self.weatherStatus.text = @"Yep";
//                                      self.weatherStatus.textColor = [UIColor redColor];
//                                  } else if (precipitationProbability == 0.5) {
//                                      self.weatherStatus.text = @"Maybe";
//                                      self.weatherStatus.textColor = [UIColor blackColor];
//                                  } else {
//                                      self.weatherStatus.text = @"Nope";
//                                      self.weatherStatus.textColor = [UIColor greenColor];
//                                  }
//                                  NSLog(@"JSON Response was: %@", JSON);
//                              }
//                              failure:^(NSError *error, id response) {
//                                  NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error
//                                                                                              withResponse:response]);
//                              }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"Longitude: %@\nLatitude: %@", longitude, latitude);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
