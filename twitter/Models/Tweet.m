//
//  Tweet.m
//  twitter
//
//  Created by Eva Xie on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import <DateTools.h>

@implementation Tweet


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"full_text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.replyCount = [dictionary[@"reply_count"] intValue];
        
        // TODO: initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];

        // TODO: Format and set createdAtString
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        self.fullDate = [formatter stringFromDate:date];
        
        // Convert Date to String
        self.createdAtString = date.shortTimeAgoSinceNow;
        
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    // created an array
    NSMutableArray *tweets = [NSMutableArray array];
        
    // a factory method that returns Tweets when initialized with an array of Tweet Dictionaries.
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
