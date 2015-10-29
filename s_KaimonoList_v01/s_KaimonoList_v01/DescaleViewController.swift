//
//  DescaleViewController.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/12.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit
import Accounts

class DescaleViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate
{
    // private variables
    private var watchImageMode = true
    private var beforePoint = CGPointMake(0.0, 0.0)
    private var currentScale:CGFloat = 1.0

    var num:[String] = []
    var jsonArray:NSArray = []
    var myApp = UIApplication.sharedApplication().delegate as! AppDelegate

    // Tableで使用する配列を設定する
    var myTableView: UITableView!

    // Descaleの表示View
    var descaleView:desView!
    
    // Imageの表示View
    var baseView:UIView!

    // Imageの表示View
    var imgView:DescaleImageView!

    var descaleHight:Double = 0.0
    var descaleWidth:Double = 0.0
    var descaleColor:Bool = true
    
    @IBOutlet weak var toolbarDescale: UIToolbar!
    @IBOutlet weak var descaleSelectBtn: UIBarButtonItem!
    @IBOutlet weak var descleColoeBtn: UIBarButtonItem!
    
    @IBAction func doCamera(sender: UIBarButtonItem) {
        self.pickImageFromCamera()
        self.pickImageFromLibrary()
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
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imgView.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
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
    
    // MARK: - UIActivityViewController
    @IBAction func doSave(sender: UIBarButtonItem) {
        // 共有する項目
        let shareText = "descale "
        let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!
        let shareImage = UIImage(named: "sample.jpg")!
        
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
        
        // myViewの生成
        baseView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44 - 44))
        baseView.backgroundColor = UIColor.orangeColor()
        baseView.userInteractionEnabled = true

        // ジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleGesture:")
        self.baseView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        self.baseView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handleGesture:")
        self.baseView.addGestureRecognizer(pinchGesture)
        
        
        // Viewの追加
        self.view.addSubview(baseView)

        //カスタマイズImageViewを生成
        imgView = DescaleImageView(frame: baseView.frame)
        
        //カスタマイズViewを追加
        self.baseView.addSubview(imgView)
        
        // baseVieを最背面に移動
        self.view.sendSubviewToBack(baseView)

        // DESCALE Viewの生成
        descaleView = desView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44 - 44))
        descaleView.userInteractionEnabled = false
        self.view.addSubview(descaleView)
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: self.view.bounds.height - 200 - self.toolbarDescale.bounds.height - 44, width: 190, height: 200))
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

    func handleGesture(gesture: UIGestureRecognizer){
        if let tapGesture = gesture as? UITapGestureRecognizer{
            tap(tapGesture)
        }else if let pinchGesture = gesture as? UIPinchGestureRecognizer{
            pinch(pinchGesture)
        }else if let panGesture = gesture as? UIPanGestureRecognizer{
            pan(panGesture)
        }
    }
    
    private func pan(gesture:UIPanGestureRecognizer){
        
        print("func pan")
        
        if self.watchImageMode{
            
            if gesture.view == self.baseView {
                print("Pan baseView")
            }
            
            var translation = gesture.translationInView(self.view)
            
            if abs(self.beforePoint.x) > 0.0 || abs(self.beforePoint.y) > 0.0{
                translation = CGPointMake(self.beforePoint.x + translation.x, self.beforePoint.y + translation.y)
            }
            
            switch gesture.state{
            case .Changed:
                let scaleTransform = CGAffineTransformMakeScale(self.currentScale, self.currentScale)
                let translationTransform = CGAffineTransformMakeTranslation(translation.x, translation.y)
                self.imgView.transform = CGAffineTransformConcat(scaleTransform, translationTransform)
            case .Ended , .Cancelled:
                self.beforePoint = translation
            default:
                NSLog("no action")
            }
        }
    }

    private func pinch(gesture:UIPinchGestureRecognizer){
        
        if self.watchImageMode{
            
            if gesture.view == self.baseView {
                print("Pinch baseView")
            }
            
            var scale = gesture.scale
            if self.currentScale > 1.0{
                scale = self.currentScale + (scale - 1.0)
            }
            switch gesture.state{
            case .Changed:
                let scaleTransform = CGAffineTransformMakeScale(scale, scale)
                let transitionTransform = CGAffineTransformMakeTranslation(self.beforePoint.x, self.beforePoint.y)
                self.imgView.transform = CGAffineTransformConcat(scaleTransform, transitionTransform)
            case .Ended , .Cancelled:
                if scale <= 1.0{
                    self.currentScale = 1.0
                    self.imgView.transform = CGAffineTransformIdentity
                }else{
                    self.currentScale = scale
                }
            default:
                NSLog("not action")
            }
        }
    }

//    private func pan(gesture:UIPanGestureRecognizer){
//        if self.watchImageMode{
//            
//            var translation = gesture.translationInView(self.view)
//            
//            if abs(self.beforePoint.x) > 0.0 || abs(self.beforePoint.y) > 0.0{
//                translation = CGPointMake(self.beforePoint.x + translation.x, self.beforePoint.y + translation.y)
//            }
//            
//            switch gesture.state{
//            case .Changed:
//                let scaleTransform = CGAffineTransformMakeScale(self.currentScale, self.currentScale)
//                let translationTransform = CGAffineTransformMakeTranslation(translation.x, translation.y)
//                self.imageView.transform = CGAffineTransformConcat(scaleTransform, translationTransform)
//            case .Ended , .Cancelled:
//                self.beforePoint = translation
//            default:
//                NSLog("no action")
//            }
//        }
//    }
    
//    func panGesture(gesture:UIPanGestureRecognizer){
//        if gesture.view == self.view {
//            print("Pan View")
//        } else if gesture.view == self.descaleView {
//            print("Pan descaleView")
//        } else if gesture.view == self.myTableView {
//            print("Pan descaleView")
//        } else if gesture.view == self.baseView {
//            print("Pan baseView")
//
//            if let gestureView = gesture.view{
//            
//                var translation = gesture.translationInView(gestureView)
//                
//                if abs(self.beforePoint.x) > 0.0 || abs(self.beforePoint.y) > 0.0{
//                    translation = CGPointMake(self.beforePoint.x + translation.x, self.beforePoint.y + translation.y)
//                }
//                
//                switch gesture.state{
//                case .Changed:
//                    let scaleTransform = CGAffineTransformMakeScale(self.currentScale, self.currentScale)
//                    let translationTransform = CGAffineTransformMakeTranslation(translation.x, translation.y)
//                    self.imgView.transform = CGAffineTransformConcat(scaleTransform, translationTransform)
//                case .Ended , .Cancelled:
//                    self.beforePoint = translation
//                default:
//                    NSLog("no action")
//                }
//            }
//        } else {
//            print("Pan Else")
//        }
//        
//    }
    
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        let touch = touches.anyObject()! as UITouch
//        let location = touch.locationInView(view)
//    }
    
    
    // MAKE: UIActiveViewController
/*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image =  info[UIImagePickerControllerOriginalImage] as! UIImage
        
//        var editImage = adjustImageRotatetion(image)
        var editImage = image
        
//        imageOriginalSize = editImage.size
//        editImage = changeSizeImage(editImage)
//        editImage = makeSqureImage(editImage)
//        editImage = makeImageWithFrameImage(editImage)
//        editImage = makeImageWithStampimages(editImage)
        UIImageWriteToSavedPhotosAlbum(
            editImage,
            self,
            Selector("didSaveToPhotosApp:error:contextInfo:"),
            UnsafeMutablePointer()
        )
        print("写真を撮りました")
    }
*/

/*
    func didSaveToPhotosApp(image: UIImage!, error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        print("撮った写真を写真アプリに保存しました。")
        
//        self.resetAllStamps()
        
        let activityViewConstroller: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(activityViewConstroller, animated: true, completion: nil)
    }
*/

}
