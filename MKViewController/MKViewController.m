//
//  MKViewController.m
//  MKViewController
//
//  Created by PC-LILY on 15/9/21.
//  Copyright (c) 2015年 PC-LILY. All rights reserved.
//

#import "MKViewController.h"
#import "MKPhotoCell.h"
#import "MKDetailViewController.h"

enum PhotoOrientation {
    
    PhotoOrientationLandscape,
    PhotoOrientationPortrait
};

@interface MKViewController ()

@property (strong,nonatomic) NSArray *photosList;
@property (strong,nonatomic) NSMutableArray *photoOrientation;
@property (strong,nonatomic) NSMutableDictionary *photosCache;

@end

@implementation MKViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    NSArray *photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self photosDirectory] error:nil];
    self.photosCache = [NSMutableDictionary dictionary];
    self.photoOrientation = [NSMutableArray array];
    self.photosList = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [photosArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *path = [[self photosDirectory] stringByAppendingPathComponent:obj];
            CGSize size = [UIImage imageWithContentsOfFile:path].size;
            if (size.width > size.height) {
                [self.photoOrientation addObject:[NSNumber numberWithInt:PhotoOrientationLandscape]];
            } else {
                [self.photoOrientation addObject:[NSNumber numberWithInt:PhotoOrientationPortrait]];
            }
        }];
        
        dispatch_async(dispatch_get_current_queue(), ^{
            self.photosList = photosArray;
            [self.collectionView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.photosCache = [NSMutableDictionary dictionary];
}

-(NSString *)photosDirectory {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *selectedIndexPath = sender;
    NSString *photoName = [self.photosList objectAtIndex:selectedIndexPath.row];
    
    MKDetailViewController *controller = segue.destinationViewController;
    controller.photoPath = [[self photosDirectory] stringByAppendingPathComponent:photoName];
    
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.photosList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierLanscape = @"MKPhotoCellLandscape";
    static NSString *CellIdentifierPortrait = @"MKPhotoCellPortrait";
    
    int orientation = [[self.photoOrientation objectAtIndex:indexPath.row] intValue];
    
    MKPhotoCell *cell = (MKPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:orientation == PhotoOrientationLandscape ? CellIdentifierLanscape : CellIdentifierPortrait
                                                                                 forIndexPath:indexPath];
    
    // Configure the cell
    NSString *photoName = [self.photosList objectAtIndex:indexPath.row];
    NSString *photoFilePath = [[self photosDirectory] stringByAppendingPathComponent:photoName];
    cell.photoName.text = [photoName stringByDeletingPathExtension];
    
    __block UIImage *thumbImage = [self.photosCache objectForKey:photoName];
    cell.photoView.image = thumbImage;
    
    if (!thumbImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
            if (orientation == PhotoOrientationLandscape) {
                 UIGraphicsBeginImageContext(CGSizeMake(180.0f, 120.0f));
                [image drawInRect:CGRectMake(0, 0, 180.0f, 120.0f)];
                thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            } else {
                UIGraphicsBeginImageContext(CGSizeMake(120.f, 180.f));
                [image drawInRect:CGRectMake(0, 0, 120.0f, 180.0f)];
                thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photosCache setObject:thumbImage forKey:photoName];
                cell.photoView.image = thumbImage;
            });
        });
    }
   
    
    cell.photoView.image = thumbImage;
    UIGraphicsEndImageContext();
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MainSegue" sender:indexPath];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    static NSString *SupplementaryViewIdentifier = @"SupplementaryViewIdentifier";
    return  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SupplementaryViewIdentifier forIndexPath:indexPath];
}


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


@end
