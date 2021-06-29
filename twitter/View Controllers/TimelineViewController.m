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

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *logOut;
@property (strong, nonatomic) NSMutableArray *arrayofTweets;
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *tweet in tweets) {
//                            [self.arrayofTweets addObject:tweet];
//                            NSLog(@"%@", tweet.text);
//                        }
            self.arrayofTweets = tweets;
            [self.tweetTableView reloadData];
            
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //call reuseable cells
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweetObj = self.arrayofTweets[indexPath.row];
    // make right movie associates with right row
    //NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    cell.fullName.text = tweetObj.user.name;
    cell.userName.text = tweetObj.user.screenName;
    cell.dateLabel.text = tweetObj.createdAtString;
    cell.tweetLabel.text = tweetObj.text;
    
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
    
//    profileImage;




//    reweetLabel;
//    likeLabel;
//    messageLabel;
    

    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayofTweets.count;
}



@end
