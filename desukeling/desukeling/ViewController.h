//
//  ViewController.h
//  desukeru
//
//  Created by i.novol on 2013/09/14.
//  Copyright (c) 2013年 PrintShop Ishidoya. All rights reserved.
//

@class DescaleFrame;

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define MAX_FRAME_CNT 26

NSString *_f_name[] = {
    @"desukeru",
    @"F0",
    @"F1",
    @"SM",
    @"F2",
    @"F3",
    @"F4",
    @"F5",
    @"F6",
    @"F8",
    @"F10",
    @"F12",
    @"F15",
    @"F20",
    @"F25",
    @"F30",
    @"F40",
    @"F50",
    @"F60",
    @"F80",
    @"F100",
    @"F120",
    @"F130",
    @"F150",
    @"F200",
    @"F300",
    @"F500"
};

@interface ViewController : UIViewController
<UINavigationBarDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIPrintInteractionControllerDelegate,
UIActionSheetDelegate>
{
    DescaleFrame *deskelFrame;
    CGFloat lastScale;
    
    int deskelFrameNo;
    int deskelColor;
    
    UIImage *bkImage;
    UIImage *grayImage;
    UIActionSheet *aActionSheet;
    int graySw;
    
    CGSize maxViewSize;
    CGFloat currentScale;
    
    CGFloat displayWidth;
    CGFloat displayHeight;
    
    NSURL *imageURL;
    NSData *data;
    UIImage* resizeImage;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnGray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTurn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imgWall;
@property (weak, nonatomic) IBOutlet UILabel *lblDescale;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDeskel;
@property (weak, nonatomic) IBOutlet UIImageView *viewMotif;
@property (weak, nonatomic) IBOutlet DescaleFrame *deskelView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property(nonatomic,retain) UIView *cameraOverlayView;
@property(nonatomic) BOOL showsCameraControls;
@property (retain, readwrite) NSURL *imageURL;
@property (retain, readwrite) UIPopoverController *popover;

- (IBAction)doDeskel:(id)sender;
- (IBAction)doTurn:(id)sender;
- (IBAction)doPinch:(UIPinchGestureRecognizer *)gestureRecognizer;
- (IBAction)doPan:(id)sender;
- (IBAction)doGray:(id)sender;
- (IBAction)doSheet:(id)sender;
- (IBAction)doColorChange:(id)sender;

- (void)btnCamera:(id)sender;
- (void)btnOpen:(id)sender;
- (NSString *)btnSave:(id)sender actionNo:(int)actionNo;
- (void)printItem:(NSString *)path;
- (UIImage *)getBlackAndWhiteVersionOfImage:(UIImage *)anImage;
- (UIImage*)imageByShrinkingWithSize:(UIImage *)img;
- (void) drawFrame;

@end
