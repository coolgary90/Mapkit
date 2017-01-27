//
//  ViewController.m
//  Mapkit
//
//  Created by Amanpreet Singh on 27/01/17.
//  Copyright © 2017 Amanpreet Singh. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "SecondViewController.h"

@interface ViewController ()
{
    MKPointAnnotation *pins;
    NSMutableArray *allPins;
    CLLocationManager *locationManager;
    UIActivityIndicatorView *activity;
    
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate=self;
    allPins=[[NSMutableArray alloc]init];
    
    

   //31.1471, 75.3412
    
    //plotting multiple pins
    
    self.title=@"Map Tutorial";
    
    CLLocationCoordinate2D val1=CLLocationCoordinate2DMake(40.759011, -73.984472);
    pins=[[MKPointAnnotation alloc]init];
    pins.coordinate=val1;
    pins.title=@"Punjab";
    [allPins addObject:pins];

    //28.7041, 77.1025
    CLLocationCoordinate2D val2=CLLocationCoordinate2DMake(40.748441, -73.985564);
    pins=[[MKPointAnnotation alloc]init];
    pins.coordinate=val2;
    pins.title=@"Delhi";
    [allPins addObject:pins];
    [self.mapView addAnnotations:allPins];
   activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.color=[UIColor blackColor];
    activity.center=self.view.center;
    activity.transform=CGAffineTransformMakeScale(2.0, 2.0);
    [self.mapView addSubview:activity];
    
    
    [activity startAnimating];
    
    
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(val1, 2000, 2000)];
    [self.mapView setRegion:adjustedRegion animated:YES];

    
    MKDirectionsRequest *directionRequest=[[MKDirectionsRequest alloc]init];
    
    MKPlacemark *soucepoint=[[MKPlacemark alloc]initWithCoordinate:val1 ];
    MKMapItem *sourceItem=[[MKMapItem alloc]initWithPlacemark:soucepoint];
    MKPlacemark *destinationpoint=[[MKPlacemark alloc]initWithCoordinate:val2];
    MKMapItem *destinationtem=[[MKMapItem alloc]initWithPlacemark:destinationpoint];
    [directionRequest setSource:sourceItem];
    [directionRequest setDestination:destinationtem];
    
    MKDirections *direction=[[MKDirections alloc]initWithRequest:directionRequest];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response ,NSError *error)
     {
         
         
         NSLog(@"response = %@",response);
         NSArray *arrRoutes = [response routes];
         [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             
             MKRoute *rout = obj;
             
             MKPolyline *line = [rout polyline];
             
            
             [self.mapView addOverlay:line];
             NSLog(@"Rout Name : %@",rout.name);
             NSLog(@"Total Distance (in Meters) :%f",rout.distance);
             
             NSArray *steps = [rout steps];
             
             NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
             
             [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 NSLog(@"Rout Instruction : %@",[obj instructions]);
                 NSLog(@"Rout Distance : %f",[obj distance]);
             }];
         }];
         
         
     }];

    
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    [activity removeFromSuperview];
    [activity stopAnimating];
    
    return  renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
   
    if([annotation isKindOfClass:[MKPointAnnotation class]])
    {
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    

        return annotationView;}
    
    else if([annotation isKindOfClass:[MKUserLocation class]])
    {
        
        MKAnnotationView *annotaionNewView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userloc"];
//        annotaionNewView.image=[UIImage imageNamed:@"userLoc20.png"];
    
        
        
        return annotaionNewView;
    }
    else
    {
        return nil;
    }
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
  
    
    
    
    
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    CLLocationCoordinate2D val;
    val.latitude=[[view annotation] coordinate].latitude;
    val.longitude=[[view annotation]coordinate].longitude;
    NSString *titleval=[[view annotation] title];
    
    
    
    NSLog(@"value is %@", view.annotation);

    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *second=[storyboard instantiateViewControllerWithIdentifier:@"second"];
    second.name=titleval;
    
    [self.navigationController pushViewController:second animated:YES];
    
}
- (IBAction)btnUserLocationClicked:(id)sender {
    
    [self removeUserLocation];
    
//    [self.mapView removeAnnotation:self.mapView.userLocation];
    self.mapView.showsUserLocation=YES;
    locationManager=[[CLLocationManager alloc]init];
    [locationManager requestAlwaysAuthorization];
    CLLocationCoordinate2D coord;
    coord=self.mapView.userLocation.coordinate;
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=coord;
    annotation.title=@"User Loaction";
    [self.mapView addAnnotation:annotation];
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coord, 200, 200)];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
}

-(void)removeUserLocation
{
    for(id ann in _mapView.annotations)
    {
        if([ann isKindOfClass:[MKUserLocation class]])
        {
            [self.mapView removeAnnotation:ann];

        }
    }

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
