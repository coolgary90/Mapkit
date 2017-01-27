//
//  ViewController.h
//  Mapkit
//
//  Created by Amanpreet Singh on 27/01/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>

@property( weak,nonatomic) IBOutlet MKMapView *mapView;



@end

