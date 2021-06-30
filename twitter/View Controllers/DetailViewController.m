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


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTweet];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
