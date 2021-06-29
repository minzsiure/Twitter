//
//  ComposeViewController.m
//  twitter
//
//  Created by Eva Xie on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"



@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *composeProfile;

@end

@implementation ComposeViewController

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetAction:(id)sender {
    NSString *text = self.tweetTextView.text;
    [[APIManager shared] postStatusWithText:text completion:^(Tweet * tweet, NSError * error){
        if (tweet){
            
            NSLog(@"Tweet success");
            // make viewController dismiss
            [self.delegate didTweet:tweet];
            
        }
        
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
