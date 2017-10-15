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
    [cell decorateCellWithID:(int)indexPath.row];
    cell.myContainer = self;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
