//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *logOut;
@property (strong, nonatomic) NSMutableArray *arrayofTweets;
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    
    [self loadTweet];
    
    //init a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    //addTarget, the object u wanna call; action, functions u wanna call
    [self.refreshControl addTarget:self action:@selector(loadTweet) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.refreshControl atIndex:0];
    [self.tweetTableView addSubview:self.refreshControl]; //addSubview is a part of UIView, can be added anywhere
    


}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
}

- (void) loadTweet{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            self.arrayofTweets = tweets; //ignore warning
            [self.tweetTableView reloadData];
            
            [self.refreshControl endRefreshing];


        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOutAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"composeTweet"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else{
        // tweet detial page
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:tappedCell];
        Tweet *tweetObj = self.arrayofTweets[indexPath.row];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.tweet = tweetObj;
    }
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //call reuseable cells
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweetObj = self.arrayofTweets[indexPath.row];
    
    cell.fullName.text = tweetObj.user.name;
    NSString *userName = tweetObj.user.screenName;
    NSString *userString = [@"@" stringByAppendingString:userName];
    cell.userName.text = userString;
    
    cell.dateLabel.text = tweetObj.createdAtString;
    cell.tweetLabel.text = tweetObj.text;
    cell.tweet = tweetObj;
    
    NSString* replyString = [NSString stringWithFormat:@"%d", tweetObj.replyCount];
    NSString* retweetString = [NSString stringWithFormat:@"%d", tweetObj.retweetCount];
    NSString* likeString = [NSString stringWithFormat:@"%d", tweetObj.favoriteCount];

    
    cell.replyLabel.text = replyString;
    cell.retweetLabel.text = retweetString;
    cell.likeLabel.text = likeString;
    
    NSString *URLString = tweetObj.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profileImage.image = nil;
    [cell.profileImage setImageWithURL:url];
    cell.profileImage.layer.cornerRadius = 30;
    cell.profileImage.clipsToBounds = YES;
    
    cell.delegate = self;
   
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayofTweets.count;
}

- (void) didTweet:(Tweet *)tweet{
    //add the new tweet to the tweets array and call
    [self.arrayofTweets insertObject:tweet atIndex:0];
    [self.tweetTableView  reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
