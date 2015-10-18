//
//  DescaleViewController.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/12.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit

class DescaleViewController:
UIViewController,
UITableViewDelegate,
UITableViewDataSource {

//    @IBOutlet weak var descelView: UIView!

    var num:[String] = []
//    var num:[String] = [
//        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
//        "ああああああああああああああああああああああああああああああああああああ",
//        "rfvlmvフォvj度k女dfjfp度kG；dflkg；dfkg；ldk；lds：；ls：d、flmgれ女pkc",
//        "フォjッフォjlgkmwkp＠fcmcs、m。おckぽjヴェmdlkjdlskんmd、アンdlkンォ絵sjflsmfvdjvls；kjファ；お家jファ；；cノアjfmsgぽr着mぽdsksgldmげ；rfd"
//    ]

    var jsonArray:NSArray = []
    
    var myApp = UIApplication.sharedApplication().delegate as! AppDelegate

    // Tableで使用する配列を設定する
    var myTableView: UITableView!

    @IBAction func doViewTable(sender: UIBarButtonItem) {
        if myTableView.hidden == false {
            myTableView.hidden = true
        } else {
            myTableView.hidden = false
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.

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
        

        // UserDefaultの設定
//        var myDefault = NSUserDefaults.standardUserDefaults()
  
        // AppDeleg
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 96, y: 100, width: 190, height: 200))
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.borderColor = UIColor.grayColor().CGColor
        myTableView.layer.borderWidth = 1.0
        myTableView.layer.cornerRadius = 8.0
        
        myTableView.estimatedRowHeight = 35
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
/*
        let a = [dat["gosu"] as! String]
        let hi = [dat["height"] as! Double]
        let wi = [dat["width"] as! Double]
        let desViewSize = self.descelView.bounds.size
*/
        
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
        let path = UIBezierPath()

//        print("centrer( \(self.descelView.center.x), \(self.descelView.center.y) )")
//        print("bounds( \(self.descelView.bounds.width), \(self.descelView.bounds.height) )")

        //中央縦
//        path.moveToPoint(CGPointMake(self.descelView.center.x, 0))
//        path.addLineToPoint(CGPointMake(self.descelView.center.x, self.descelView.bounds.height))
        path.moveToPoint(CGPointMake(self.view.center.x, 0))
        path.addLineToPoint(CGPointMake(self.view.center.x, self.view.bounds.height))

        //中央横
//        path.moveToPoint(CGPointMake(self.descelView.bounds.width, 0))
//        path.addLineToPoint(CGPointMake(self.descelView.bounds.width, self.descelView.center.y))
        path.moveToPoint(CGPointMake(0, self.view.center.y - 44))
        path.addLineToPoint(CGPointMake(self.view.bounds.width, self.view.center.y - 44))

        UIColor.orangeColor().setStroke()
        path.stroke()
        
//        self.descelView.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage
        self.view.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage
        UIGraphicsEndImageContext()
    
    }
        
//        /*
//        Cellが選択された際に呼び出されるデリゲートメソッド.
//        */
//        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            print("Num: \(indexPath.row)")
//            print("Value: \(num[indexPath.row])")
//            self.txtKanjo.text = num[indexPath.row]
//            myTableView.hidden = true
//        }
//        
//        /*
//        Cellの総数を返すデータソースメソッド.
//        (実装必須)
//        */
//        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return num.count
//        }
//        
//        /*
//        Cellに値を設定するデータソースメソッド.
//        (実装必須)
//        */
//        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//            
//            // 再利用するCellを取得する.
//            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
//            
//            // Cellに値を設定する.
//            cell.textLabel!.text = "\(num[indexPath.row])"
//            cell.textLabel?.font = UIFont.systemFontOfSize(12)
//            
//            return cell
//        }

}
