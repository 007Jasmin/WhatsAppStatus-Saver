//
//  contactModel.swift
//  Contact List
//
//  Created by JKSOL on 012/02/21.
//

import UIKit
import Foundation
import RealmSwift

enum MergeType:String
{
    case sameName = "sameName"
    case sameNumber  = "sameNumber"
    case dublicates  = "dublicates"
}
class contactModel: Object
{
    
    @objc dynamic var id: String = ""
    @objc dynamic var fullname : String = ""
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var company : String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var profile: Data = Data()
    var contactNumber: List<String> = List<String>()
    @objc dynamic var address: String = ""
    @objc dynamic var isfavourite: Bool = false
    @objc dynamic var isHistory: Bool = false
    @objc dynamic var loginType: Bool = false
    @objc dynamic var hasPhoneNumbers: Bool = false
    @objc dynamic var callDate: Date = Date()
    @objc dynamic var commonMergeHeader: String = ""
    dynamic var callDates: List<Date> = List<Date>()
    override static func primaryKey() -> String? {
        return "id"
    }
    
   
}

class accountModel: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var fullname : String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var profile: String = ""
    @objc dynamic var contactNumber: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var isActiveLogin: Bool = false
    @objc dynamic var loginType: Bool = false
    override static func primaryKey() -> String? {
        return "id"
    }
}



class GroupModel: Object
{
    
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    var Contacts = List<contactModel>()
    override static func primaryKey() -> String
    {
        return "id"
    }
    override init()
    {
    }
    init(name:String,id:String,contacts:[contactModel])
    {
       
        self.name = name;
        self.id = id;
        self.Contacts.append(objectsIn: contacts)
        //self.Songs = Songs
    }
    
    func addContacts(contact:[contactModel])
    {
        
        
       let realm = try! Realm()
        try! realm.write
        {
          
            for i in 0..<contact.count
         {
            
            print("cccc")
         if(!self.Contacts.contains(contact[i]))
         {

             
         self.Contacts.append(contact[i])
      
          }
         
         }
           
                       
       }
        
    }
    
    
}



class MergeContactsModel: Object
{
    @objc dynamic var SimilarityType: String = ""
    @objc dynamic var id = ""
    @objc dynamic var header = ""
    var Contacts = List<contactModel>()
    @objc dynamic var FinalcontactIndex: Int = 0
    override static func primaryKey() -> String
    {
        return "id"
    }
    override init()
    {
    }
  
    func addContacts(contact:[contactModel])
    {
        
        
       let realm = try! Realm()
        try! realm.write
        {
          
            for i in 0..<contact.count
         {
            
            print("cccc")
         if(!self.Contacts.contains(contact[i]))
         {

             
         self.Contacts.append(contact[i])
      
          }
         
         }
           
                       
       }
        
    }
    
    
}

