//
//  MKDetailViewController.m
//  MKViewController
//
//  Created by PC-LILY on 15/9/21.
//  Copyright (c) 2015年 PC-LILY. All rights reserved.
//

#import "MKDetailViewController.h"

@interface MKDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *photoName;

@end

@implementation MKDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoName.text = [[self.photoPath lastPathComponent] stringByDeletingPathExtension];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:self.photoPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoView.image = image;
        });

    });
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
    
}

- (IBAction)doClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
