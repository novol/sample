//
//  desView.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/19.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit

class desView: UIView {

    var parHeight: CGFloat = 0.0
    var parWidth: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func drawRect(rect: CGRect) {
        
        if parWidth == 0 && parHeight == 0 {
        } else {
            
            let path = UIBezierPath()
            
            //中央縦
            path.moveToPoint(CGPointMake(self.center.x, 0))
            path.addLineToPoint(CGPointMake(self.center.x, self.bounds.height))
            
            //中央横
            path.moveToPoint(CGPointMake(0, self.center.y))
            path.addLineToPoint(CGPointMake(self.bounds.width, self.center.y))
            
            path.lineWidth = 0.5
            UIColor.blackColor().setStroke()
            path.stroke()

            //縦1/4左
            path.moveToPoint(CGPointMake(self.center.x - parWidth / 2 + parWidth / 4, 0))
            path.addLineToPoint(CGPointMake(self.center.x - parWidth / 2 + parWidth / 4, self.bounds.height))
            
            //縦1/4右
            path.moveToPoint(CGPointMake(self.center.x + parWidth / 4, 0))
            path.addLineToPoint(CGPointMake(self.center.x + parWidth / 4, self.bounds.height))

            //横1/4上
            path.moveToPoint(CGPointMake(0, self.center.y - parHeight / 2 + parHeight / 4))
            path.addLineToPoint(CGPointMake(self.bounds.width, self.center.y - parHeight / 2 + parHeight / 4))

            //横1/4下
            path.moveToPoint(CGPointMake(0, self.center.y + parHeight / 4))
            path.addLineToPoint(CGPointMake(self.bounds.width, self.center.y + parHeight / 4))

            path.lineWidth = 0.2
            UIColor.blackColor().setStroke()
            path.stroke()
            
            

            // 矩形
            let boxR = UIBezierPath(rect: CGRectMake(0, 0, self.center.x - parWidth / 2, self.bounds.height))
            let boxT = UIBezierPath(rect: CGRectMake(0, 0, self.bounds.width, self.center.y - parHeight / 2))
            let boxL = UIBezierPath(rect: CGRectMake(self.center.x + parWidth / 2, 0, self.center.x - parWidth / 2, self.bounds.height))
            let boxB = UIBezierPath(rect: CGRectMake(0, self.center.y + parHeight / 2, self.bounds.width, self.center.y - parHeight / 2))
            
            // stroke 色の設定
            UIColor.blackColor().setFill()
            
            //  中身の塗りつぶし
            boxR.fill()
            boxT.fill()
            boxL.fill()
            boxB.fill()

//            // 範囲テスト用 -------------------------------------
//            let rectangle = UIBezierPath(rect: CGRectMake(self.center.x - parWidth / 2, self.center.y - parHeight / 2, parWidth, parHeight))
//
//            // ライン幅
//            rectangle.lineWidth = 8
//
//            // stroke 色の設定
//            UIColor.blueColor().setStroke()
//            // 描画
//            rectangle.stroke()
            
        }
    }
    
    func setSize(height: CGFloat, width: CGFloat) {
        parHeight = height
        parWidth = width
    }
}
