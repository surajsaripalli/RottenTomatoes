//
//  MovieCell.h
//  RottenTomatoes
//
//  Created by Suraj Sirpilli on 9/17/14.
//  Copyright (c) 2014 jarusElyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
