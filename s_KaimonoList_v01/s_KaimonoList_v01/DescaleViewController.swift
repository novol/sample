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

//    var num:[String] = []
    var num:[String] = [
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "ああああああああああああああああああああああああああああああああああああ",
        "rfvlmvフォvj度k女dfjfp度kG；dflkg；dfkg；ldk；lds：；ls：d、flmgれ女pkc",
        "フォjッフォjlgkmwkp＠fcmcs、m。おckぽjヴェmdlkjdlskんmd、アンdlkンォ絵sjflsmfvdjvls；kjファ；お家jファ；；cノアjfmsgぽr着mぽdsksgldmげ；rfd"
    ]
    var myApp = UIApplication.sharedApplication().delegate as! AppDelegate
    // Tableで使用する配列を設定する
    var myTableView: UITableView!

    @IBAction func doViewTable(sender: UIBarButtonItem) {
        myTableView.hidden = false
    }
    
    
    @IBOutlet weak var protpTable: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // UserDefaultの設定
//        var myDefault = NSUserDefaults.standardUserDefaults()
  
        // AppDeleg
        
        // protoTable
        self.protpTable.estimatedRowHeight = 60
        self.protpTable.rowHeight = UITableViewAutomaticDimension
        
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 96, y: 100, width: 190, height: 200))
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.borderColor = UIColor.grayColor().CGColor
        myTableView.layer.borderWidth = 1.0
        myTableView.layer.cornerRadius = 8.0
        
        myTableView.estimatedRowHeight = 50
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
