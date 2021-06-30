//
//  TweetCell.m
//  twitter
//
//  Created by Eva Xie on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) refreshData{

    User *user =self.tweet.user;
    self.fullName.text = user.name;
    self.userName.text = user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    NSString* replyString = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    NSString* retweetString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    NSString* likeString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.replyLabel.text = replyString;
    self.retweetLabel.text = retweetString;
    self.likeLabel.text = likeString;
    
    //profile img
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:urlData];
    [self.profileImage setImage:image];

}

- (IBAction)didTapLike:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!self.tweet.favorited){
        // TODO: Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;

        // TODO: Update cell UI
        [btn setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
        
        
    
        // TODO: Send a POST request to the POST favorites/create endpoint
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
    
    // TODO: Send a POST request to the POST favorites/create endpoint
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

- (IBAction)didTapRetweet:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!self.tweet.retweeted){
        // TODO: Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;

        // TODO: Update cell UI
        [btn setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
        
        
    
        // TODO: Send a POST request to the POST favorites/create endpoint
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
    
    // TODO: Send a POST request to the POST favorites/create endpoint
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



@end
