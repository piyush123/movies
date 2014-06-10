//
//  MoviesViewController.m
//  rottenTomatoes
//
//  Created by piyush shah on 6/8/14.
//  Copyright (c) 2014 onor inc. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieDetailController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MoviesViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet
    UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@end
@implementation MoviesViewController

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
    
    // Configure the title
    self.navigationItem.title = @"Movies";
    
    self.tableView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURL *baseURL = [NSURL URLWithString:url];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    

    AFHTTPRequestOperationManager *httpmanager = [AFHTTPRequestOperationManager manager];
    [httpmanager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //   NSLog(@"JSON: %@", responseObject);
        self.movies = responseObject[@"movies"];
        
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
   
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 130;
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)handleRefresh:(id)sender
{
    // do your refresh here...
    NSLog(@"doing refresh");
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
   numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    

    NSDictionary *movie = self.movies[indexPath.row];
    
    movieCell.titleLabel.text = movie[@"title"];
    movieCell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *castList = @"";
    
    NSArray *cast = movie[@"abridged_cast"];
    
    for (NSDictionary *castInfo in cast) {
        castList = [castList stringByAppendingFormat:@",%@",castInfo[@"name"]];
       // NSLog(castInfo[@"name"]);
    }
    
    NSDictionary *posters = movie[@"posters"];
    
    NSString *thumbnail_string = [posters objectForKey:@"thumbnail"];
    
    NSURL *thumbnail = [[NSURL alloc]initWithString:thumbnail_string];
    
    [movieCell.posterView setImageWithURL:thumbnail];
    
    return movieCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailController *vc = [[MovieDetailController alloc] init];
    NSLog(@"entering");
    NSDictionary *movie = self.movies[indexPath.row];
    
    vc.movie = movie;
    [self.navigationController pushViewController:vc animated:YES ];
    NSLog(@"got here");
}


@end
