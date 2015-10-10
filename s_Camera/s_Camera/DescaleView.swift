//
//  DescaleView.swift
//  s_Camera
//
//  Created by i.novol on 2015/05/20.
//  Copyright (c) 2015年 i.novol. All rights reserved.
//

import UIKit

class DescaleView: UIView {

    // デスケルのサイズ
    var desSize = CGPointMake(10, 10)

    // デスケルの表示切り替え
    var desDispFlg = false
    
    // デスケルの枠の白黒切り替え
    var desFrameColoe = UIColor.blackColor()
    
    // デスケルサイズの取得
    func selectDesSize(x:CGFloat, y:CGFloat) {
        desSize = CGPointMake(x, y)
    }
    
    override func drawRect(rect: CGRect) {
        
        let viewSize = self.frame
        let viewCenter = self.center
        
        print("desSize:\(desSize)")
        print("viewSize:\(viewSize)")
        print("viewCenter:\(viewCenter)")
        
        // 色の設定
        if desFrameColoe == UIColor.blackColor() {
            UIColor.blackColor().setStroke()
            UIColor.blackColor().setFill()
        } else {
            UIColor.whiteColor().setStroke()
            UIColor.whiteColor().setFill()
        }
        

        if desDispFlg == true {

            // UIBezierPath のインスタンス生成
            let line = UIBezierPath()
            
            // 4分割線 -------------------------------------
            // 縦中心線 From
            line.moveToPoint(CGPointMake(viewCenter.x,  0))
            
            // 縦中心線 To
            line.addLineToPoint(CGPointMake(viewCenter.x, viewSize.height))

            // 横中心線 From
            line.moveToPoint(CGPointMake(0, viewCenter.y))
            
            // 横中心線 To
            line.addLineToPoint(CGPointMake(viewSize.width, viewCenter.y))


            // 8分割線 -------------------------------------
            // ライン幅
            line.lineWidth = 0.4

            // 描画
            line.stroke()

            // 左縦線 From
            line.moveToPoint(CGPointMake(viewCenter.x - desSize.x / 4,  0))
            
            // 左縦線 To
            line.addLineToPoint(CGPointMake(viewCenter.x - desSize.x / 4, viewSize.height))
            
            // 右縦線 From
            line.moveToPoint(CGPointMake(viewCenter.x + desSize.x / 4,  0))
            
            // 右縦線 To
            line.addLineToPoint(CGPointMake(viewCenter.x + desSize.x / 4, viewSize.height))

            // 上横線 From
            line.moveToPoint(CGPointMake(0, viewCenter.y - desSize.y / 4))
            
            // 上横線 To
            line.addLineToPoint(CGPointMake(viewSize.width, viewCenter.y - desSize.y / 4))

            // 下横線 From
            line.moveToPoint(CGPointMake(0, viewCenter.y + desSize.y / 4))
            
            // 下横線 To
            line.addLineToPoint(CGPointMake(viewSize.width, viewCenter.y + desSize.y / 4))
            
            // ライン幅
            line.lineWidth = 0.2
            
            // 描画
            line.stroke()
            
            
            // 矩形 -------------------------------------
            let leftBox = UIBezierPath(rect: CGRectMake(
                0,
                0,
                ( viewSize.width - desSize.x ) / 2,
                viewSize.height))
            leftBox.fill()

            let rightBox = UIBezierPath(rect: CGRectMake(
                viewSize.width - (viewSize.width - desSize.x ) / 2,
                0,
                (viewSize.width - desSize.x ) / 2,
                viewSize.height))
            rightBox.fill()

            let topBox = UIBezierPath(rect: CGRectMake(
                0,
                0,
                viewSize.width,
                (viewSize.height - desSize.y) / 2))
            topBox.fill()

            let btmBox = UIBezierPath(rect: CGRectMake(
                0,
                viewSize.height - (viewSize.height - desSize.y ) / 2,
                viewSize.width,
                (viewSize.height - desSize.y ) / 2))
            btmBox.fill()
            
        } else {
            UIColor.clearColor().setFill()
            let clearBox = UIBezierPath(rect: CGRectMake(
                0,
                0,
                viewSize.width,
                viewSize.height))
            clearBox.strokeWithBlendMode(CGBlendMode.Clear, alpha: 0)
            clearBox.fill()

        }
    }
}
