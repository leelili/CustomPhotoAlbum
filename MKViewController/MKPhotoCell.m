//
//  MKPhotoCell.m
//  MKViewController
//
//  Created by PC-LILY on 15/9/21.
//  Copyright (c) 2015年 PC-LILY. All rights reserved.
//

#import "MKPhotoCell.h"

@implementation MKPhotoCell

-(void)awakeFromNib {
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    
    self.photoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.photoView.layer.borderWidth = 5.0f;
    [super awakeFromNib];
}

@end
