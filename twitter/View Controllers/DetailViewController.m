//
//  DetailViewController.m
//  twitter
//
//  Created by Eva Xie on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "Tweet.h"
#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTweet];
    [self refreshData];
    [self refreshLikeButton];
    [self refreshRetweetButton];
    
}

- (void) refreshLikeButton{
    if (self.tweet.favorited){

        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
}

- (void) refreshRetweetButton{
    if (self.tweet.retweeted){

        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
}

- (void) refreshData{
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];

    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:url];
    self.profileImage.layer.cornerRadius = 30;
    self.profileImage.clipsToBounds = YES;
    
    self.fullName.text = self.tweet.user.name;
    NSString *userName = self.tweet.user.screenName;
    NSString *userString = [@"@" stringByAppendingString:userName];
    self.userName.text = userString;
    self.tweetLabel.text = self.tweet.text;
    self.timeLabel.text = self.tweet.fullDate;
    
    NSString* retweetString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    NSString* likeString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.retweetLabel.text = retweetString;
    self.likeLabel.text = likeString;
}


- (void) loadTweet{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)retweetAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!self.tweet.retweeted){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;

        [btn setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
        [self refreshData];
    }
    else{
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [btn setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
        
    }
    
    // Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
         NSLog(@"Error unfretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshData];
}

- (IBAction)likeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!self.tweet.favorited){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;

        [btn setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
        

        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        [self refreshData];
    }
    else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [btn setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
        
    }
    
    [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
         NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
