//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Suraj Sirpilli on 9/17/14.
//  Copyright (c) 2014 jarusElyk. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "M13ProgressViewSegmentedBar.h"
#import "MBProgressHUD.h"


@interface MoviesViewController ()
{
    UIRefreshControl *refresh;
    MBProgressHUD *HUD;

}
@property (weak, nonatomic) IBOutlet UILabel *errorMsg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property () NSInteger numberOfTouches;
@property(strong, nonatomic) DetailViewController *details;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Rotten Tomatoes" ;
    
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 125;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tableView addGestureRecognizer:tap];
    
    refresh = [[UIRefreshControl alloc] init];
    
    [self.tableView addSubview:refresh];
    
    [refresh addTarget:self action:@selector(loadPage) forControlEvents:UIControlEventValueChanged];
    
    
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    
    [NSURLConnection sendAsynchronousRequest: request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         // Hide the loading View
         
       if(!connectionError)
         {
             self.errorMsg.hidden = true;
             [HUD hide:YES];
             NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             self.movies = object[@"movies"];
             
             [self.tableView reloadData];
             
             //NSLog(@"movies: %@", self.movies);
         }
         else {
             
             self.errorMsg.hidden = false;
             self.tableView.hidden = true;
             self.errorMsg.text = @"Network Error";
         }
     }];

    
    // Added a loading view
    
 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    
    //NSLog(@"index path %ld", (long) indexPath.row);
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    return cell;
}


-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Here");
}

-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    NSLog(@"%ld",(long)indexPath.row);
    
    NSDictionary *m = self.movies[indexPath.row];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[m valueForKeyPath:@"posters.original"] forKey:@"img"];
    [userDefaults setObject:m[@"synopsis"] forKey:@"det"];
    [userDefaults synchronize];
    self.details = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self presentViewController:self.details animated:YES completion:nil];
    
    
   }

- (void)stopRefresh
{
    
  //  [self.refreshControl endRefreshing];
    
}


-(void)loadPage
{
    
    [refresh endRefreshing];
    [self.tableView reloadData];
    
}



@end
