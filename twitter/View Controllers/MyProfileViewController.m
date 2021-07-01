//
//  MyProfileViewController.m
//  twitter
//
//  Created by Eva Xie on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "MyProfileViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "MyCell.h"
#import "Tweet.h"

@interface MyProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetNumber;
@property (weak, nonatomic) IBOutlet UILabel *followingNumber;
@property (weak, nonatomic) IBOutlet UILabel *followerNumber;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSDictionary *info;


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void) loadData{
    // Get timeline
    [[APIManager shared] verifyCredentials: ^(NSDictionary *info, NSError *error) {
        if (info) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.info = info;
            
            NSString *URLString = info[@"profile_image_url_https"];
            NSURL *url = [NSURL URLWithString:URLString];
            
            NSString *BannerString = info[@"profile_banner_url"];
            NSURL *Bannerurl = [NSURL URLWithString:BannerString];

            self.profileImage.image = nil;
            [self.profileImage setImageWithURL:url];
            self.profileImage.layer.cornerRadius = 50;
            self.profileImage.clipsToBounds = YES;
            
            self.backdropImage.image = nil;
            [self.backdropImage setImageWithURL:Bannerurl];
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

            UIVisualEffectView *visualEffectView;
            visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];

            visualEffectView.frame = self.backdropImage.bounds;
            [self.backdropImage addSubview:visualEffectView];
            
            self.fullName.text = info[@"name"];
            self.userName.text = [@"@" stringByAppendingString:info[@"screen_name"]];
            
            self.tweetNumber.text = [NSString stringWithFormat:@"%@", info[@"statuses_count"]];
            self.followingNumber.text = [NSString stringWithFormat:@"%@", info[@"friends_count"]];
            self.followerNumber.text = [NSString stringWithFormat:@"%@", info[@"followers_count"]];
            

  

            

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
        Tweet *tweetObj = self.info[@"status"][indexPath.row];
        
        cell.nameLabel.text = tweetObj.user.name;
        NSString *userName = tweetObj.user.screenName;
        NSString *userString = [@"@" stringByAppendingString:userName];
        cell.userName.text = userString;
        
        cell.dateLabel.text = tweetObj.createdAtString;
        cell.tweetLabel.text = tweetObj.text;
        cell.tweet = tweetObj;
        
        NSString* replyString = [NSString stringWithFormat:@"%d", tweetObj.replyCount];
        NSString* retweetString = [NSString stringWithFormat:@"%d", tweetObj.retweetCount];
        NSString* likeString = [NSString stringWithFormat:@"%d", tweetObj.favoriteCount];

        
        cell.replyCount.text = replyString;
        cell.retweetCount.text = retweetString;
        cell.likeCount.text = likeString;
        
        NSString *URLString = tweetObj.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        cell.profileLabel.image = nil;
        [cell.profileLabel setImageWithURL:url];
        cell.profileLabel.layer.cornerRadius = 30;
        cell.profileLabel.clipsToBounds = YES;
       
        return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 20;
}

@end
