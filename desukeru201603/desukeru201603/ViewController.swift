//
//  ViewController.swift
//  desukeru201603
//
//  Created by i.novol on 2016/03/15.
//  Copyright © 2016年 i.novol. All rights reserved.
//

import UIKit

class ViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate
{

    // MARK: - 変数
    // Pinch
    var beforePoint = CGPointMake(0.0, 0.0)
    var currentScale:CGFloat = 1.0
    var lastScale:CGFloat = 1.0

    // DesukeruList
    var num:[String] = []
    var jsonArray:NSArray = []
    var myApp = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // 最背面でguestureを制御するView
    var baseView:UIView!
    
    // desukeruの表示View (罫線を描画)
    var desukeruView:DesukeruView!
    
    // ImageView.
    var myImageView: UIImageView!
    
    // オリジナル画像・モノクロ画像の退避変数.
    var grayImage:UIImage?
    var orgImage:UIImage?
    
    // Tableで使用する配列を設定する
    var myTableView: UITableView!
    
    // desukeru変数
    var desukeruHight:Double = 0.0
    var desukeruWidth:Double = 0.0
    var desukeruColor:Bool = true
    var angle:CGFloat = 0.0
    var monoFlg:Bool = true
    var currentTransForm:CGAffineTransform!
    
    // 画面サイズ
    var myHeight:CGFloat = 0
    var myWidth:CGFloat = 0
    var myCenter:CGPoint = CGPointMake(0, 0)
    
    
    // MARK: - @IBOutlet
    @IBOutlet weak var desukeruToolbar: UIToolbar!
    @IBOutlet weak var desukeruSelectBtn: UIBarButtonItem!
    @IBOutlet weak var desukeruChangeColorBtn: UIBarButtonItem!
    @IBOutlet weak var desukeruActionBtn: UIBarButtonItem!
    @IBOutlet weak var desukeruCameraBtn: UIBarButtonItem!
    @IBOutlet weak var desukeruLibBtn: UIBarButtonItem!
    @IBOutlet weak var desukeruRotetoBtn: UIBarButtonItem!
    @IBOutlet weak var desukeruMonochomeBtn: UIBarButtonItem!
    
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
        if desukeruColor == true {
            desukeruColor = false
        } else {
            desukeruColor = true
        }
        desukeruView.setColor(desukeruColor)
        desukeruView.setNeedsDisplay()
    }
    
    @IBAction func doViewTable(sender: UIBarButtonItem) {
        if myTableView.hidden == false {
            myTableView.hidden = true
        } else {
            myTableView.hidden = false
        }
    }
    
    @IBAction func doAction(sender: UIBarButtonItem) {

        if myTableView.hidden == false {
            myTableView.hidden = true
        }
        
        // 共有する項目
        let shareText = "desukeru "
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
        
        // iPad用のおまじない（これがないと強制終了する）
        activityVC.popoverPresentationController?.sourceView = self.view
        
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
    
    
    // MRK:- StatusBar非表示
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - override func
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //辞書の配列
        let jsonPath = NSBundle.mainBundle().pathForResource("json", ofType: "txt")
        let jsonData = NSData(contentsOfFile: jsonPath!)
        jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: [])) as! NSArray
        
        for dat in jsonArray {
            num += [dat["gosu"] as! String]
        }
        
        // size調整
        myHeight = ( self.view.bounds.height - self.desukeruToolbar.frame.height )
        myWidth = ( self.view.bounds.width )
        myCenter = self.view.center
        myCenter.y = myCenter.y - ( self.desukeruToolbar.frame.height ) / 2

        baseView = UIView(frame: CGRectMake(0, 0, myWidth, myHeight))
        baseView.center = myCenter
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
        
        // baseVieを最背面に移動
        self.view.sendSubviewToBack(baseView)
        
// -------------------------------
        //ここ注意！これでいいのか？
        // UIImageViewの生成.
        myImageView = UIImageView(frame: CGRectMake(0, 0, myWidth, myHeight ))
        self.view.addSubview(myImageView)
// -------------------------------
        
        // desukeruViewの生成
        desukeruView = DesukeruView(frame: CGRectMake(0, 0, myWidth, myHeight))
        desukeruView.userInteractionEnabled = false
        self.view.addSubview(desukeruView)
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: self.view.bounds.height - 200 - self.desukeruToolbar.bounds.height, width: 190, height: 200))
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
            self.desukeruChangeColorBtn.enabled = false
        } else {
            self.desukeruChangeColorBtn.enabled = true
        }
        
        // toolBarを最前面に移動
        self.view.bringSubviewToFront(self.desukeruToolbar)
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
        
        desukeruHight = dat["height"] as! Double
        desukeruWidth = dat["width"] as! Double
        
        desukeruView.setSize(CGFloat(desukeruHight), width: CGFloat(desukeruWidth), tapArea: "")
        desukeruView.setNeedsDisplay()
        
        if desukeruHight == 0 && desukeruHight == 0 {
            self.desukeruChangeColorBtn.enabled = false
        } else {
            self.desukeruChangeColorBtn.enabled = true
        }
        
        if dat["gosu"] as? String == "非表示" {
            self.desukeruSelectBtn.title = "デスケル"
        } else {
            let title = (dat["gosu"] as? String)! + "          "
            self.desukeruSelectBtn.title = title[title.startIndex ... title.startIndex.advancedBy(8)]
        }
        
    }
    
    //-----------------------------------
    // MARK: - Gestureのハンドラ
    func handleGesture(gesture: UIGestureRecognizer){
        
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
        } else if gesture.view == self.desukeruView {
            print("Tap desukeruView")
            // タップviewの色を変える (Red <=> Blue)
            if(desukeruView.backgroundColor  == .redColor()) {
                desukeruView.backgroundColor = .blueColor()
                print("tap blue")
            } else {
                desukeruView.backgroundColor = .redColor()
                print("tap red")
            }
        } else if gesture.view == self.myTableView {
            print("Tap desukeruView")
        } else if gesture.view == self.baseView {
            if self.myTableView.hidden != true {
                self.myTableView.hidden = true
            } else {
                print("Tap imgView \(gesture.locationInView(self.baseView))")
                
                let tapCenter = gesture.locationInView(desukeruView)
                var tapArea:String = ""
                if self.desukeruView.center.x < tapCenter.x {
                    if self.desukeruView.center.y < tapCenter.y {
                        tapArea = "DOWN-RIGHT"
                    } else {
                        tapArea = "TOP-RIGHT"
                    }
                } else {
                    if self.desukeruView.center.y < tapCenter.y {
                        tapArea = "DOWN-LEFT"
                    } else {
                        tapArea = "TOP-LEFT"
                    }
                }
                desukeruView.setSize(CGFloat(desukeruHight), width: CGFloat(desukeruWidth), tapArea: tapArea)
                desukeruView.setNeedsDisplay()
            }
            
        } else {
            print("Tap other")
        }
        
    }
    
    private func pan(gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translationInView(self.view)
        var center =  self.myImageView.center
        
        center.x = center.x + translation.x;
        center.y = center.y + translation.y;
        
        self.myImageView.center = center;
        gesture.setTranslation(CGPointZero, inView: self.view)
    }
    
    private func pinch(gesture:UIPinchGestureRecognizer){
        
        // ピンチジェスチャー発生時に、Imageの現在のアフィン変形の状態を保存する
        if (gesture.state == UIGestureRecognizerState.Began) {
            // currentTransFormは、フィールド変数。imgViewは画像を表示するUIImageView型のフィールド変数。
            currentTransForm = self.myImageView.transform;
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
    
}

