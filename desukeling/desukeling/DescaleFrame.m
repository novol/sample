//
//  DescaleFrame.m
//  desukeru
//
//  Created by i.novol on 2013/09/14.
//  Copyright (c) 2013年 PrintShop Ishidoya. All rights reserved.
//

#import "DescaleFrame.h"

@implementation DescaleFrame


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0];
    }
    return self;
}

-(void) setDispSize:(CGFloat) aDispWidth displayHeight:(CGFloat) aDispHeight
{
    dispWidth = aDispWidth;
    dispHeight = aDispHeight;
}

-(void) setParm:(int) aColorNo frameSizeAtIdx:(int)aframeSize
{
    coloreNo = aColorNo;
    frameSize = aframeSize;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGPoint c = self.center;
    // 線の色
    switch (coloreNo) {
        case 0:
            [[UIColor blackColor] setStroke];
            break;
            
        case 1:
            [[UIColor whiteColor] setStroke];
            break;
            
        default:
            break;
    }
    
    // フレームの色
    switch (coloreNo) {
        case 0:
            [[UIColor blackColor] setFill];
            break;
        case 1:
            [[UIColor whiteColor] setFill];
            break;
        default:
            break;
    }
    
    CGFloat w;
    CGFloat h;
    
    float f_Width_iPhone[] = {
        0.0,      //init
        310.0,    //F0号_WIDTH
        298.2,    //F1号_WIDTH
        285.4,    //FSM_WIDTH
        310.0,    //F2号_WIDTH
        310.0,    //F3号_WIDTH
        298.0,    //F4号_WIDTH
        310.0,    //F5号_WIDTH
        310.0,    //F6号_WIDTH
        310.0,    //F8号_WIDTH
        310.0,    //F10号_WIDTH
        310.0,    //F12号_WIDTH
        310.0,    //F15号_WIDTH
        310.0,    //F20号_WIDTH
        310.0,    //F25号_WIDTH
        310.0,    //F30号_WIDTH
        310.0,    //F40号_WIDTH
        310.0,    //F50号_WIDTH
        305.2,    //F60号_WIDTH
        310.0,    //F80号_WIDTH
        310.0,    //F100号_WIDTH
        275.4,    //F120号_WIDTH
        310.0,    //F130号_WIDTH
        310.0,    //F150号_WIDTH
        307.1,    //F200号_WIDTH
        307.4,    //F300号_WIDTH
        305.7     //F500号_WIDTH
    };
    
    float f_Height_iPhone[] = {
        0.0,      //init
        398.6,    //F0号_HEIGHT
        410.0,    //F1号_HEIGHT
        410.0,    //FSM_HEIGHT
        391.6,    //F2号_HEIGHT
        384.7,    //F3号_HEIGHT
        410.0,    //F4号_HEIGHT
        401.9,    //F5号_HEIGHT
        399.7,    //F6号_HEIGHT
        371.2,    //F8号_HEIGHT
        361.1,    //F10号_HEIGHT
        375.7,    //F12号_HEIGHT
        381.4,    //F15号_HEIGHT
        371.9,    //F20号_HEIGHT
        381.8,    //F25号_HEIGHT
        388.0,    //F30号_HEIGHT
        386.1,    //F40号_HEIGHT
        397.5,    //F50号_HEIGHT
        410.0,    //F60号_HEIGHT
        402.7,    //F80号_HEIGHT
        385.4,    //F100号_HEIGHT
        410.0,    //F120号_HEIGHT
        371.2,    //F130号_HEIGHT
        387.6,    //F150号_HEIGHT
        410.0,    //F200号_HEIGHT
        410.0,    //F300号_HEIGHT
        410.0     //F500号_HEIGHT
    };

    float f_Width_iPad[] = {
          0.0,    //init
        700.0,    //F0号_WIDTH
        654.5,    //F1号_WIDTH
        626.4,    //FSM_WIDTH
        700.0,    //F2号_WIDTH
        700.0,    //F3号_WIDTH
        654.1,    //F4号_WIDTH
        694.3,    //F5号_WIDTH
        698.0,    //F6号_WIDTH
        700.0,    //F8号_WIDTH
        700.0,    //F10号_WIDTH
        700.0,    //F12号_WIDTH
        700.0,    //F15号_WIDTH
        700.0,    //F20号_WIDTH
        700.0,    //F25号_WIDTH
        700.0,    //F30号_WIDTH
        700.0,    //F40号_WIDTH
        700.0,    //F50号_WIDTH
        670.0,    //F60号_WIDTH
        692.8,    //F80号_WIDTH
        700.0,    //F100号_WIDTH
        604.5,    //F120号_WIDTH
        700.0,    //F130号_WIDTH
        700.0,    //F150号_WIDTH
        674.1,    //F200号_WIDTH
        674.8,    //F300号_WIDTH
        671.0     //F500号_WIDTH
    };
    
    float f_Height_iPad[] = {
          0.0,    //init
        900.0,    //F0号_HEIGHT
        900.0,    //F1号_HEIGHT
        900.0,    //FSM_HEIGHT
        884.2,    //F2号_HEIGHT
        868.6,    //F3号_HEIGHT
        900.0,    //F4号_HEIGHT
        900.0,    //F5号_HEIGHT
        900.0,    //F6号_HEIGHT
        838.2,    //F8号_HEIGHT
        815.4,    //F10号_HEIGHT
        848.4,    //F12号_HEIGHT
        861.1,    //F15号_HEIGHT
        839.8,    //F20号_HEIGHT
        862.1,    //F25号_HEIGHT
        876.2,    //F30号_HEIGHT
        871.7,    //F40号_HEIGHT
        897.7,    //F50号_HEIGHT
        900.0,    //F60号_HEIGHT
        900.0,    //F80号_HEIGHT
        870.3,    //F100号_HEIGHT
        900.0,    //F120号_HEIGHT
        838.3,    //F130号_HEIGHT
        875.2,    //F150号_HEIGHT
        900.0,    //F200号_HEIGHT
        900.0,    //F300号_HEIGHT
        900.0     //F500号_HEIGHT
    };
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        w = f_Width_iPhone[frameSize];
        h = f_Height_iPhone[frameSize];
    } else {
        w = f_Width_iPad[frameSize];
        h = f_Height_iPad[frameSize];
    }
 
    
    
    
    UIBezierPath *Path = [UIBezierPath bezierPath];
    
    // 中心線・横
    [Path setLineWidth:0.4];
    
    [Path moveToPoint:CGPointMake(0, c.y)];
    [Path addLineToPoint:CGPointMake(dispWidth, c.y)];
    
    // 中心線・縦
    [Path setLineWidth:0.4];
    [Path moveToPoint:CGPointMake(c.x, 0)];
    [Path addLineToPoint:CGPointMake(c.x, dispHeight)];
    
    // 4分割・横
    [Path setLineWidth:0.4];
    [Path moveToPoint:CGPointMake(0, c.y + ceilf(h/4))];
    [Path addLineToPoint:CGPointMake(dispWidth, c.y + ceil(h/4))];
    
    // 4分割・横
    [Path setLineWidth:0.4];
    [Path moveToPoint:CGPointMake(0, c.y - ceil(h/4))];
    [Path addLineToPoint:CGPointMake(dispWidth, c.y - ceil(h/4))];
    
    // 4分割・縦
    [Path setLineWidth:0.4];
    [Path moveToPoint:CGPointMake(c.x + ceil(w/4), 0)];
    [Path addLineToPoint:CGPointMake(c.x + ceil(w/4), dispHeight)];
    
    // 4分割・縦
    [Path setLineWidth:0.4];
    [Path moveToPoint:CGPointMake(c.x - ceil(w/4), 0)];
    [Path addLineToPoint:CGPointMake(c.x - ceil(w/4), dispHeight)];
    
    [Path stroke];
    
    // フレームの色
    UIBezierPath *rectAngl1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, dispWidth, c.y - h/2)];
    [rectAngl1 setLineWidth:0];
    [rectAngl1 fill];
    [rectAngl1 stroke];
    
    UIBezierPath *rectAngl2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, c.y + h/2, dispWidth, dispHeight)];
    [rectAngl2 setLineWidth:0];
    [rectAngl2 fill];
    [rectAngl2 stroke];
    
    UIBezierPath *rectAngl3 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, c.x - w/2, dispHeight)];
    [rectAngl3 setLineWidth:0];
    [rectAngl3 fill];
    [rectAngl3 stroke];
    
    UIBezierPath *rectAngl4 = [UIBezierPath bezierPathWithRect:CGRectMake(c.x + w/2, 0, dispWidth, dispHeight)];
    [rectAngl4 setLineWidth:0];
    [rectAngl4 fill];
    [rectAngl4 stroke];
    
}

@end
