//
//  SelectCountryCode.swift
//  CallerID
//
//  Created by ERASOFT on 03/10/22.
//

import UIKit

class CountyCodeCell:UITableViewCell
{
    @IBOutlet var imgCountry: UIImageView!
    @IBOutlet var lblCountryName: UILabel!
    @IBOutlet var lblCountryCode: UILabel!
}

class SelectCountryCode: UIViewController {
    
    @IBOutlet var tblCountryCode: UITableView!
    @IBOutlet var txtSearchBar: UITextField!
    
    var arrCountryList:NSArray = []
    var filtterArrCountryList:NSArray = []// = [[String : Any]]()
    var objectCancel:objectCancel?
    var isSerching:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearchBar.delegate = self
        filtterArrCountryList = []
        self.fetchData()
    }
    
}
//MARK: - calling Functions & IBAction
extension SelectCountryCode
{
    @IBAction func btnBack(_ sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchData()
    {
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let Category = jsonResult["data"] as? [Any] {
                    self.arrCountryList = Category as? NSArray ?? []
                    self.tblCountryCode.reloadData()
                }
            } catch {
                // handle error
            }
        }
    }
    
    func FiltterData(strVal:String)
    {
        self.isSerching = true
        self.filtterArrCountryList = []
        let resultPredicate = NSPredicate(format: "name contains[c] %@", strVal)
        self.filtterArrCountryList = self.arrCountryList.filtered(using: resultPredicate) as NSArray
        self.tblCountryCode.reloadData()
    }
}

//MARK: - Calling TextField Delegate
extension SelectCountryCode:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText:String = self.txtSearchBar.text ?? "".trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText != ""
        {
            self.FiltterData(strVal: searchText)
        }
        else
        {
            self.isSerching = false
            self.filtterArrCountryList = []
            self.tblCountryCode.reloadData()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.isSerching = false
        self.filtterArrCountryList = []
        self.tblCountryCode.reloadData()
        
        return true
    }
  
}
//MARK: - calling Tableview Methods
extension SelectCountryCode:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if self.isSerching == true && self.filtterArrCountryList.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else if self.isSerching == false && self.arrCountryList.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSerching == true
        {
            return self.filtterArrCountryList.count
        }
        return self.arrCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountyCodeCell") as? CountyCodeCell else { return UITableViewCell()}
        
        if self.isSerching == true
        {
            if self.filtterArrCountryList.count > 0 && self.filtterArrCountryList.count > indexPath.row
            {
                let dic:NSDictionary = self.filtterArrCountryList[indexPath.item] as? NSDictionary ?? [:]
                let codeName = dic.value(forKey: "code") as? String ?? ""
                let imgName = NSString(format: "flag_%@",codeName.lowercased()) as String
                cell.imgCountry.image = UIImage(named: imgName) ?? UIImage()
                cell.lblCountryName.text = dic.value(forKey: "name") as? String ?? ""
                cell.lblCountryCode.text = NSString(format: "%@", dic.value(forKey: "dial_code") as? String ?? "") as String
            }
        }
        else
        {
            if self.arrCountryList.count > 0 && self.arrCountryList.count > indexPath.row
            {
                let dic:NSDictionary = self.arrCountryList[indexPath.item] as? NSDictionary ?? [:]
                let codeName = dic.value(forKey: "code") as? String ?? ""
                let imgName = NSString(format: "flag_%@",codeName.lowercased()) as String
                cell.imgCountry.image = UIImage(named: imgName) ?? UIImage()
                cell.lblCountryName.text = dic.value(forKey: "name") as? String ?? ""
                cell.lblCountryCode.text = NSString(format: "%@", dic.value(forKey: "dial_code") as? String ?? "") as String
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSerching == true
        {
            if self.filtterArrCountryList.count > 0 && self.filtterArrCountryList.count > indexPath.row
            {
                let dic:NSDictionary = self.filtterArrCountryList[indexPath.item] as? NSDictionary ?? [:]
                UserDefaults.standard.set(dic.value(forKey: "dial_code") as? String ?? "", forKey: "countryCode")
                UserDefaults.standard.set(dic.value(forKey: "code") as? String ?? "", forKey: "countryLocal")
                UserDefaults.standard.set(dic.value(forKey: "name") as? String ?? "", forKey: "countryName")
                objectCancel?()
            }
        }
        else
        {
            if self.arrCountryList.count > 0 && self.arrCountryList.count > indexPath.row
            {
                let dic:NSDictionary = self.arrCountryList[indexPath.item] as? NSDictionary ?? [:]
                UserDefaults.standard.set(dic.value(forKey: "dial_code") as? String ?? "", forKey: "countryCode")
                UserDefaults.standard.set(dic.value(forKey: "code") as? String ?? "", forKey: "countryLocal")
                UserDefaults.standard.set(dic.value(forKey: "name") as? String ?? "", forKey: "countryName")
                objectCancel?()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
