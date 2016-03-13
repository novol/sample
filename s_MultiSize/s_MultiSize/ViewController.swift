//
//  ViewController.swift
//  s_MultiSize
//
//  Created by i.novol on 2016/03/09.
//
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

    var h:CGFloat = 0
    var w:CGFloat = 0
    var c:CGPoint = CGPointMake(0, 0)
    var viewAria: UIView!
    
    
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
    
    // 変数
    var descaleHight:Double = 0.0
    var descaleWidth:Double = 0.0
    var descaleColor:Bool = true
    var angle:CGFloat = 0.0
    var monoFlg:Bool = true
    var currentTransForm:CGAffineTransform!
    
    

    @IBOutlet weak var lblDispSize: UILabel!
    @IBOutlet weak var btnReDisp: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    @IBAction func doReDisp(sender: UIButton) {
        self.lblDispSize.text = "View Size(\(w), \(h))"
    }
    
    // MRK:- StatusBar非表示
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    
        // size調整
        h = ( self.view.bounds.height - self.toolBar.frame.height ) * 0.95
        w = ( self.view.bounds.width ) * 0.95
        c = self.view.center

        c.y = c.y - ( self.toolBar.frame.height ) / 2
        viewAria = UIView(frame: CGRectMake(0, 0, w, h))
        viewAria.center = c
        
        viewAria.backgroundColor = UIColor.yellowColor()
        viewAria.userInteractionEnabled = true
        
        // baseViewの追加
        self.view.addSubview(viewAria)

        
        // baseVieを最背面に移動
        self.view.sendSubviewToBack(viewAria)
        

        // toolBarを最前面に移動
        self.view.bringSubviewToFront(self.toolBar)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

