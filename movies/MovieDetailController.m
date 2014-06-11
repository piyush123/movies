//
//  MovieDetailController.m
//  rottenTomatoes
//
//  Created by piyush shah on 6/9/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "MovieDetailController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import <MBProgressHUD.h>


@interface MovieDetailController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *poster;


@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;

@end

@implementation MovieDetailController

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
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"going to load MovieDetail");
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSDictionary *movie = self.movie;
    
    self.movieName.text = movie[@"title"];

    [[self movieName] setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [self.movieName sizeToFit];
    self.synopsis.text = movie[@"synopsis"];
    
    // Tell the label to use an unlimited number of lines
    [self.synopsis setNumberOfLines:0];
    [self.synopsis sizeToFit];
    
    NSDictionary *posters = movie[@"posters"];
    
    NSString *detailed_string = [posters objectForKey:@"detailed"];
       
    //Asynchronous image downloading must be implemented using the UIImageView category in the AFNetworking library.
    

    UIImageView *weakPoster = self.poster;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:detailed_string]];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.poster setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             NSLog(@"got image");
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             weakPoster.image = image;
                                             [weakPoster setNeedsLayout];
                                         } failure:nil];
    
    
    // recompute the size of the background view now that we know the height of the synopsis label
    CGRect newBackgroundViewFrame = self.backgroundView.frame;
    // note: the +200 adds padding to the bottom so that the background extends past the bottom of the label. we want some padding below the label, plus we want the background to extend past the end of the scroll view to cover the overscroll region.
    newBackgroundViewFrame.size.height = self.synopsis.frame.origin.y + self.synopsis.frame.size.height + 200;
    self.backgroundView.frame = newBackgroundViewFrame;

    
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.75;
    
    // now set the content height of the scroll view to the background view's y-offset+height
    // note: the -180 balances out most of the extra height we added to the background view above (now the actual bottom of the scroll view will be 20 pts past the last label, and the remaining 180 pts of the background view will extend past the end to cover the overscroll region)
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.backgroundView.frame.origin.y + self.backgroundView.frame.size.height - 180)];
    
    self.scrollView.backgroundColor = [UIColor clearColor ];
    self.scrollView.alpha = 0.75;
    
    NSLog(@"MOVIE: %@", movie);
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
