//
//  NSObject+UIImageCategory.m
//  Recover Now
//
//  Created by Cliff Panos on 10/14/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import "UIImage+UIImageCategory.h"

@implementation UIImage (UIImageCategory)

-(UIImage *) drawAspectFillIn: (CGRect) rect {
    CGSize targetSize = rect.size;
    CGFloat widthRatio = targetSize.width / self.size.width;
    CGFloat heightRatio = targetSize.height / self.size.height;
    CGFloat scalingFactor = MAX(widthRatio, heightRatio);
    CGSize newSize = CGSizeMake(self.size.width * scalingFactor, self.size.height * scalingFactor);
    
    UIGraphicsBeginImageContext(targetSize);
    CGPoint origin = CGPointMake((targetSize.width - newSize.width) / 2.0, (targetSize.height - newSize.height) / 2.0);
    [self drawInRect:CGRectMake(origin.x, origin.y, newSize.width, newSize.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (scaledImage) {
        [scaledImage drawInRect:rect];
    }
    return scaledImage;
}

@end
