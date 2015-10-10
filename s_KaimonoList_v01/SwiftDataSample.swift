//
//  SwiftDataSample.swift
//  s_KaimonoList
//
//  Created by i.novol on 2015/06/21.
//  Copyright (c) 2015年 i.novol. All rights reserved.
//

import Foundation
import UIKit

class SwiftDataSample {
    
    // MARK: - コンストラクタ
    init(){
        if(!self.isExistsDataBase()){
            // 基本テーブルがなかったら作る
            let(_, _) = self.create_basic_tables();
        }
    }
    
    // MARK: - テーブルの存在確認
    func isExistsDataBase() ->Bool{
        let (tb, _) = SwiftData.existingTables();
        if(!tb.contains("kaimono_mst")){
            //  kaimono_mstがない
            return false;
        } else {
            return true;
        }
        
    }
    func drop_table() {
        SwiftData.deleteTable("kaimono_mst")
    }
    
    // MARK: - テーブルを作る
    func create_basic_tables() ->(Bool, String){
        
        let (tb, _) = SwiftData.existingTables();

        // kaimono_mstを作る
        if(!tb.contains("kaimono_mst")){
            if let err = SwiftData.createTable("kaimono_mst", withColumnNamesAndTypes:
                [
                    "hiduke" : .StringVal,
                    "kanjo" : .StringVal,
                    "kingaku" : .DoubleVal,
                    "receipt" : .StringVal,
                ])
            {
                // エラー発生
                print(SwiftData.errorMessageForCode(err));
                return(false, "error ocured in creating_kaimono_mst");
            }
        }

        return (true,"schema initialize succeeded");
    }
    
    // MARK: - kaimono_mst関数
    // insert
    func Add(
        hiduke : String,
        kanjo : String,
        kingaku : Int,
        receipt : String
        ) ->Bool{

        // sqlを準備
        let sql = "INSERT INTO kaimono_mst (hiduke, kanjo, kingaku, receipt) VALUES (?, ?, ?, ?)";
        
        // ?に入る変数をバインドして実行
        if let err = SwiftData.executeChange(
            sql,
            withArgs: [
                hiduke,
                kanjo,
                kingaku,
                receipt
            ]) {
            // エラーが発生した時の処理
            let msg = SwiftData.errorMessageForCode(err);
            print(msg, terminator: "")
            return false;
        } else {
            return true;
        }
    }
    
    // delete
    func delete(id:Int) -> Bool {
        if let _ = SD.executeChange("DELETE FROM kaimono_mst WHERE ID = ?", withArgs: [id]) {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            return true
        }
    }

    // deleteAll
    func deleteAll() -> Bool {
        if let _ = SD.executeChange("DELETE FROM kaimono_mst") {
            // there was an error during the insert, handle it here
            return false
        } else {
            // no error, the row was inserted successfully
            if let _ = SD.executeChange("delete from sqlite_sequence where name='kaimono_mst'") {
                // there was an error during the insert, handle it here
                return false
            } else {
                // no error, the row was inserted successfully
                return true
            }
        }
    }
    
    // selectAll
    func SelectAll() -> [(ID:Int, hiduke:String, kanjo:String, kingaku:Int, receipt : String)] {
        
        let sql = "SELECT ID, hiduke, kanjo, kingaku, receipt FROM kaimono_mst ORDER BY hiduke, kanjo, kingaku";
        var result:[(ID:Int, hiduke:String, kanjo:String, kingaku:Int, receipt : String)] = []
        
        let (resultSet, err) = SwiftData.executeQuery(sql);
        if err != nil {
            //there was an error during the query, handle it here
            let msg = SwiftData.errorMessageForCode(err!);
            print(msg)
            
        } else {
            if resultSet.count != 0 {
                for row in resultSet {

                    //  取得したリザルトセットからデータを抜き出して配列に追加していく
                    let id:Int? = row["ID"]?.asInt()
                    let hiduke:String? = row["hiduke"]?.asString()
                    let kanjo:String? = row["kanjo"]?.asString()
                    let kingaku:Int? = row["kingaku"]?.asInt()
                    let receipt:String? = row["receipt"]?.asString()
                    
                    result += [(
                        id!,
                        hiduke!,
                        kanjo!,
                        kingaku!,
                        receipt!
                        )]
                }
            }
        }
        return result;
    }
    
//    // SelectWhere
//    func SelectWhere(id:Int) -> [(ID:Int, hiduke:String, kanjo:String, kingaku:Int)] {
//        
//        var result:[(ID:Int, hiduke:String, kanjo:String, kingaku:Int)] = []
//        
//        // sqlを準備
//        let sql = "SELECT ID, hiduke, kanjo, kingaku FROM kaimono_mst WHERE ID = ? ORDER BY hiduke, kanjo, kingaku";
//        let (resultSet, err) = SD.executeQuery(sql, withArgs: [id]);
//
//        if err != nil {
//            //there was an error during the query, handle it here
//            var msg = SwiftData.errorMessageForCode(err!);
//            println(msg)
//            
//        } else {
//            if resultSet.count != 0 {
//                for row in resultSet {
//                    
//                    //  取得したリザルトセットからデータを抜き出して配列に追加していく
//                    var id:Int? = row["ID"]?.asInt()
//                    var hiduke:String? = row["hiduke"]?.asString()
//                    var kanjo:String? = row["kanjo"]?.asString()
//                    var kingaku:Int? = row["kingaku"]?.asInt()
//                    
//                    result += [(
//                        id!,
//                        hiduke!,
//                        kanjo!,
//                        kingaku!
//                    )]
//                }
//            }
//        }
//        return result;
//    }

    // selectkanjo
    func Selectkanjo() -> [String] {
        
        let sql = "SELECT kanjo FROM kaimono_mst GROUP BY kanjo ORDER BY kanjo";
        var result:[String] = []
        
        let (resultSet, err) = SwiftData.executeQuery(sql);
        if err != nil {
            //there was an error during the query, handle it here
            let msg = SwiftData.errorMessageForCode(err!);
            print(msg)
            
        } else {
            if resultSet.count != 0 {
                for row in resultSet {
                    
                    //  取得したリザルトセットからデータを抜き出して配列に追加していく
                    let kanjo:String? = row["kanjo"]?.asString()
                    
                    result += [
                        kanjo!
                    ]
                }
            }
        }
        return result;
    }

}