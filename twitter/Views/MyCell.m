//
//  MyCell.m
//  twitter
//
//  Created by Eva Xie on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "MyCell.h"
#import "APIManager.h"
#import "DateTools.h"
#import "Tweet.h"
#import "User.h"

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) refreshData{

    User *user =self.tweet.user;
    self.nameLabel.text = user.name;
    self.userName.text = user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    NSString* replyString = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    NSString* retweetString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    NSString* likeString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.replyCount.text = replyString;
    self.retweetCount.text = retweetString;
    self.likeCount.text = likeString;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:urlData];
    [self.profileLabel setImage:image];
    [self.profileLabel setUserInteractionEnabled:YES];

    

}



@end
