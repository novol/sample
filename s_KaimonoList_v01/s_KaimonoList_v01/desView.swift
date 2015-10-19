//
//  desView.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/19.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit

class desView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var sizeFlg: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func drawRect(rect: CGRect) {
        
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
        
        
        if sizeFlg == 0 {
            // 起点
            line.moveToPoint(CGPointMake(250, 50));
            
            // 帰着点
            line.addLineToPoint(CGPointMake(20,350));

            // 色の設定
            UIColor.redColor().setStroke()
            
            // ライン幅
            line.lineWidth = 2

        } else if sizeFlg == 1 {
            // 起点
            line.moveToPoint(CGPointMake(50, 50));
            
            // 帰着点
            line.addLineToPoint(CGPointMake(220,350));

            // 色の設定
                UIColor.yellowColor().setStroke()
                
                // ライン幅
                line.lineWidth = 10
        } else {
            // 起点
            line.moveToPoint(CGPointMake(111, 32));
            
            // 帰着点
            line.addLineToPoint(CGPointMake(32,433));

            // 色の設定
            UIColor.blackColor().setStroke()
            
            // ライン幅
            line.lineWidth = 5
        }
        
        // 描画
        line.stroke();
        
    }
    
    func setSize(flg: Int) {
        sizeFlg = flg
    }
}
