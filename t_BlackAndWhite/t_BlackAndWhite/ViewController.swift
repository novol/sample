//
//  ViewController.swift
//  t_BlackAndWhite
//
//  Created by i.novol on 2016/02/11.
//  Copyright © 2016年 白黒変換. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBAction func doPan(sender: UIPanGestureRecognizer) {

        let translation = sender.translationInView(self.view)
        var center =  self.myImageView.center
        let  frameView = self.view.frame;

        //centerがviewの内側であること
        if (translation.x + center.x < 0) {
            sender.setTranslation(CGPointZero, inView: self.view)
            return;
        }
        if (translation.y + center.y < 0) {
            sender.setTranslation(CGPointZero, inView: self.view)
            return;
        }
        if (translation.x + center.x > frameView.size.width) {
            sender.setTranslation(CGPointZero, inView: self.view)
            return;
        }
        if (translation.y + center.y > frameView.size.height) {
            sender.setTranslation(CGPointZero, inView: self.view)
            return;
        }

        center.x = center.x + translation.x;
        center.y = center.y + translation.y;

        self.myImageView.center = center;
        sender.setTranslation(CGPointZero, inView: self.view)

//        CGPoint translation = [sender translationInView:self.view];
//        CGPoint center = self.viewMotif.center;
//        CGRect frameView = self.view.frame;
//        
//        //centerがviewの内側であること
//        if (translation.x + center.x < 0) {
//            [sender setTranslation:CGPointZero inView:self.view];
//            return;
//        }
//        if (translation.y + center.y < 0) {
//            [sender setTranslation:CGPointZero inView:self.view];
//            return;
//        }
//        if (translation.x + center.x > frameView.size.width) {
//            [sender setTranslation:CGPointZero inView:self.view];
//            return;
//        }
//        if (translation.y + center.y > frameView.size.height) {
//            [sender setTranslation:CGPointZero inView:self.view];
//            return;
//        }
//        
//        printf("t x:%f,y;%f",translation.x,translation.y);
//        
//        center.x = center.x + translation.x;
//        center.y = center.y + translation.y;
//        
//        self.viewMotif.center = center;
//        [sender setTranslation:CGPointZero inView:self.view];

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // ベース画像.
    var myInputImage: CIImage!
    
    // ImageView.
    var myImageView: UIImageView!
    var myOutputImage: CIImage!
    
    // ボタン.
    let myButton: UIButton = UIButton()
    let myButton2: UIButton = UIButton()
    
    var x:Int = 1;
    var y:Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImageViewの生成.
//        myInputImage = CIImage(image: UIImage(named: "images.jpeg")!)
//        let mySize = UIImage(CIImage: myInputImage!)
//        myImageView = UIImageView(frame: CGRectMake(0, 0, mySize.size.width + 100, mySize.size.height + 300 ))
//        myImageView.image = mySize
        
        //UIImageViewの生成
        myInputImage = CIImage(image: UIImage(named: "images.jpeg")!)
        myImageView = UIImageView(image: UIImage(CIImage: myInputImage))
        //UIImageViewのサイズを自動的にimageのサイズに合わせる
        myImageView.contentMode = UIViewContentMode.Center
        self.view.addSubview(myImageView)
        
//        //UIImageViewの生成
//        let imageView = UIImageView(image: UIImage(named: "uiImageView.png"))
//        //UIImageViewのサイズを自動的にimageのサイズに合わせる
//        imageView.contentMode = UIViewContentMode.Center
//        self.view.addSubview(imageView)

        
        print("myImageView.bounds.size:\(myImageView.bounds.size)")
        print("myImageView.image?.size:\(myImageView.image?.size)")
        
        x = 1
        myImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        // カラーエフェクトを指定してCIFilterをインスタンス化.
        let myMonochromeFilter = CIFilter(name: "CIColorMonochrome")
        
        // イメージのセット.
        myMonochromeFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
        
        // モノクロ化するための値の調整.
        myMonochromeFilter!.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: kCIInputColorKey)
        myMonochromeFilter!.setValue(1.0, forKey: kCIInputIntensityKey)
        
        // フィルターを通した画像をアウトプット.
        myOutputImage = myMonochromeFilter!.outputImage!
        
        myImageView.backgroundColor = UIColor.whiteColor()
        myImageView.layer.borderColor = UIColor.grayColor().CGColor
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.cornerRadius = 8.0

        self.view.addSubview(myImageView)
        
//        //UIImageViewの生成
//        let imageView = UIImageView(image: UIImage(named: "images.jpeg"))
//        //UIImageViewのサイズを自動的にimageのサイズに合わせる
//        imageView.contentMode = UIViewContentMode.Center
//        self.view.addSubview(imageView)

        
        
        // ボタン.
        myButton.frame = CGRectMake(0,0,80,80)
        myButton.backgroundColor = UIColor.blackColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("モノクロ化", forState: UIControlState.Normal)
        myButton.titleLabel?.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.layer.cornerRadius = 40.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height - 50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton);

        
        // ボタン.
        myButton2.frame = CGRectMake(0,0,80,80)
        myButton2.backgroundColor = UIColor.blackColor();
        myButton2.layer.masksToBounds = true
//        myButton2.setTitle("contentMode", forState: UIControlState.Normal)
        myButton2.setTitle("rotate", forState: UIControlState.Normal)
        myButton2.titleLabel?.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        myButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton2.layer.cornerRadius = 40.0
        myButton2.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height - 100)
//        myButton2.addTarget(self, action: "onClickContentMode:", forControlEvents: .TouchUpInside)
        myButton2.addTarget(self, action: "onClickRotete:", forControlEvents: .TouchUpInside)

        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton2);
        
        // 背景色を黒.
        self.view.backgroundColor = UIColor.blackColor()
        
    }
    
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        
//        // カラーエフェクトを指定してCIFilterをインスタンス化.
//        let myMonochromeFilter = CIFilter(name: "CIColorMonochrome")
//        
//        // イメージのセット.
//        myMonochromeFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
//        
//        // ものくろ化するための値の調整.
//        myMonochromeFilter!.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: kCIInputColorKey)
//        myMonochromeFilter!.setValue(1.0, forKey: kCIInputIntensityKey)
//        
//        // フィルターを通した画像をアウトプット.
//        let myOutputImage : CIImage = myMonochromeFilter!.outputImage!
        
        // 再びUIViewにセット.
        if (y == 1) {
            myImageView.image = UIImage(CIImage: myOutputImage)
        } else {
            myImageView.image = UIImage(CIImage: myInputImage!)
        }
        y = y * -1
        print("y=\(y)")
        
        // 再描画.
        myImageView.setNeedsDisplay()
        
    }
    
    func onClickContentMode(sender: UIButton) {

        x = ( x + 1 ) % 3
        if ( x == 1 ) {
            myImageView.contentMode = UIViewContentMode.Center
        
        } else if ( x == 2 ) {
            myImageView.contentMode = UIViewContentMode.ScaleAspectFill
            
        } else {
            myImageView.contentMode = UIViewContentMode.ScaleAspectFit

        }
        
        self.myImageView.setNeedsDisplay()
        print("x:\(x)")

        
    }
    
    func onClickRotete(sender: UIButton) {
        self.myImageView.transform = CGAffineTransformRotate(self.myImageView.transform, CGFloat(M_PI / 2.0))

    }
}
