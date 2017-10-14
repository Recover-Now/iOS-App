//
//  CDImageView.h
//  Recover Now
//
//  Created by Cliff Panos on 10/13/17.
//  Copyright © 2017 Cliff Panos. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CDImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat *cornerRadius;

@end

IB_DESIGNABLE
@interface CDCircularImageView : CDImageView

@end
