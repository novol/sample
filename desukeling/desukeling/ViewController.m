//
//  ViewController.m
//  desukeru
//
//  Created by i.novol on 2013/09/14.
//  Copyright (c) 2013年 PrintShop Ishidoya. All rights reserved.
//

#import "ViewController.h"
#import "DescaleFrame.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageURL, popover;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( [ UIApplication sharedApplication ].isStatusBarHidden == NO ) {
        [ UIApplication sharedApplication ].statusBarHidden = YES;
    }
    
    CGRect r = [[UIScreen mainScreen] bounds];
    displayWidth = r.size.width;
    displayHeight = r.size.height;
    
    // オリジナルの枠を取得
    CGRect original = self.deskelView.frame;
    CGRect originalBar = self.toolBar.frame;
    
    CGRect new = CGRectMake(original.origin.x,
                            original.origin.y,
                            displayWidth,
                            displayHeight -  self.toolBar.bounds.size.height);

    CGRect bar =  CGRectMake(0,
                             displayHeight - self.toolBar.bounds.size.height,
                             displayWidth,
                             originalBar.size.height);
    
    CGRect wall =  CGRectMake(0,
                              displayHeight - self.toolBar.bounds.size.height,
                              displayWidth,
                              originalBar.size.height);
    
    CGRect lbl =  CGRectMake(5,
                             displayHeight - self.toolBar.bounds.size.height + 5,
                             80,
                             30);
    
    
    // 初期表示は hidden = YES
    self.deskelView.hidden = YES;
    
    // 各オブジェクトの初期位置を設定b
    self.deskelView.frame = new;
    self.viewMotif.frame = new;
    self.toolBar.frame = bar;
    self.imgWall.frame = wall;
    self.lblDescale.frame = lbl;
    
    [self.deskelView setDispSize:r.size.width displayHeight:displayHeight - self.toolBar.bounds.size.height];
    [self.deskelView setParm:deskelFrameNo frameSizeAtIdx:1];
    
    // 初期値セット
    bkImage = nil;
    deskelFrameNo = 0;
    graySw = 0;
    maxViewSize = self.view.bounds.size;
    currentScale = 1.0f;
    lastScale = 1.0f;
    
    self.btnFrame.enabled = NO;
    self.btnGray.enabled = NO;
    self.btnTurn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnCamera:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;

    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:pickerController animated:YES completion:nil];
    });
    
}

- (void)btnOpen:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:imagePicker animated:YES completion:nil];
    });

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    bkImage = image;
    
    CGFloat perHeight = 1.0f;
    CGFloat perWidth = 1.0f;
    
    CGSize motifSize = self.viewMotif.bounds.size;
    
    if ( motifSize.height < image.size.height)
    {
        perHeight = motifSize.height / image.size.height;
    }
    if ( motifSize.width < image.size.width)
    {
        perWidth = motifSize.width / image.size.width;
    }
    
    if ( perHeight != 1.0 || perWidth != 1.0) {
        if ( perHeight > perWidth )
        {
            CGRect rect = CGRectMake(0,
                                     0,
                                     image.size.width  * perHeight,
                                     image.size.height * perHeight);
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); // 変更
            [image drawInRect:rect];
            grayImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        } else {
            CGRect rect = CGRectMake(0,
                                     0,
                                     image.size.width  * perWidth,
                                     image.size.height * perWidth);
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); // 変更
            [image drawInRect:rect];
            grayImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    } else {
        grayImage = image;
    }
    grayImage = [self getBlackAndWhiteVersionOfImage:grayImage];
    //grayImage = [self getBlackAndWhiteVersionOfImage:image];
    
    //初期状態に戻したい場合は無変換のアフィン変換にする
    self.viewMotif.transform = CGAffineTransformIdentity;
    
    CGRect imageRect = self.viewMotif.frame;
    imageRect.origin.x = 0;
    imageRect.origin.y = 0;
    self.viewMotif.frame = imageRect;
    self.viewMotif.image = image;
    
    [self.viewMotif setNeedsDisplay];
    [self dismissModalViewControllerAnimated:YES];
    
    // 変数の初期化
    graySw = 0;
    
    self.btnGray.enabled = YES;
    self.btnTurn.enabled = YES;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doDeskel:(id)sender {
    
    deskelFrameNo = (deskelFrameNo += 1) % (MAX_FRAME_CNT + 1);
    
    
    switch (deskelFrameNo) {
        case 0:
            self.btnDeskel.title = @"desukeru";
            break;
            
        default:
            self.btnDeskel.title = _f_name[deskelFrameNo];
            break;
    }
    [self drawFrame];
    
//    self.lblDescale.text =  _f_name[deskelFrameNo];
    if (0 == deskelFrameNo) {
        self.btnFrame.enabled = NO;
    } else {
        self.btnFrame.enabled = YES;
    }
}

- (IBAction)doTurn:(id)sender {
    
    self.viewMotif.transform = CGAffineTransformRotate(self.viewMotif.transform, M_PI/2);
    
}

- (NSString *)btnSave:(id)sender actionNo:(int)actionNo {
    
    self.toolBar.hidden = YES;
    
    NSString *path = nil;
    
    self.lblDescale.text =  _f_name[deskelFrameNo];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize size = self.view.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, screenRect);
    
    // 保存するビューを指定
    [self.view.layer renderInContext:ctx];
    
    // 指定したビューをPNGで取得
    NSData *pngData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
    UIImage *screenImage = [UIImage imageWithData:pngData];
    UIGraphicsEndImageContext();
    
    self.toolBar.hidden = NO;
    
    switch (actionNo) {
            // Save
        case 1:
        {
            // 取得したPNG画像をカメラロールに保存する
            UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
            // Alertを表示する
            /*
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
             message:@"保存しました"
             delegate:nil
             cancelButtonTitle:nil
             otherButtonTitles:@"OK", nil];
             [alert show];
             */
            break;
        }
            // Print用一時退避
        case 2:
            path = [self tempolarySave:screenImage];
            break;
            
        default:
            break;
    }
    
    self.lblDescale.text =  @"";

    return path;
    
}

- (IBAction)doPinch:(UIPinchGestureRecognizer *)gestureRecognizer  {
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale = [gestureRecognizer scale];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 0.8;
        
        CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
        [gestureRecognizer view].transform = transform;
        
        lastScale = [gestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
    
}

- (IBAction)doPan:(id)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint center = self.viewMotif.center;
    CGRect frameView = self.view.frame;
    
    //centerがviewの内側であること
    if (translation.x + center.x < 0) {
        [sender setTranslation:CGPointZero inView:self.view];
        return;
    }
    if (translation.y + center.y < 0) {
        [sender setTranslation:CGPointZero inView:self.view];
        return;
    }
    if (translation.x + center.x > frameView.size.width) {
        [sender setTranslation:CGPointZero inView:self.view];
        return;
    }
    if (translation.y + center.y > frameView.size.height) {
        [sender setTranslation:CGPointZero inView:self.view];
        return;
    }
    
    printf("t x:%f,y;%f",translation.x,translation.y);
    
    center.x = center.x + translation.x;
    center.y = center.y + translation.y;
    
    self.viewMotif.center = center;
    [sender setTranslation:CGPointZero inView:self.view];
}

- (IBAction)doGray:(id)sender {
    
    switch (graySw) {
        case 0:
            self.viewMotif.image = grayImage;
            break;
        case 1:
            self.viewMotif.contentMode = UIViewContentModeScaleAspectFit;
            if (bkImage != nil) {
                self.viewMotif.image = bkImage;
            }
            break;
        default:
            break;
    }
    graySw = (graySw+=1) % 2;
    
}

- (NSString *) tempolarySave:(UIImage *) aImage {
    
    CGRect rect = CGRectMake(0, 0,
                             aImage.size.width,
                             aImage.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); // 変更
    [aImage drawInRect:rect];
    resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // PNGで保存
    data = UIImagePNGRepresentation(resizeImage);
    
    NSString *path = [NSString stringWithFormat:@"%@/sample.PNG",
                      [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    
    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"save OK");
    } else {
        path = nil;
        NSLog(@"save NG");
    }
    return path;
}


-(void)printItem:(NSString *)path {
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if ([UIPrintInteractionController canPrintData:data]) {
        pic.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = resizeImage;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
        {
            //            self.content = nil;
            if (!completed && error)
            {
                NSLog(@"FAILED! due to error in domain %@ with error code %ld",error.domain, (long)error.code);
            }
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //            [pic presentFromBarButtonItem:self.printButton animated:YES
            //                             completionHandler:completionHandler];
        } else {
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (IBAction)doSheet:(id)sender {
    
    if (aActionSheet) {
        return;
    }
    
    aActionSheet = [[UIActionSheet alloc]
                    initWithTitle:@""
                    delegate:self
                    cancelButtonTitle:@"cancel"
                    destructiveButtonTitle:nil
                    otherButtonTitles:@"Camera", @"Open", @"Save", @"Print",nil];
    [aActionSheet showInView:self.view];
}

- (IBAction)doColorChange:(id)sender {
    
    deskelColor = (deskelColor += 1) % 2;
    if (deskelFrameNo != 0) {
        [self drawFrame];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	switch (buttonIndex) {
		case 0: // Camera
			[self btnCamera:self];
			break;
		case 1: // Open
			[self btnOpen:self];
			break;
		case 2: // Save
			[self btnSave:self actionNo:1];
			break;
		case 3: // Print
			[self printItem:[self btnSave:self actionNo:2]];
			break;
		default:
			break;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    aActionSheet = nil;
}

- (UIImage *)getBlackAndWhiteVersionOfImage:(UIImage *)anImage {
    
	UIImage *newImage;
	
	if (anImage) {
        CGSize size = anImage.size;
        CGRect rect = CGRectMake(0.0f,0.0f, size.width, size.height);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGImageRef cgImage = anImage.CGImage;
        unsigned long bytesPerRow = CGImageGetBytesPerRow(cgImage);
        unsigned long bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
        CGContextRef context = CGBitmapContextCreate(nil,
                                                     size.width,
                                                     size.height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     (CGBitmapInfo)kCGImageAlphaNone);

        CGColorSpaceRelease(colorSpace);
        CGContextDrawImage(context, rect, [anImage CGImage]);
        CGImageRef grayscale = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        newImage = [UIImage imageWithCGImage:grayscale];
        CFRelease(grayscale);
        
    }
	return newImage;
}



- (UIImage*)imageByShrinkingWithSize:(UIImage *)img
{
    CGFloat widthRatio  = img.size.width  / self.viewMotif.bounds.size.width;
    CGFloat heightRatio = img.size.height / self.viewMotif.bounds.size.height;
    
    CGFloat ratio = (widthRatio < heightRatio) ? heightRatio : widthRatio;
    
    if (ratio <= 1.0) {
        return img;
    }
    
    CGRect rect = CGRectMake(0, 0,
                             img.size.width  * (1-ratio),
                             img.size.height * (1-ratio));
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); // 変更
    [img drawInRect:rect];
    UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return shrinkedImage;
}

- (void) drawFrame
{
    switch (deskelFrameNo) {
        case 0:
            self.deskelView.hidden = YES;
            break;
            
        default:
            [self.deskelView setParm:deskelColor frameSizeAtIdx:deskelFrameNo];
            [self.deskelView setNeedsDisplay];
            
            self.deskelView.hidden = NO;
            break;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
