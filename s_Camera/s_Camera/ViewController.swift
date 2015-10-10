//
//  ViewController.swift
//  s_Camera
//
//  Created by i.novol on 2015/05/18.
//  Copyright (c) 2015年 i.novol. All rights reserved.
//

import UIKit

class ViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var lastScale:CGFloat = 1
    var flgUpDown:Int = 1
    
    var cameraAreaSize: CGSize {
        get {
            return CGSizeMake(self.view.frame.width,self.view.frame.height)
        }
    }

    var jsonFsize:NSArray = []
    var jsonPsize:NSArray = []
    var jsonMsize:NSArray = []
    var jsonOther:NSArray = []
    
    @IBOutlet weak var desView: DescaleView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewSizeList: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBAction func addButton(sender: AnyObject) {
        // 忘れないように！
        self.flgUpDown=1
        self.pickImageFromCamera()
    }
    
    @IBAction func doDispList(sender: AnyObject) {
        self.desSizeListAnima()
    }
    
    @IBAction func doChangeFrameColor(sender: AnyObject) {
        if self.desView.desFrameColoe == UIColor.blackColor() {
            self.desView.desFrameColoe = UIColor.whiteColor()
        } else {
            self.desView.desFrameColoe = UIColor.blackColor()
        }
        desView.setNeedsDisplay()
    }

    @IBAction func doClear(sender: UIButton) {
        self.desView.desDispFlg = false
        desView.setNeedsDisplay()
    }

    @IBAction func doOpen(sender: UIBarButtonItem) {
        // 忘れないように！
        self.flgUpDown=1
        self.pickImageFromLibrary()
    }

    
    
    @IBAction func doPinch(sender: UIPinchGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began ) {
            lastScale = sender.scale
        }
        
        if (sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed) {
//            var newScale:CGFloat = 1 - (lastScale - sender.scale)
            let newScale = 1 - (lastScale - sender.scale)
            print("[1] sender:\(sender.scale) lastScale:\(lastScale) newScale:\(newScale)")
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, newScale, newScale)
            
            lastScale = sender.scale
        }
    }
    
    @IBAction func doRotation(sender: UIBarButtonItem) {
//        let angle:CGFloat = CGFloat( M_PI / 180.0)
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, CGFloat(M_PI / 2))
    }
//    @IBAction func doRotation(sender: UIRotationGestureRecognizer) {
//        let angle:CGFloat = CGFloat( M_PI / 180.0)
//        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, CGFloat(M_PI / 2))
//   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewSizeList.frame = CGRectMake(0, 500, 175, 300)
    }
    
    override func viewWillAppear(animated: Bool) {

        //辞書の配列
//        var jsonPathF = NSBundle.mainBundle().pathForResource("frame/5s/jsonFsize", ofType: "txt")
//        var jsonDataF = NSData(contentsOfFile: jsonPathF!)
        let jsonPathF = NSBundle.mainBundle().pathForResource("frame/5s/jsonFsize", ofType: "txt")
        let jsonDataF = NSData(contentsOfFile: jsonPathF!)
        jsonFsize = try! NSJSONSerialization.JSONObjectWithData(jsonDataF!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        
        
        //-- debug --
//        let txtNg = ""
//        let txtOk = "{\"hoge\": {\"huga\":1, \"hige\":2}}"
//        let data = txtNg.dataUsingEncoding(NSUTF8StringEncoding) as NSData!
//        let data = txtOk.dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        

        
        
        
        
        let jsonPathP = NSBundle.mainBundle().pathForResource("frame/5s/jsonPsize", ofType: "txt")
        let jsonDataP = NSData(contentsOfFile: jsonPathP!)
        jsonPsize = try! NSJSONSerialization.JSONObjectWithData(jsonDataP!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
 
        let jsonPathM = NSBundle.mainBundle().pathForResource("frame/5s/jsonMsize", ofType: "txt")
        let jsonDataM = NSData(contentsOfFile: jsonPathM!)
        jsonMsize = try! NSJSONSerialization.JSONObjectWithData(jsonDataM!, options: NSJSONReadingOptions.MutableContainers) as! NSArray

        let jsonPathO = NSBundle.mainBundle().pathForResource("frame/5s/jsonOther", ofType: "txt")
        let jsonDataO = NSData(contentsOfFile: jsonPathO!)
        jsonOther = try! NSJSONSerialization.JSONObjectWithData(jsonDataO!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            print(image)
            
            self.imageView.image = image
            
//            UIImageWriteToSavedPhotosAlbum(image, self, Selector("didSaveToPhotoApp:error:comtextInfo:"),UnsafeMutablePointer())
            
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSaveToPhotoApp( image: UIImage!,  error: NSErrorPointer, comtextInfo:UnsafePointer<()>) {
        print("保存OK")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "F size"
        } else if section == 1 {
            return "P size"
        } else if section == 2 {
            return "M size"
        } else {
            return "Other"
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return jsonFsize.count
        } else if section == 1 {
            return jsonPsize.count
        } else if section == 2 {
            return jsonMsize.count
        } else {
            return jsonOther.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")

        var gosu:String
        var desuSize:String
        
        if indexPath.section == 0 {
            gosu = jsonFsize[indexPath.row]["gosu"] as! String
            desuSize = jsonFsize[indexPath.row]["size"] as! String
        } else if indexPath.section == 1 {
            gosu = jsonPsize[indexPath.row]["gosu"] as! String
            desuSize = jsonPsize[indexPath.row]["size"] as! String
        } else if indexPath.section == 2 {
            gosu = jsonMsize[indexPath.row]["gosu"] as! String
            desuSize = jsonMsize[indexPath.row]["size"] as! String
        } else {
            gosu = jsonOther[indexPath.row]["gosu"] as! String
            desuSize = jsonOther[indexPath.row]["size"] as! String
        }
        
        cell.textLabel?.text = gosu
        cell.detailTextLabel?.text = desuSize
        
        cell.textLabel?.textColor = UIColor.blueColor()
        cell.detailTextLabel?.textColor = UIColor.brownColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(11)
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Index:\(indexPath.row)")
        
        var xxx:CGPoint
        
        if indexPath.section == 0 {
            desView.desDispFlg = true
            xxx = CGPointMake(jsonFsize[indexPath.row]["width"] as! CGFloat, jsonFsize[indexPath.row]["height"] as! CGFloat)
            
        } else if indexPath.section == 1 {
            desView.desDispFlg = true
            xxx = CGPointMake(jsonPsize[indexPath.row]["width"] as! CGFloat, jsonPsize[indexPath.row]["height"] as! CGFloat)

        } else if indexPath.section == 2 {
            desView.desDispFlg = true
            xxx = CGPointMake(jsonMsize[indexPath.row]["width"] as! CGFloat, jsonMsize[indexPath.row]["height"] as! CGFloat)
            
        } else {
            desView.desDispFlg = true
            xxx = CGPointMake(jsonOther[indexPath.row]["width"] as! CGFloat, jsonOther[indexPath.row]["height"] as! CGFloat)
        }
        
        // Screen Size の取得
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height - self.toolBar.frame.height
        self.desView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        self.desView.backgroundColor = UIColor.clearColor()
        self.desView.userInteractionEnabled = false
        self.desView.selectDesSize(xxx.x, y: xxx.y)
        desView.setNeedsDisplay()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func desSizeListAnima() {
        if self.flgUpDown == -1 {
            UIView.animateWithDuration(0.3, animations: {
                self.viewSizeList.frame = CGRectMake(
                    0,
                    600,
                    self.viewSizeList.frame.width,
                    self.viewSizeList.frame.height)
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.viewSizeList.frame = CGRectMake(
                    0,
                    220,
                    self.viewSizeList.frame.width,
                    self.viewSizeList.frame.height)
                }, completion: nil)
        }
        flgUpDown *= -1
    }

    /*
    タッチを感知した際に呼ばれるメソッド.
    */
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//        //        // Labelアニメーション.
//        //        UIView.animateWithDuration(0.06,
//        //            // アニメーション中の処理.
//        //            animations: { () -> Void in
//        //                // 縮小用アフィン行列を作成する.
//        //                self.viewImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
//        //            })
//        //            { (Bool) -> Void in
//        //        }
//    }
    
    /*
    ドラッグを感知した際に呼ばれるメソッド.
    (ドラッグ中何度も呼ばれる)
    */
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//        // タッチイベントを取得.
//        let aTouch = touches.first as! UITouch
//        
//        // 移動した先の座標を取得.
//        let location = aTouch.locationInView(self.view)
//        
//        // 移動する前の座標を取得.
//        let prevLocation = aTouch.previousLocationInView(self.view)
//        
//        // CGRect生成.
//        var myFrame: CGRect = self.imageView.frame
//        // ドラッグで移動したx, y距離をとる.
//        let deltaX: CGFloat = location.x - prevLocation.x
//        let deltaY: CGFloat = location.y - prevLocation.y
//        
//        // 移動した分の距離をmyFrameの座標にプラスする.
//        myFrame.origin.x += deltaX
//        myFrame.origin.y += deltaY
//        
//        // frameにmyFrameを追加.
//        self.imageView.frame = myFrame
//        
//    }
    
    /*
    指が離れたことを感知した際に呼ばれるメソッド.
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //       println("sc:\(self.scale) tE:\(self.viewImage.frame)")
        
        //        // Labelアニメーション.
        //        UIView.animateWithDuration(0.1,
        //
        //            // アニメーション中の処理.
        //            animations: { () -> Void in
        //                // 拡大用アフィン行列を作成する.
        //                self.viewImage.transform = CGAffineTransformMakeScale(0.4, 0.4)
        //                // 縮小用アフィン行列を作成する.
        //                self.viewImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
        //            })
        //            { (Bool) -> Void in
        //                
        //        }
    }

}