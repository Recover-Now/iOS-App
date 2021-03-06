//
//  DonateCollectionViewController.m
//  Recover Now
//
//  Created by Jeremy Schonfeld on 10/15/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "DonateCollectionViewController.h"
#import "DonateTileCollectionViewCell.h"

@interface DonateCollectionViewController ()

@end

@implementation DonateCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    CGFloat inset = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 24.0 : 16.0;
    self.collectionView.contentInset = UIEdgeInsetsMake(inset + 8.0, inset, inset, inset);
    //Handle orientation change
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionViewLayout invalidateLayout];
}

-(void) orientationDidChange {
    [self.collectionViewLayout invalidateLayout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DonateTileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"donateCell" forIndexPath:indexPath];
    
    // Configure the cell
    [cell decorateCellWithID:(int) indexPath.row];
    cell.myContainer = self;
    cell.layer.masksToBounds = false;
    UIView* roundedView = [[cell subviews] firstObject];
    //[cell shadow];
    roundedView.layer.cornerRadius = cell.frame.size.height / 10.0;
    roundedView.layer.masksToBounds = true;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 36.0 : 24.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIEdgeInsets insets = self.collectionView.contentInset;
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat singleCellWidth = width - 15.0 - insets.left - insets.right;
    CGFloat singleCellHeight = singleCellWidth * 0.65;
    return CGSizeMake(singleCellWidth, singleCellHeight);
}


@end
