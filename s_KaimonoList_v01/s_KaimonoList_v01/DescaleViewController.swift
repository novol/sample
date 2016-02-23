//
//  DescaleViewController.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/12.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit
import AVFoundation
import Accounts

class DescaleViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate
{
    /*---
    ■ 残課題
     1.画面サイズのマルチ化
     2.universe対応
     3.tableViewの表示位置
     4.tableViewのcloseタイミング
     5.読み込んだ画像の画面フィット
     6.pinchのMax/Min
     7.panのMax/Min
     8.木炭紙サイズ追加
     9.universe対応
    10.save画像のフッター設定（descaleSizeのみ表示させる？->画像の合成が必要）
    11.印刷テスト
    12.メール送信テスト
    ---*/
    

    // MARK: - 変数
    // private variables
    private var watchImageMode = true
    private var beforePoint = CGPointMake(0.0, 0.0)
    private var currentScale:CGFloat = 1.0
    private var lastScale:CGFloat = 1.0

    var num:[String] = []
    var jsonArray:NSArray = []
    var myApp = UIApplication.sharedApplication().delegate as! AppDelegate

    // 最背面でguestureを制御するView
    var baseView:UIView!
    
    // Descaleの表示View (罫線を描画)
    var descaleView:DesView!
    
    // ImageView.
    var myImageView: UIImageView!
    
    // オリジナル画像・モノクロ画像の退避変数.
    var grayImage:UIImage?
    var orgImage:UIImage?
    
    // Tableで使用する配列を設定する
    var myTableView: UITableView!
    
    
    var descaleHight:Double = 0.0
    var descaleWidth:Double = 0.0
    var descaleColor:Bool = true
    var angle:CGFloat = 0.0
    var monoFlg:Bool = true
    var currentTransForm:CGAffineTransform!
    
    
//-- test用
//    // Imageの表示View
//    var imgView:DescaleImageView!
    
//    let myInputImage = CIImage(image: UIImage(named: "sample.jpg")!)

    // MARK: - @IBOutlet
    @IBOutlet weak var toolbarDescale: UIToolbar!
    @IBOutlet weak var descaleSelectBtn: UIBarButtonItem!
    @IBOutlet weak var descleColoeBtn: UIBarButtonItem!
    
    // MARK: - @IBAction
    @IBAction func doMonochrome(sender: UIBarButtonItem) {
        
//        let roateTrans = CGAffineTransformMakeRotation(angle)
//        let currentTransForm = self.myImageView.transform;
        
        if monoFlg == true {
            monoFlg = false
            self.myImageView.image = grayImage;
        } else {
            monoFlg = true
            self.myImageView.image = orgImage;
        }

//        // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
//        self.myImageView.transform = CGAffineTransformConcat(currentTransForm, roateTrans);
        
        
        // 再びUIViewにセット.
        self.myImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.myImageView.setNeedsDisplay()
    }

    @IBAction func doRotate(sender: UIBarButtonItem) {
//        // 画像を回転する.
//        let myRotateView:UIImageView = UIImageView(frame: CGRect(x: 100, y: 250, width: 80, height: 80))
//        
//        // UIImageViewに画像を設定する.
//        myRotateView.image = myImage
//        
//        // radianで回転角度を指定(90度)する.
//        angle = angle + CGFloat((90.0 * M_PI) / 180.0)
//        
//        // 回転用のアフィン行列を生成する.
//        self.imgView.transform = CGAffineTransformMakeRotation(angle)
        
//        self.myImageView.transform = CGAffineTransformRotate(self.myImageView.transform, CGFloat(M_PI / 2.0))

//        angle = angle + CGFloat((90.0 * M_PI) / 180.0)
//        self.myImageView.transform = CGAffineTransformMakeRotation(angle)

        angle = CGFloat(M_PI / 2.0)
        let roateTrans = CGAffineTransformMakeRotation(angle)
        let currentTransForm = self.myImageView.transform;
        
        // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
        self.myImageView.transform = CGAffineTransformConcat(currentTransForm, roateTrans);

    }
    
    @IBAction func doCamera(sender: UIBarButtonItem) {
        self.pickImageFromCamera()
    }
    
    @IBAction func doLib(sender: UIBarButtonItem) {
        self.pickImageFromLibrary()
    }

    @IBAction func doChangeColor(sender: UIBarButtonItem) {
        if descaleColor == true {
            descaleColor = false
        } else {
            descaleColor = true
        }
        descaleView.setColor(descaleColor)
        descaleView.setNeedsDisplay()
    }
    
    @IBAction func doViewTable(sender: UIBarButtonItem) {
        if myTableView.hidden == false {
            myTableView.hidden = true
        } else {
            myTableView.hidden = false
        }
    }
    
    @IBAction func doSave(sender: UIBarButtonItem) {
        
        if myTableView.hidden == false {
            myTableView.hidden = true
        }
        
        // 共有する項目
        let shareText = "descale "
        let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!
        
        // スクリーンショットの取得開始
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 1.0)
        
        // 描画
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        
        // 描画が行われたスクリーンショットの取得
        let shareImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // スクリーンショットの取得終了
        UIGraphicsEndImageContext()
        
        let activityItems = [shareText, shareWebsite, shareImage]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityTypePostToWeibo,
//            UIActivityTypeSaveToCameraRoll,
//            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        // UIActivityViewControllerを表示
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            print("通ってる")
            
            
            // 回転用のアフィン行列を生成する.(0度)
            self.myImageView.transform = CGAffineTransformMakeRotation(0)
            
            var image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // おまじない始まり
            UIGraphicsBeginImageContext(image.size);
            image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // おまじない終わり
            
            var perHeight:CGFloat = 1.0
            var perWidth:CGFloat = 1.0
            
            let motifSize:CGSize  = CGRectMake(0, 0, self.view.frame.size.width - 88, self.view.frame.size.height - 88 ).size

            if ( motifSize.height < image.size.height)
            {
                perHeight = motifSize.height / image.size.height;
            }
            if ( motifSize.width < image.size.width)
            {
                perWidth = motifSize.width / image.size.width;
            }
            
            var rect:CGRect
            
            if ( perHeight != 1.0 || perWidth != 1.0) {
                
                if ( perHeight > perWidth )
                {
                    rect = CGRectMake(
                        0,
                        0,
                        image.size.width  * perHeight,
                        image.size.height * perHeight);
                    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
                    image.drawInRect(rect);
                    grayImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                } else {
                    rect = CGRectMake(
                        0,
                        0,
                        image.size.width  * perWidth,
                        image.size.height * perWidth);
                    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
                    image.drawInRect(rect);
                    grayImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
            } else {
                rect = CGRectMake(
                    0,
                    0,
                    image.size.width,
                    image.size.height);
                grayImage = image;
            }

            // オリジナル画像を退避
            orgImage = image
            

            
            // 画像のデータを取得する
//            let image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage;
            
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            
            
            
            // モノクロ化
            grayImage = getGrayImage(grayImage!)
            
            print("image size: \(image)")
            print("grayImage size: \(grayImage?.size)")
//            var imageRect:CGRect  = rect
//            imageRect.origin.x = 0;
//            imageRect.origin.y = 0;
            
            self.myImageView.transform = CGAffineTransformIdentity;
            self.myImageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.myImageView.frame = rect;
            self.myImageView.center = self.view.center

            self.myImageView.image = image;
            self.myImageView.setNeedsDisplay()

            // 変数の初期化
            angle = 0.0
            
            currentTransForm = self.myImageView.transform
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - override func
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // UserDefaultの設定
//        var myDefault = NSUserDefaults.standardUserDefaults()
        
        // AppDeleg
        
        //辞書の配列
        let jsonPath = NSBundle.mainBundle().pathForResource("json", ofType: "txt")
        let jsonData = NSData(contentsOfFile: jsonPath!)
        jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: [])) as! NSArray

        for dat in jsonArray {
            num += [dat["gosu"] as! String]
//            let type = dat["type"] as! String
//            let gosu = dat["gosu"] as! String
//            let s = dat["size"] as! String
//            let h = dat["height"] as! CGFloat
//            let w = dat["width"] as! CGFloat
//            print("型:\(type) 号数:\(gosu) サイズ:\(s) 高さ:\(h) 幅:\(w)")
        }
        
        // baseViewの生成
        baseView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44 - 44))
        baseView.backgroundColor = UIColor.grayColor()
        baseView.userInteractionEnabled = true

        // ジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleGesture:")
        self.baseView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        self.baseView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handleGesture:")
        self.baseView.addGestureRecognizer(pinchGesture)
        
        // baseViewの追加
        self.view.addSubview(baseView)

//        //カスタマイズImageViewを生成
//        imgView = DescaleImageView(frame: baseView.frame)
//        
//        //カスタマイズViewを追加
//        self.baseView.addSubview(imgView)
        
        // baseVieを最背面に移動
        self.view.sendSubviewToBack(baseView)

        // UIImageViewの生成.
        myImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width - 88, self.view.frame.size.height - 88 ))
//        myImageView.image = UIImage(CIImage: myInputImage!)
        self.view.addSubview(myImageView)
        
        // DESCALE Viewの生成
        descaleView = DesView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44 - 44))
        descaleView.userInteractionEnabled = false
        self.view.addSubview(descaleView)
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: self.view.bounds.height - 200 - self.toolbarDescale.bounds.height - 50, width: 190, height: 200))
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.borderColor = UIColor.grayColor().CGColor
        myTableView.layer.borderWidth = 1.0
        myTableView.layer.cornerRadius = 8.0
        myTableView.estimatedRowHeight = 40
        myTableView.rowHeight = UITableViewAutomaticDimension
        
        // Cell名の登録をおこなう.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        myTableView.dataSource = self
        
        // Delegateを設定する.
        myTableView.delegate = self

        // Tableを非表示
        myTableView.hidden = true
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
        if myTableView.hidden == true {
            self.descleColoeBtn.enabled = false
        } else {
            self.descleColoeBtn.enabled = true
        }
        
        // toolBarを最前面に移動
        self.view.bringSubviewToFront(self.toolbarDescale)
        

    }
    
    //-----------------------------------
    // MARK: - TableViewのハンドラ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell

        // Cellに値を設定する.
        cell.textLabel!.text = "\(num[indexPath.row])"
        cell.textLabel?.font = UIFont.systemFontOfSize(10)
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let dat = jsonArray[indexPath.row]

        descaleHight = dat["height"] as! Double
        descaleWidth = dat["width"] as! Double
        
        descaleView.setSize(CGFloat(descaleHight), width: CGFloat(descaleWidth), tapArea: "")
        descaleView.setNeedsDisplay()
        
        if descaleHight == 0 && descaleHight == 0 {
            self.descleColoeBtn.enabled = false
        } else {
            self.descleColoeBtn.enabled = true
        }
        
        if dat["gosu"] as? String == "非表示" {
            self.descaleSelectBtn.title = "descale"
        } else {
            self.descaleSelectBtn.title = dat["gosu"] as? String
        }

    }
    
    //-----------------------------------
    // MARK: - Gestureのハンドラ
    func handleGesture(gesture: UIGestureRecognizer){
        
//        if myTableView.hidden == false {
//            myTableView.hidden = true
//        }
        
        if let tapGesture = gesture as? UITapGestureRecognizer{
            tap(tapGesture)
        }else if let pinchGesture = gesture as? UIPinchGestureRecognizer{
            pinch(pinchGesture)
        }else if let panGesture = gesture as? UIPanGestureRecognizer{
            pan(panGesture)
        }
    }
    
    func tap(gesture: UITapGestureRecognizer){
        
        if gesture.view == self.view {
            print("Tap View")
        } else if gesture.view == self.descaleView {
            print("Tap descaleView")
            // タップviewの色を変える (Red <=> Blue)
            if(descaleView.backgroundColor  == .redColor()) {
                descaleView.backgroundColor = .blueColor()
                print("tap blue")
            } else {
                descaleView.backgroundColor = .redColor()
                print("tap red")
            }
        } else if gesture.view == self.myTableView {
            print("Tap descaleView")
        } else if gesture.view == self.baseView {
            
            if self.myTableView.hidden != true {
                self.myTableView.hidden = true
            } else {
                print("Tap imgView \(gesture.locationInView(self.baseView))")
                
                let tapCenter = gesture.locationInView(descaleView)
                var tapArea:String = ""
                if self.descaleView.center.x < tapCenter.x {
                    if self.descaleView.center.y < tapCenter.y {
                        tapArea = "DOWN-RIGHT"
                    } else {
                        tapArea = "TOP-RIGHT"
                    }
                } else {
                    if self.descaleView.center.y < tapCenter.y {
                        tapArea = "DOWN-LEFT"
                    } else {
                        tapArea = "TOP-LEFT"
                    }
                }
                descaleView.setSize(CGFloat(descaleHight), width: CGFloat(descaleWidth), tapArea: tapArea)
                descaleView.setNeedsDisplay()
            }
            
        } else {
            print("Tap other")
        }
        
    }

    private func pan(gesture:UIPanGestureRecognizer){
        
//        print("func pan")
        
        let translation = gesture.translationInView(self.view)
        var center =  self.myImageView.center
        let  frameView = self.view.frame;
        
//        //centerがviewの内側であること
//        if (translation.x + center.x < 0) {
//            gesture.setTranslation(CGPointZero, inView: self.view)
//            return;
//        }
//        if (translation.y + center.y < 0) {
//            gesture.setTranslation(CGPointZero, inView: self.view)
//            return;
//        }
//        if (translation.x + center.x > frameView.size.width) {
//            gesture.setTranslation(CGPointZero, inView: self.view)
//            return;
//        }
//        if (translation.y + center.y > frameView.size.height) {
//            gesture.setTranslation(CGPointZero, inView: self.view)
//            return;
//        }
        
        center.x = center.x + translation.x;
        center.y = center.y + translation.y;
        
        self.myImageView.center = center;
        gesture.setTranslation(CGPointZero, inView: self.view)
    }

    private func pinch(gesture:UIPinchGestureRecognizer){
        
        // ピンチジェスチャー発生時に、Imageの現在のアフィン変形の状態を保存する
        if (gesture.state == UIGestureRecognizerState.Began) {
            currentTransForm = self.myImageView.transform;
            // currentTransFormは、フィールド変数。imgViewは画像を表示するUIImageView型のフィールド変数。
        }

        // ピンチジェスチャー発生時から、どれだけ拡大率が変化したかを取得する
        // 2本の指の距離が離れた場合には、1以上の値、近づいた場合には、1以下の値が取得できる
        let scale:CGFloat = gesture.scale

        // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
        self.myImageView.transform = CGAffineTransformConcat(currentTransForm, CGAffineTransformMakeScale(scale, scale));
    }

    //-----------------------------------
    // MARK: - Monochro化のハンドラ
    private func getGrayImage(img:UIImage) -> UIImage {
        // ベース画像.
        let myInputImage = CIImage(image: img)
        
        // カラーエフェクトを指定してCIFilterをインスタンス化.
        let myMonochromeFilter = CIFilter(name: "CIColorMonochrome")
        
        // イメージのセット.
        myMonochromeFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
        
        // モノクロ化するための値の調整.
        myMonochromeFilter!.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: kCIInputColorKey)
        myMonochromeFilter!.setValue(1.0, forKey: kCIInputIntensityKey)
        
        // フィルターを通した画像をアウトプット.
        let myOutputImage : CIImage = myMonochromeFilter!.outputImage!
        
        return UIImage(CIImage: myOutputImage)
    }

//    private func getBlackAndWhiteVersionOfImage(anImage:UIImage?) -> UIImage? {
//        
//        var newImage:UIImage;
////
////        if let _ = anImage {
//        
//            let size = anImage!.size
////            var rect = CGRectMake(0.0,0.0, size.width, size.height);
//            let cgImage:CGImageRef = anImage!.CGImage!;
//            
//            let dataProvider:CGDataProviderRef = CGImageGetDataProvider(anImage!.CGImage!)!;
//            var data:CFDataRef = CGDataProviderCopyData(dataProvider)!;
//            let bytesPerRow = CGImageGetBytesPerRow(cgImage);
//            let width: Int = Int(size.width)
//            let height: Int = Int(size.height)
//            let colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!;
//            let bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
//            let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue))
//            let newContext: CGContextRef = CGBitmapContextCreate(CFDataGe213331tBytePtr(data), width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)! as CGContextRef
//
//            let imageRef: CGImageRef = CGBitmapContextCreateImage(newContext)!
//            newImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
//
//        return newImage;
//    }

    
//    private func imageFromSampleBuffer(sampleBuffer :CMSampleBufferRef) -> UIImage {
//
//        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
//        CVPixelBufferLockBaseAddress(imageBuffer, 0)
//        let baseAddress: UnsafeMutablePointer<Void> = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, Int(0))
//        
//        let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(imageBuffer)
//        let width: Int = CVPixelBufferGetWidth(imageBuffer)
//        let height: Int = CVPixelBufferGetHeight(imageBuffer)
//        
//        let colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!;
//        
//        let bitsPerCompornent: Int = 8
//
//        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue))
//        let newContext: CGContextRef = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace, bitmapInfo.rawValue)! as CGContextRef
//        let imageRef: CGImageRef = CGBitmapContextCreateImage(newContext)!
//        let resultImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
//        
//        return resultImage
//    }

//    - (UIImage *)getBlackAndWhiteVersionOfImage:(UIImage *)anImage {
//    
//    UIImage *newImage;
//    
//    if (anImage) {
//    CGSize size = anImage.size;
//    CGRect rect = CGRectMake(0.0f,0.0f, size.width, size.height);
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    CGImageRef cgImage = anImage.CGImage;
//    unsigned long bytesPerRow = CGImageGetBytesPerRow(cgImage);
//    unsigned long bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
//    CGContextRef context = CGBitmapContextCreate(nil,
//    size.width,
//    size.height,
//    bitsPerComponent,
//    bytesPerRow,
//    colorSpace,
//    (CGBitmapInfo)kCGImageAlphaNone);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGContextDrawImage(context, rect, [anImage CGImage]);
//    CGImageRef grayscale = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    newImage = [UIImage imageWithCGImage:grayscale];
//    CFRelease(grayscale);
//    
//    }
//    return newImage;
//    }

}
