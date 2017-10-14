//
//  ResourceCollectionViewCell.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "ResourceCollectionViewCell.h"
#import <Foundation/Foundation.h>

@implementation ResourceCollectionViewCell

- (void) decorateForResource: (RNResource*) resource {
    NSLog(@"Decorating resource with %@", resource.title);
    self.typeLabel.text = resource.categoryDescription;
    self.imageView.image = [UIImage imageNamed:@"Water"];
    
}

@end
