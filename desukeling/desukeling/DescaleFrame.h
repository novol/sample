//
//  DescaleFrame.h
//  desukeru
//
//  Created by i.novol on 2013/09/14.
//  Copyright (c) 2013年 PrintShop Ishidoya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescaleFrame : UIView
{
    CGFloat dispWidth;
    CGFloat dispHeight;
    CGFloat statusBarHeight;
    
    int coloreNo;
    int frameSize;
}

-(void) setParm:(int) aColorNo frameSizeAtIdx:(int)aframeSize;
-(void) setDispSize:(CGFloat) aDispWidth displayHeight:(CGFloat) aDispHeight;

@end
