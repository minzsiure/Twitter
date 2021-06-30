//
//  DetailViewController.h
//  twitter
//
//  Created by Eva Xie on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TimelineViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (weak, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
