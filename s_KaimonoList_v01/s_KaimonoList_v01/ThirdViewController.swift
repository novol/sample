//
//  ThirdViewController.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/08/08.
//  Copyright (c) 2015年 i.novol. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - 変数
    let SDS = SwiftDataSample()
    var currentCnt:Int = 0
    var result:[(ID:Int, hiduke:String, kanjo:String, kingaku:Int, receipt : String)] = []
    var num:[String] = []
    
    // NSUserDefaults のインスタンス取得
    let ud = NSUserDefaults.standardUserDefaults()
    
    // Tableで使用する配列を設定する
    private var myTableView: UITableView!

    // MARK: - @IBOutlet
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var txtHizuke: UITextField!
    @IBOutlet weak var txtKanjo: UITextField!
    @IBOutlet weak var txtKingaku: UITextField!
    @IBOutlet weak var imgReceipt: UIImageView!
    
    // MARK: - @IBAction
    @IBAction func doPrevious(sender: UIButton) {
        if currentCnt > 1 {
            currentCnt -= 1
            // resultのindex:1を表示
            setEntryValue(currentCnt)
        }
    }
    
    @IBAction func doNext(sender: UIButton) {
        if currentCnt < result.count  {
            currentCnt += 1
            // resultのindex:1を表示
            setEntryValue(currentCnt)
        }
    }
    
    @IBAction func tapCurrent(sender: UITapGestureRecognizer) {
        // Tableを非表示
        myTableView.hidden = false
    }
    
    @IBAction func doDelCurrent(sender: UIButton) {
        SDS.delete(result[currentCnt - 1].ID)
        print("Delete:id[\(result[currentCnt - 1].ID)]")

        result.removeAtIndex(currentCnt - 1)
        
        if result.count == 0 {
            currentCnt = 0
        } else {
            currentCnt = 1
        }
        setEntryValue(currentCnt)
    }
    
//    @IBAction func doTouchDown(sender: UITextField) {
//        // Tableを非表示
//        myTableView.hidden = false
//    }
//    
//    @IBAction func doHiddenTable(sender: UITextField) {
//        myTableView.hidden = true
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // SelectAllで返して配列のCNTで制御
        result = SDS.SelectAll()
        
        print("cnt:\(result.count)")
        
        if result.count == 0 {
            currentCnt = 0
        } else {
            currentCnt = 1
        }
        setEntryValue(currentCnt)
        
        // CurrentTable生成
        num = []
        if result.count != 0 {
            for i in 0 ... result.count - 1 {
                num += [String(i + 1)]
            }
            
            // TableViewの生成
            myTableView = UITableView(frame: CGRect(x: 120, y: 370, width: 82, height: 96))
            myTableView.backgroundColor = UIColor.whiteColor()
            myTableView.layer.borderColor = UIColor.grayColor().CGColor
            myTableView.layer.borderWidth = 1.0
            myTableView.layer.cornerRadius = 5.0
            
            myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            myTableView.dataSource = self
            myTableView.delegate = self
            myTableView.hidden = true
            self.view.addSubview(myTableView)
        }

    }
    
    //-------------------------------------------
    // MARK: - 入力値セット
    func setEntryValue(index:Int) {
        if index == 0 {
            // Current
            self.lblCurrent.text = "0 / 0"
            
            // 入力値
            self.txtHizuke.text = ""
            self.txtKanjo.text = ""
            self.txtKingaku.text = ""
            self.imgReceipt.image = nil
            
        } else {
            // Current
            self.lblCurrent.text = String(index) + "/ " + String(result.count)
            
            // 入力値
            let idx = index - 1
            self.txtHizuke.text = result[idx].hiduke
            self.txtKanjo.text = result[idx].kanjo
            if let kingaku = Int(String(result[idx].kingaku).stringByReplacingOccurrencesOfString(",", withString: "", options: [], range:nil)) {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                formatter.groupingSeparator = ","
                formatter.groupingSize = 3
                self.txtKingaku.text = formatter.stringFromNumber(kingaku)
            }

            
            // キーを指定してオブジェクトを読み込み
            let imgStr  = ud.objectForKey(result[idx].receipt) as! String  // => "Swift Taro"
            let img = String2Image(imgStr)
            
            self.imgReceipt.image = img
            
            if img!.imageOrientation == UIImageOrientation.Up {
                print("View:Up")
            } else if img!.imageOrientation == UIImageOrientation.Down {
                print("View:Down")
            } else if img!.imageOrientation == UIImageOrientation.Right {
                print("View:Right")
            } else if img!.imageOrientation == UIImageOrientation.Left {
                print("View:Left")
            } else {
                print("View:OTHER")
            }

            //            var imgStr = result[idx].receipt
//            self.imgReceipt.image = String2Image(imgStr)
//            if let mgStr = result[idx].receipt {
//                var img = Image2String(imgStr)
//                self.imgReceipt.image = img
//            } else {
//                self.imgReceipt.image = nil
//            }
            
        }
    }

    //-----------------------------------
    // MARK: - TableViewのハンドラ
    /*
    Cellが選択された際に呼び出されるデリゲートメソッド.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.lblCurrent.text = num[indexPath.row] + "/ " + String(result.count)
        currentCnt = Int(num[indexPath.row])!
        setEntryValue(currentCnt)

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
        cell.textLabel?.font = UIFont.systemFontOfSize(11)
        
        return cell
    }

    //StringをUIImageに変換する
    func String2Image(imageString:String) -> UIImage?{
        
        //空白を+に変換する
        let base64String = imageString.stringByReplacingOccurrencesOfString(" ", withString:"+",options: [], range:nil)
        
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:NSData? =
        NSData(base64EncodedString:base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess)
            
            //結果を返却
            return img
        }
        
        return nil
        
    }

    func adjustImageRotation(baseImage: UIImage) -> UIImage {
        
        var editImage = baseImage
        if baseImage.imageOrientation != UIImageOrientation.Right {
            let cgImage = CGImageCreateWithImageInRect(baseImage.CGImage, CGRectMake(0, 0, baseImage.size.width, baseImage.size.height))
            editImage = UIImage(CGImage: cgImage!, scale: baseImage.scale, orientation: UIImageOrientation.Right)
        }
        return editImage
    }

}




















