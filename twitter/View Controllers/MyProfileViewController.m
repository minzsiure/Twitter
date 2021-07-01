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

@interface MyProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetNumber;
@property (weak, nonatomic) IBOutlet UILabel *followingNumber;
@property (weak, nonatomic) IBOutlet UILabel *followerNumber;


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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
