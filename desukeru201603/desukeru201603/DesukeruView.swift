//
//  desView.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/19.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit

class DesukeruView: UIView {

    var parHeight: CGFloat = 0.0
    var parWidth: CGFloat = 0.0
    var parTapArea: String = ""
    var parColor: Bool = true
    
    struct AreaFlg {
        var topRight: Bool
        var topLeft: Bool
        var downRight: Bool
        var downleft: Bool
    }
    var areaFlg = AreaFlg(topRight: false, topLeft: false, downRight: false, downleft: false)
    
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
            
            // MARK: - 中央線(縦横),1/4線(縦横)
            // 中央横
            path.moveToPoint(CGPointMake(0, self.center.y))
            path.addLineToPoint(CGPointMake(self.bounds.width, self.center.y))
            
            // 中央縦
            path.moveToPoint(CGPointMake(self.center.x, 0))
            path.addLineToPoint(CGPointMake(self.center.x, self.bounds.height))
            
            path.lineWidth = 0.5
            if parColor == true {
                UIColor.blackColor().setStroke()
            } else {
                UIColor.whiteColor().setStroke()
            }
            path.stroke()

            // 横1/4上
            path.moveToPoint(CGPointMake(0, self.center.y - parHeight * 1 / 4))
            path.addLineToPoint(CGPointMake(self.bounds.height, self.center.y - parHeight * 1 / 4))
            
            // 横1/4下
            path.moveToPoint(CGPointMake(0, self.center.y + parHeight * 1 / 4))
            path.addLineToPoint(CGPointMake(self.bounds.height, self.center.y + parHeight * 1 / 4))
            
            // 縦1/4左
            path.moveToPoint(CGPointMake(self.center.x - parWidth * 1 / 4 , 0))
            path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 4, self.bounds.height))
            
            // 縦1/4右
            path.moveToPoint(CGPointMake(self.center.x + parWidth * 1 / 4 , 0))
            path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 4, self.bounds.height))
            
            // MARK: - tap時1/8線(縦横)
            // FLGの反転
            if parTapArea == "TOP-RIGHT" {
                self.areaFlg.topRight = !self.areaFlg.topRight
                
            } else if parTapArea == "TOP-LEFT" {
                self.areaFlg.topLeft = !self.areaFlg.topLeft
                
            } else if parTapArea == "DOWN-RIGHT" {
                self.areaFlg.downRight = !self.areaFlg.downRight
            
            } else if parTapArea == "DOWN-LEFT" {
                self.areaFlg.downleft = !self.areaFlg.downleft
            
            } else {
            }

            if self.areaFlg.topRight == true {
                // 横1/8上
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  - parHeight * 1 / 8))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 2, self.center.y - parHeight * 1 / 8))
                
                // 横1/8下
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  - parHeight * 3 / 8))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 2, self.center.y - parHeight * 3 / 8))
                
                // 縦1/8右
                path.moveToPoint(CGPointMake(self.center.x + parWidth * 1 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 8, self.center.y - parHeight * 1 / 2))
                
                // 縦1/8左
                path.moveToPoint(CGPointMake(self.center.x + parWidth * 3 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 3 / 8, self.center.y - parHeight * 1 / 2))
            }

            if self.areaFlg.topLeft == true {
                // 横1/8上
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  - parHeight * 1 / 8))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 2, self.center.y - parHeight * 1 / 8))
                
                // 横1/8下
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  - parHeight * 3 / 8))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 2, self.center.y - parHeight * 3 / 8))
                
                // 縦1/8右
                path.moveToPoint(CGPointMake(self.center.x - parWidth * 1 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 8, self.center.y - parHeight * 1 / 2))
                
                // 縦1/8左
                path.moveToPoint(CGPointMake(self.center.x - parWidth * 3 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 3 / 8, self.center.y - parHeight * 1 / 2))
            }
            
            if self.areaFlg.downRight == true {
                // 横1/8上
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  + parHeight * 1 / 8))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 2, self.center.y + parHeight * 1 / 8))
                
                // 横1/8下
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  + parHeight * 3 / 8))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 2, self.center.y + parHeight * 3 / 8))
                
                // 縦1/8右
                path.moveToPoint(CGPointMake(self.center.x + parWidth * 1 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 1 / 8, self.center.y + parHeight * 1 / 2))
                
                // 縦1/8左
                path.moveToPoint(CGPointMake(self.center.x + parWidth * 3 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x + parWidth * 3 / 8, self.center.y + parHeight * 1 / 2))
            }
            
            if self.areaFlg.downleft == true {
                // 横1/8上
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  + parHeight * 1 / 8))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 2, self.center.y + parHeight * 1 / 8))
                
                // 横1/8下
                path.moveToPoint(CGPointMake(self.center.x, self.center.y  + parHeight * 3 / 8))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 2, self.center.y + parHeight * 3 / 8))
                
                // 縦1/8右
                path.moveToPoint(CGPointMake(self.center.x - parWidth * 1 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 1 / 8, self.center.y + parHeight * 1 / 2))
                
                // 縦1/8左
                path.moveToPoint(CGPointMake(self.center.x - parWidth * 3 / 8, self.center.y))
                path.addLineToPoint(CGPointMake(self.center.x - parWidth * 3 / 8, self.center.y + parHeight * 1 / 2))
            }
            
            path.lineWidth = 0.2

            if parColor == true {
                UIColor.blackColor().setStroke()
            } else {
                UIColor.whiteColor().setStroke()
            }
            path.stroke()

            // 矩形
            let boxR = UIBezierPath(rect: CGRectMake(0, 0, self.center.x - parWidth / 2, self.bounds.height))
            let boxT = UIBezierPath(rect: CGRectMake(0, 0, self.bounds.width, self.center.y - parHeight / 2))
            let boxL = UIBezierPath(rect: CGRectMake(self.center.x + parWidth / 2, 0, self.center.x - parWidth / 2, self.bounds.height))
            let boxB = UIBezierPath(rect: CGRectMake(0, self.center.y + parHeight / 2, self.bounds.width, self.center.y - parHeight / 2))
            
            // stroke 色の設定
            if parColor == true {
                UIColor.blackColor().setFill()
            } else {
                UIColor.whiteColor().setFill()
            }
            
            // 中身の塗りつぶし
            boxR.fill()
            boxT.fill()
            boxL.fill()
            boxB.fill()

        }
    }
    
    func setSize(height: CGFloat, width: CGFloat, tapArea: String) {

        let buff:CGFloat = 20.0
        
        if width == 0 && height == 0 {
            parHeight = 0
            parWidth = 0
        } else {
            // 縦固定・横サイズチェック
            let bestWidth = width * ( ( self.bounds.height - buff ) / height )
            // 横固定・縦サイズチェック
            let bestHeight = height * ( ( self.bounds.width - buff ) / width)
            
            if bestWidth <= self.bounds.width - buff {
                parHeight = self.bounds.height - buff
                parWidth = bestWidth
            } else if bestHeight <= self.bounds.height - buff {
                parHeight = bestHeight
                parWidth = self.bounds.width - buff
            } else {
                parHeight = 0
                parWidth = 0
            }
        }
        parTapArea = tapArea
    }

    func setColor(color: Bool) {
        parTapArea = ""
        parColor = color
    }

}
