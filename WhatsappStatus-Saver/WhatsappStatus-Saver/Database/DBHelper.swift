//
//  DBManager.swift
//  MusicDownloader
//
//  Created by Apple on 01/07/21.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = startDB()
        getTableList()
    }
    
    let dbPath: String = "codesDB.db"
    var db:OpaquePointer?
    var db1: OpaquePointer?
   
    
//    func openDatabase() -> OpaquePointer?
//    {
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent(dbPath)
//        var db: OpaquePointer? = nil
//
//        if sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK
//        {
//            print("error opening database")
//            return nil
//        }
//        else
//        {
//            print("Successfully opened connection to database at \(dbPath)")
//            return db
//        }
//    }
    
    func startDB()  -> OpaquePointer?
    {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        // see if db is in app support directory already
        if sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
            print("db ok",fileURL.path)
            return db
        }
        
        // clean up before proceeding
        sqlite3_close(db)
        db = nil
        
        // if not, get URL from bundle
        guard let bundleURL = Bundle.main.url(forResource: "codesDB", withExtension: "db") else {
            print("db not found in bundle",dbPath)
            return nil
        }
        
        // copy from bundle to app support directory
        do {
            try FileManager.default.copyItem(at: bundleURL, to: fileURL)
        } catch {
            print("unable to copy db", error.localizedDescription)
            return nil
        }
        
        // now open database again
        guard sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK else {
            print("error opening database",dbPath)
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        // report success
        print("db copied and opened ok",dbPath)
        return nil
    }
    
    func getTableList()
    {
        let queryStatementString = "SELECT * FROM sqlite_master;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
               print("call_history: ",String(describing: String(cString: sqlite3_column_text(queryStatement, 1))))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)

    }
    
    func getAreaCodeListByID(countryName:String) -> [AreaCodesModel]
    {
        let queryStatementString = "SELECT * FROM area WHERE countrylocale = '\(countryName)';"
        var queryStatement: OpaquePointer? = nil
        var psns : [AreaCodesModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let phonecode = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let countrylocale = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                psns.append(AreaCodesModel(id: Int(id), name: name,phonecode: phonecode, countrylocale: countrylocale))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
}


struct AreaCodesModel {
    var id : Int?
    var name : String?
    var phonecode : String?
    var countrylocale : String?
}
