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
#import <MBProgressHUD/MBProgressHUD.h>

@interface MoviesViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet
    UITableView *tableView;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIView *errorView;
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

- (void)addErrorView
{
    CGRect  viewRect = CGRectMake(0, 0, 350, 30);
    
    _errorView = [[UIView alloc] initWithFrame:viewRect];
    _errorView.backgroundColor = [UIColor blueColor];
    
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    
    [yourLabel setText:@"network error"];
    
    [_errorView addSubview:yourLabel];
    NSLog(@"adding sub");
    [self.view addSubview:_errorView];
    [self.view bringSubviewToFront:_errorView];
    
    _errorView.hidden = true;
    NSLog(@"subbing");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the title
    self.navigationItem.title = @"Movies";
    
    self.tableView.delegate = self;
    
    [self addErrorView];
    
    
    // Do any additional setup after loading the view from its nib.
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";

   
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *httpmanager = [AFHTTPRequestOperationManager manager];
    [httpmanager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //   NSLog(@"JSON: %@", responseObject);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"fetching data");
        self.movies = responseObject[@"movies"];
        
        [self.tableView reloadData];
        
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
        _errorView.hidden = false;
        
    }];
   
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 130;
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
   }


- (void)refresh:(UIRefreshControl *)refreshControl {
    // do your refresh here...
    NSLog(@"doing refresh");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self viewDidLoad];

    [refreshControl endRefreshing];
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
    
   // NSURL *thumbnail = [[NSURL alloc]initWithString:thumbnail_string];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:thumbnail_string]];
    
//    [movieCell.posterView setImageWithURL:thumbnail];
    
    MovieCell *weakMovieCell = movieCell;
    
    [movieCell.posterView setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            NSLog(@"got image");
                                            weakMovieCell.posterView.image = image;
                                            [weakMovieCell setNeedsLayout];
                                        } failure:nil];
    
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
