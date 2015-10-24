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
UITableViewDataSource,
UIGestureRecognizerDelegate
{

    @IBOutlet weak var toolbarDescale: UIToolbar!
    @IBOutlet weak var descleColoeBtn: UIBarButtonItem!

    var num:[String] = []
    var jsonArray:NSArray = []
    var myApp = UIApplication.sharedApplication().delegate as! AppDelegate

    // Tableで使用する配列を設定する
    var myTableView: UITableView!

    // Descaleの表示View
    var descaleView:desView!
    
    // Imageの表示View
    var imgView:UIView!

    var descaleHight:Double = 0.0
    var descaleWidth:Double = 0.0
    var descaleColor:Bool = true
    
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
        imgView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44 - 44))
        imgView.backgroundColor = UIColor.orangeColor()
        imgView.userInteractionEnabled = true

        // ジェスチャーの追加
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        tapGestureRecognizer.delegate = self
        self.imgView.addGestureRecognizer(tapGestureRecognizer)
        // Viewの追加
        self.view.addSubview(imgView)

        // imgViewの中にimageをaddSubViewする
        //
        //
        
        
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

    }
    
    func tapGesture(gestureRecognizer: UITapGestureRecognizer){
        
        if gestureRecognizer.view == self.view {
            print("Tap View")
        } else if gestureRecognizer.view == self.descaleView {
            print("Tap descaleView")
            // タップviewの色を変える (Red <=> Blue)
            if(descaleView.backgroundColor  == .redColor()) {
                descaleView.backgroundColor = .blueColor()
                print("tap blue")
            } else {
                descaleView.backgroundColor = .redColor()
                print("tap red")
            }
        } else if gestureRecognizer.view == self.myTableView {
            print("Tap descaleView")
        } else if gestureRecognizer.view == self.imgView {
            
            if self.myTableView.hidden != true {
                self.myTableView.hidden = true
            } else {
                print("Tap imgView \(gestureRecognizer.locationInView(self.imgView))")
                
                let tapCenter = gestureRecognizer.locationInView(descaleView)
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

//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        let touch = touches.anyObject()! as UITouch
//        let location = touch.locationInView(view)
//    }

}
