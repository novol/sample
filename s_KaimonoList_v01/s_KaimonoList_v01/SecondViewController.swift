//
//  SecondViewController.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/07/30.
//  Copyright (c) 2015年 i.novol. All rights reserved.
//

import UIKit

//public extension NSDate {
//    public class func ISOStringFromDate(date: NSDate) -> String {
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//        
//        return dateFormatter.stringFromDate(date).stringByAppendingString("Z")
//    }
//    
//    public class func dateFromISOString(string: String) -> NSDate {
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        
//        return dateFormatter.dateFromString(string)!
//    }
//}

class SecondViewController:
    UIViewController,
    UIPickerViewDelegate,
    UIToolbarDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
   
    // MARK: - 変数
    let SDS = SwiftDataSample()
    var num:[String] = []
    var toolBarHizuke: UIToolbar!
    var toolBarKanjo: UIToolbar!
    var pickerView = UIPickerView()
    
    // NSUserDefaults のインスタンス取得
    let ud = NSUserDefaults.standardUserDefaults()
    
    // Tableで使用する配列を設定する
    private var myTableView: UITableView!

    // MARK: - @IBOutlet
    @IBOutlet weak var txtHizuke: UITextField!
    @IBOutlet weak var txtKanjo: UITextField!
    @IBOutlet weak var txtKingaku: UITextField!
    @IBOutlet weak var imgReceipt: UIImageView!
    
    // MARK: - @IBAction
    
    @IBAction func doPickup(sender: UIButton) {
        self.pickImageFromLibrary()
    }
    
    @IBAction func doAllDelet(sender: UIButton) {
        SDS.deleteAll()
        print("All Delete")   
    }
    
    @IBAction func doDrop(sender: UIButton) {
        SDS.drop_table()
    }
    
    @IBAction func doAdd(sender: UIButton) {
        if self.txtHizuke.text == "" {
            print("err:doAdd txtHizuke")
        } else if self.txtKanjo.text == "" {
            print("err:doAdd txtKanjo")
        } else if self.txtKingaku.text == "" {
            print("err:doAdd txtKanjo")
        } else {
            // 入力値を登録
            let kingaku = Int(txtKingaku.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: [], range: nil))
            print("kingaku:\(kingaku)")
            if let img = self.imgReceipt.image {

                if img.imageOrientation == UIImageOrientation.Up {
                    print("Add:Up")
                } else if img.imageOrientation == UIImageOrientation.Down {
                    print("Add:Down")
                } else if img.imageOrientation == UIImageOrientation.Right {
                    print("Add:Right")
                } else if img.imageOrientation == UIImageOrientation.Left {
                    print("Add:Left")
                } else {
                    print("Add:OTHER")
                }
                
                
                
                
                let imgStr = Image2String(img)

                let now = NSDate()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let string = formatter.stringFromDate(now)
                
                // キーを指定してオブジェクトを保存
                ud.setObject(imgStr, forKey: string)
                ud.synchronize()
                
                SDS.Add(txtHizuke.text!, kanjo: txtKanjo.text!, kingaku: kingaku!, receipt: string)

            } else {
                SDS.Add(txtHizuke.text!, kanjo: txtKanjo.text!, kingaku: kingaku!, receipt: "")
            }

            // PickerViewの選択値を取得
            num = SDS.Selectkanjo()
            print("num:\(num)")

            // 選択肢の更新
            self.myTableView.reloadData()
            
            //----------------------------------
            // 初期値
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy/MM/dd"
            self.txtHizuke.text = dateFormatter.stringFromDate(NSDate())
            self.txtKanjo.text = ""
            self.txtKingaku.text = ""
            self.imgReceipt.image = nil
        }
    }

    
    /*
    @IBAction func didEnd(sender: UITextField) {
        var num = sender.text.toInt()
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        var result = formatter.stringFromNumber(num!)
    }
    */
    
    @IBAction func doTouchDown(sender: UITextField) {
        // Tableを非表示
        myTableView.hidden = false
    }

    @IBAction func doHiddenTableKanjo(sender: UITextField) {
        myTableView.hidden = true
    }
    
    @IBAction func doEndEdit(sender: UITextField) {
//        if let kingaku = txtKingaku.text.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range:nil).toInt() {
//            var formatter = NSNumberFormatter()
//            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
//            formatter.groupingSeparator = ","
//            formatter.groupingSize = 3
//            self.txtKingaku.text = formatter.stringFromNumber(kingaku)
//        }
    }

    @IBAction func rightRotate(sender: UIButton) {
    }
    
    @IBAction func leftRotate(sender: UIButton) {
    }
    
    // MARK: - Original
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //----------------------------------
        // 初期値
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.txtHizuke.text = dateFormatter.stringFromDate(NSDate())
        self.txtKanjo.text = ""
        self.txtKingaku.text = ""
        
        //----------------------------------
        // 日付
        // DatePickerに切替
        let datePV = UIDatePicker()
        datePV.datePickerMode = UIDatePickerMode.Date
        datePV.locale = NSLocale(localeIdentifier: "ja_JP")
        datePV.backgroundColor = UIColor.whiteColor()
        datePV.date = NSDate()
        datePV.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)

        // inputのViewを別のViewに切り替える
        self.txtHizuke.inputView = datePV
        
        // toolBar作成
        toolBarHizuke = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBarHizuke.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBarHizuke.barStyle = .BlackTranslucent
        toolBarHizuke.tintColor = UIColor.whiteColor()
        toolBarHizuke.backgroundColor = UIColor.blackColor()
        
        // toolBarBtnのAction設定
        let toolBarBtnHizuke = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: "tappedToolBarBtnHizuke:")
        toolBarBtnHizuke.tag = 1
        toolBarHizuke.items = [toolBarBtnHizuke]
        self.txtHizuke.inputAccessoryView = toolBarHizuke

        //----------------------------------
        // 勘定
        // PickerViewの選択値を取得
        num = SDS.Selectkanjo()
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 96, y: 100, width: 190, height: 100))
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.borderColor = UIColor.grayColor().CGColor
        myTableView.layer.borderWidth = 1.0
        myTableView.layer.cornerRadius = 10.0
        
        /*
        self.imageView.layer.borderColor = UIColor.redColor().CGColor
        self.imageView.layer.borderWidth = 10
        
        self.backgroundColor = UIColor.clearColor()
        self.mainView.backgroundColor = UIColor.whiteColor()
        self.mainView.layer.cornerRadius = 10.0
        self.mainView.layer.masksToBounds = true
        self.imageModelLabel.text = imageData.model
        self.imageNameLabel.text = imageData.name
        self.profileImageView.image = UIImage(named: imageData.imageURL!)
        */

        
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
        
//        // PickerViewに切替
//        self.txtKanjo.placeholder = ""
//        pickerView.showsSelectionIndicator = true
//        pickerView.delegate = self
//
//        // inputのViewを別のViewに切り替える
//        self.txtKanjo.inputView = pickerView
//        
//        // toolBar作成
//        toolBarKanjo = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
//        toolBarKanjo.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
//        toolBarKanjo.barStyle = .BlackTranslucent
//        toolBarKanjo.tintColor = UIColor.whiteColor()
//        toolBarKanjo.backgroundColor = UIColor.blackColor()
//        
//        let toolBarBtnKanjo = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: "tappedToolBarBtnKanjo:")
//        toolBarBtnKanjo.tag = 1
//        toolBarKanjo.items = [toolBarBtnKanjo]
//        self.txtKanjo.inputAccessoryView = toolBarKanjo
        
    }

//    override func viewWillAppear(animated: Bool) {
//        self.txtHizuke.text = ""
//        self.txtKanjo.text = ""
//        self.txtKingaku.text = ""
//        self.imgReceipt.image = nil
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----------------------------------
    // MARK: - PickerViewの必須関数
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return num.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return num[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtKanjo.text = num[row]
    }
    
    func tappedToolBarBtnHizuke(sender: UIBarButtonItem) {
        self.txtHizuke.resignFirstResponder()
    }
    
    func tappedToolBarBtnKanjo(sender: UIBarButtonItem) {
        self.txtKanjo.resignFirstResponder()
    }

    //-----------------------------------
    // MARK: - DatePickerViewのハンドラ
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.txtHizuke.text = dateFormatter.stringFromDate(sender.date)
    }

    //-----------------------------------
    // MARK: - TableViewのハンドラ
    /*
    Cellが選択された際に呼び出されるデリゲートメソッド.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(num[indexPath.row])")
        self.txtKanjo.text = num[indexPath.row]
        myTableView.hidden = true
    }
    
    /*
    Cellの総数を返すデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num.count
    }
    
    /*
    Cellに値を設定するデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(num[indexPath.row])"
        cell.textLabel?.font = UIFont.systemFontOfSize(12)
        
        return cell
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

            var image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            if image.imageOrientation == UIImageOrientation.Up {
                print("pickup:Up")
            } else if image.imageOrientation == UIImageOrientation.Down {
                print("pickup:Down")
            } else if image.imageOrientation == UIImageOrientation.Right {
                print("pickup:Right")
            } else if image.imageOrientation == UIImageOrientation.Left {
                print("pickup:Left")
            } else {
                print("pickup:OTHER")
            }
            
/*
            //写真のメターデータよこせ
            let metadata = info[UIImagePickerControllerMediaMetadata]!
            // Exifの参照を取得
            let exif = metadata[kCGImagePropertyExifDictionary]
            println(exif)
            // 向きをよこせ
            let orientation = metadata[kCGImagePropertyOrientation]
            println(o)
            //写真のメターデータを取得
            var metadata = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
            
            // Exifの参照を取得
            let exif = metadata?.objectForKey(kCGImagePropertyExifDictionary)
            println(exif)
            
            // 画像の向きを取得
            let orientation = metadata?.objectForKey(kCGImagePropertyExifDictionary)
            println(orientation)

*/
            
            if image.imageOrientation != UIImageOrientation.Right {
               let cgImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width, image.size.height))
                image = UIImage(CGImage: cgImage!, scale: image.scale, orientation: image.imageOrientation)
            }
            
            self.imgReceipt.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //UIImageをデータベースに格納できるStringに変換する
    func Image2String(image:UIImage) -> String? {
        
        //画像をNSDataに変換
        //NSDataへの変換が成功していたら
        if let data:NSData = UIImagePNGRepresentation(image) {
            //BASE64のStringに変換する
            let encodeString:String =
            data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            return encodeString
        }

        return nil
    }
//    
//    func adjustImageRotation(baseImage: UIImage) -> UIImage {
//        
//        var editImage = baseImage
//        if baseImage.imageOrientation != UIImageOrientation.Right {
//            let cgImage = CGImageCreateWithImageInRect(baseImage.CGImage, CGRectMake(0, 0, baseImage.size.width, baseImage.size.height))
//            editImage = UIImage(CGImage: cgImage, scale: baseImage.scale, orientation: UIImageOrientation.Right)!
//        }
//        return editImage
//    }

    /*
    func test(a: Int, b: String) -> [(a:Int, b:String, c:NSDate)] {
    
        var res = [(a:Int(), b:String(), c:NSDate())]
        
        /*
        if a >= 100 {
            return [(100,"AAA",NSDate()),(200,"BBB",NSDate()),(300,"CCC",NSDate())]
        } else {
            return [(1,"A",NSDate()),(2,"B",NSDate()),(3,"C",NSDate())]
        }
        */
        
        if a >= 100 {
            res = [(100,"AAA",NSDate()),(200,"BBB",NSDate()),(300,"CCC",NSDate())]
        } else {
            res = [(1,"A",NSDate()),(2,"B",NSDate()),(3,"C",NSDate())]
        }

        return res

    }

    @IBAction func doTaple(sender: UIButton) {

        let resultSet = test(10, b: "A")
        
        let dateFormatter = NSDateFormatter()                       // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"            // フォーマットの指定
        
        for row in resultSet {
            println("res a:\(row.a) b:\(row.b) c:\(dateFormatter.stringFromDate(row.c))")
        }
        
    }
    
    @IBAction func doTaple100(sender: UIButton) {

        let resultSet = test(100, b: "A")
        
        let dateFormatter = NSDateFormatter()                       // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "HH:mm:ss"                       // フォーマットの指定

        for row in resultSet {
            println("res a:\(row.a) b:\(row.b) c:\(dateFormatter.stringFromDate(row.c))")
        }
    
    }

    @IBAction func doAdd(sender: UIButton) {
        SDS.Add(NSDate(), kanjo: "AAA", kingaku: 100)
    }
    
    @IBAction func doSelect(sender: UIButton) {
        var resultSet = SDS.SelectAll()
        
        let dateFormatter = NSDateFormatter()                       // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"            // フォーマットの指定
        
        for row in resultSet {
            println("res ID:\(row.ID) 日付:\(dateFormatter.stringFromDate(row.hiduke)) 科目:\(row.kanjo) 金額:\(row.kingaku))")
        }
    }
    
    @IBAction func doDelete(sender: UIButton) {
        SDS.deleteAll()
    }
    
    @IBAction func doDropTable(sender: UIButton) {
        SDS.drop_table()
    }
    */
    
}

