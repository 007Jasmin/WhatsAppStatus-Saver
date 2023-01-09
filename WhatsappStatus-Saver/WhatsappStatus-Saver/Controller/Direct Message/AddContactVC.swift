//
//  AddContactVC.swift
//  Contact List
//
//  Created by JKSOL on 18/02/21.
//

import UIKit
import ContactsUI
import RealmSwift
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialDialogs_Theming
import MaterialComponents.MaterialContainerScheme
import GoogleMobileAds
import SDWebImage

class AddContactVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btnmore: UIButton!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var txtfirstname: UITextField!
    @IBOutlet weak var txtlastname: UITextField!
    @IBOutlet weak var txtcompany: UITextField!
    @IBOutlet weak var txtphone: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var imgcurrentlogin: UIImageView!
    @IBOutlet weak var lblsavename: UILabel!
    @IBOutlet weak var btndevice: UIButton!
    @IBOutlet weak var nativeAdPlaceholder: GADNativeAdView!
    @IBOutlet weak var callToActionView: UIButton!
    @IBOutlet weak var ad_icon: UIImageView!
    @IBOutlet weak var ad_title: UILabel!
    @IBOutlet weak var ad_description: UILabel!
    @IBOutlet var constNativeAdsView:NSLayoutConstraint!
    
    var callback: ((_ id: Bool) -> Void)?
    var callbackObj: ((_ id: contactModel) -> Void)?
    var ContactObj = contactModel()
    var realm = try! Realm()
    var isEditMode = false
    var selectedImage : UIImage!
    var adLoader: GADAdLoader!
    var arrNativeAds:GADNativeAd?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(onImageTapAction(gesture:)))
//        self.imgprofile.addGestureRecognizer(tapgesture)
//        self.imgprofile.isUserInteractionEnabled = true
        
        self.txtphone.delegate = self
        self.txtemail.delegate = self
        self.txtcompany.delegate = self
        self.txtlastname.delegate = self
        self.txtfirstname.delegate = self
        
        self.txtphone.text = ContactObj.contactNumber.first ?? ""
        self.txtemail.text = ContactObj.email
        self.txtcompany.text = ContactObj.company
        self.txtfirstname.text = ContactObj.firstName
        self.txtlastname.text = ContactObj.lastName
        imagePicker.delegate = self
        if let img = UIImage.init(data: ContactObj.profile){
            self.selectedImage = img
            self.imgprofile.image = img
        }else{
            self.imgprofile.image = UIImage.init(named: "ic_user_profile")
        }
        
        if self.isEditMode{
            self.lbltitle.text = "Update Contact"
            self.btnsave.setTitle("Update", for: .normal)
        }else{
            self.lbltitle.text = "Create Contact"
            self.btnsave.setTitle("Save", for: .normal)
        }
        
        if let activeaccountArr = Array(realm.objects(accountModel.self).filter({ $0.isActiveLogin == true })).first
        {
            
            if activeaccountArr.profile != ""
            {
                self.imgcurrentlogin.sd_setImage(with: URL.init(string: activeaccountArr.profile), placeholderImage: UIImage.init(named: "icn_user"))
                self.lblsavename.text = activeaccountArr.fullname
            }
            else{
                self.imgcurrentlogin.image = UIImage.init(named: "icon_device")
                self.lblsavename.text = "Device"
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        constNativeAdsView.constant = 0
        if AdsManager.shared.arrNativeAds.count > 0
                {
                    self.arrNativeAds = AdsManager.shared.arrNativeAds[0]
                    self.loadNativeAds()
                }
    }
    
    func loadNativeAds()
    {
            constNativeAdsView.constant = 0
            
            self.ad_title.text = arrNativeAds?.headline
            self.ad_description.text = "\(arrNativeAds?.body ?? "")"
            
            self.callToActionView.setTitle(arrNativeAds?.callToAction, for: .normal)
            self.nativeAdPlaceholder.isUserInteractionEnabled = false
            
            self.nativeAdPlaceholder.callToActionView = self.callToActionView
            self.nativeAdPlaceholder.iconView = self.ad_icon
            self.nativeAdPlaceholder.headlineView = self.ad_title
            //        self.nativeAdPlaceholder.bodyView = self.ad_description
            (self.nativeAdPlaceholder.bodyView as? UILabel)?.text = "\(arrNativeAds?.body ?? "")"
            
            self.ad_icon.image = arrNativeAds?.icon?.image
            self.ad_icon.isHidden = arrNativeAds?.icon == nil
            
            self.nativeAdPlaceholder.nativeAd = arrNativeAds
            constNativeAdsView.constant = 125
        }
    
    @IBAction func onImageTapAction(_ sender:UIButton){
//        let vc = TLPhotosPickerViewController()
//        var configure = TLPhotosPickerConfigure()
//        configure.allowedVideo = false
//
//        configure.allowedVideoRecording = false
//        vc.configure = configure
//        vc.delegate = self
//        self.present(vc, animated: true, completion: nil)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            /*If you want work actionsheet on ipad
            then you have to use popoverPresentationController to present the actionsheet,
            otherwise app will crash on iPad */
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.sourceView = sender
                alert.popoverPresentationController?.sourceRect = sender.bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
            
            self.present(alert, animated: true, completion: nil)
    }
  
    @IBAction func onBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imgprofile.image = editedImage
            self.selectedImage = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveAction(_ sender: UIButton) {
        if(self.validateAllField())
        {
            
            
            let indicator = UIActivityIndicatorView.init(style: .gray)
            sender.addSubview(indicator)
            indicator.center = sender.center
            indicator.startAnimating()
            sender.setTitle("", for: .normal)
            
            if !self.isEditMode{
                let store = CNContactStore()
                let contact = CNMutableContact()
                
                // Name
                contact.givenName = txtfirstname.text ?? ""
                contact.familyName = txtlastname.text ?? ""
                
                // Phone
                contact.phoneNumbers.append(CNLabeledValue(label: "mobile", value: CNPhoneNumber(stringValue: txtphone.text ?? "")))
                
                // Image
                if self.selectedImage != nil{
                    let image = self.imgprofile.image!
                    let size = image.getSizeIn(.megabyte)
                    if size > 12.0{
                        let newimage = image.jpegData(.medium)
                        contact.imageData = newimage
                    }else{
                        contact.imageData = image.jpegData(.highest)
                    }
                }
                
                // Email
                contact.emailAddresses.append((CNLabeledValue(label: "home", value: (txtemail.text ?? "") as NSString)))
                
                //Company
                contact.organizationName = self.txtcompany.text ?? ""
                
                // Save
                do{
                    
                    let saveRequest = CNSaveRequest()
                    saveRequest.add(contact, toContainerWithIdentifier: nil)
                    try store.execute(saveRequest)
                    
                    indicator.stopAnimating()
                    let scheme = MDCContainerScheme()
                    let alertController = MDCAlertController(title: "Message", message: "Contact saved successfully!")
                    let action = MDCAlertAction(title:"OK") { (action) in
                        self.dismiss(animated: true) {
                            
                            let contactId = contact.identifier
                            let name = contact.isKeyAvailable(CNContactGivenNameKey) ? contact.givenName : ""
                            let lName = contact.isKeyAvailable(CNContactFamilyNameKey) ? contact.familyName : ""
                            var fullName = ""
                            if name.isEmpty == false && lName.isEmpty == false {
                                fullName = "\(name) \(lName)"
                            }
                            else if name.isEmpty == false && lName.isEmpty == true {
                                fullName = name
                            }
                            else if name.isEmpty == true && lName.isEmpty == false {
                                fullName = lName
                            }
                            else {
                                fullName = ""
                            }
                            
                            //Company
                            let company = contact.organizationName
                            
                            // image
                            let image = (contact.isKeyAvailable(CNContactImageDataKey) && contact.imageDataAvailable) ? contact.imageData ?? nil : nil
                            var strImage = Data()
                            
                            if image != nil{
                                strImage = image!
                            }
                            
                            // email
                            var email = contact.isKeyAvailable(CNContactEmailAddressesKey) ? contact.emailAddresses.first?.value : nil
                            if email == nil {
                                email = ""
                            }
                            
                            // phone
                            if contact.isKeyAvailable(CNContactPhoneNumbersKey) {
                                var numberArr = [String]()
                                for possiblePhone in contact.phoneNumbers {
                                    let orignalNumber = possiblePhone.value.stringValue
                                    numberArr.append(orignalNumber)
                                }
                                
                                if numberArr.count !=  0 && fullName.count != 0 {
                                    try! self.realm.write{
                                        self.ContactObj = contactModel()
                                        self.ContactObj.id = contactId
                                        self.ContactObj.fullname = fullName
                                        for noobj in numberArr{
                                            self.ContactObj.contactNumber.append(noobj)
                                        }
                                        self.ContactObj.email = email! as String
                                        self.ContactObj.profile = strImage
                                        self.ContactObj.isfavourite = false
                                        self.ContactObj.loginType = false
                                        self.ContactObj.firstName = name
                                        self.ContactObj.lastName = lName
                                        self.ContactObj.company = company
                                        
                                        self.realm.add(self.ContactObj)
                                        
                                        self.callback?(true)
                                    }
                                }
                            }
                            
                        }
                    }
                    alertController.addAction(action)
                    alertController.applyTheme(withScheme: scheme)
                    present(alertController, animated:true, completion: nil)
                    
                }catch (let error){
                    let scheme = MDCContainerScheme()
                    let alertController = MDCAlertController(title: "Alert", message: error.localizedDescription)
                    let action = MDCAlertAction(title:"OK") { (action) in
                        
                    }
                    alertController.addAction(action)
                    alertController.applyTheme(withScheme: scheme)
                    present(alertController, animated:true, completion: nil)
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    
                    if self.isEditMode{
                        self.btnsave.setTitle("Update", for: .normal)
                    }else{
                        self.btnsave.setTitle("Save", for: .normal)
                    }
                }
            }else{
                let predicate = CNContact.predicateForContacts(withIdentifiers: [ContactObj.id])
                let toFetch = [CNContactIdentifierKey as CNKeyDescriptor]
                let store = CNContactStore()
                do{
                    let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: toFetch)
                    guard contacts.count > 0 else{
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                        
                        if self.isEditMode{
                            self.btnsave.setTitle("Update", for: .normal)
                        }else{
                            self.btnsave.setTitle("Save", for: .normal)
                        }
                        
                        print("No contacts found")
                        return
                    }
                    guard let contact = contacts.first else{
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                        
                        if self.isEditMode{
                            self.btnsave.setTitle("Update", for: .normal)
                        }else{
                            self.btnsave.setTitle("Save", for: .normal)
                        }
                        
                        return
                    }
                    let req = CNSaveRequest()
                    let mutableContact = contact.mutableCopy() as! CNMutableContact
                    req.delete(mutableContact)
                    do{
                        try store.execute(req)
                        // Save
                        do{
                            
                            let storeNew = CNContactStore()
                            
                            let contactNew = CNMutableContact()
                            
                            // Name
                            contactNew.givenName = txtfirstname.text ?? ""
                            contactNew.familyName = txtlastname.text ?? ""
                            
                            // Phone
                            contactNew.phoneNumbers.append(CNLabeledValue(label: "mobile", value: CNPhoneNumber(stringValue: txtphone.text ?? "")))
                            
                            // Image
//                            if self.selectedImage != nil{
//                                let image = self.imgprofile.image!
//                                let size = image.getSizeIn(.megabyte)
//                                if size > 12.0{
//                                    let newimage = image.jpegData(.medium)
//                                    contactNew.imageData = newimage
//                                }else{
//                                    contactNew.imageData = image.jpegData(.highest)
//                                }
//                            }
                            let image = self.imgprofile.image!
                            let newimage = image.jpegData(.medium)
                            contactNew.imageData = newimage
                            // Email
                            contactNew.emailAddresses.append((CNLabeledValue(label: "home", value: (txtemail.text ?? "") as NSString)))
                            
                            //Company
                            contactNew.organizationName = self.txtcompany.text ?? ""
                            
                            let saveRequestNew = CNSaveRequest()
                            saveRequestNew.add(contactNew, toContainerWithIdentifier: nil)
                            try storeNew.execute(saveRequestNew)
                            
                            indicator.stopAnimating()
                            let scheme = MDCContainerScheme()
                            let alertController = MDCAlertController(title: "Message", message: "Contact Update successfully!")
                            let action = MDCAlertAction(title:"OK") { (action) in
                                self.dismiss(animated: true) {
                                    
                                    let contactId = contactNew.identifier
                                    let name = contactNew.isKeyAvailable(CNContactGivenNameKey) ? contactNew.givenName : ""
                                    let lName = contactNew.isKeyAvailable(CNContactFamilyNameKey) ? contactNew.familyName : ""
                                    var fullName = ""
                                    if name.isEmpty == false && lName.isEmpty == false {
                                        fullName = "\(name) \(lName)"
                                    }
                                    else if name.isEmpty == false && lName.isEmpty == true {
                                        fullName = name
                                    }
                                    else if name.isEmpty == true && lName.isEmpty == false {
                                        fullName = lName
                                    }
                                    else {
                                        fullName = ""
                                    }
                                    
                                    //Company
                                    let company = contactNew.organizationName
                                    
                                    // image
                                    let image = (contactNew.isKeyAvailable(CNContactImageDataKey) && contactNew.imageDataAvailable) ? contactNew.imageData ?? nil : nil
                                    var strImage = Data()
                                    
                                    if image != nil{
                                        strImage = image!
                                    }
                                    
                                    // email
                                    var email = contactNew.isKeyAvailable(CNContactEmailAddressesKey) ? contactNew.emailAddresses.first?.value : nil
                                    if email == nil {
                                        email = ""
                                    }
                                    
                                    // phone
                                    if contactNew.isKeyAvailable(CNContactPhoneNumbersKey) {
                                        var numberArr = [String]()
                                        for possiblePhone in contactNew.phoneNumbers {
                                            let orignalNumber = possiblePhone.value.stringValue
                                            numberArr.append(orignalNumber)
                                        }
                                        
                                        if numberArr.count !=  0 && fullName.count != 0 {
                                            try! self.realm.write{
                                                
                                                let isfav = self.ContactObj.isfavourite
                                                let ishistory = self.ContactObj.isHistory
                                                
                                                self.realm.delete(self.ContactObj)
                                                
                                                let ContactObjNew = contactModel()
                                                ContactObjNew.id = contactId
                                                ContactObjNew.fullname = fullName
                                                for noobj in numberArr{
                                                    ContactObjNew.contactNumber.append(noobj)
                                                }
                                                ContactObjNew.email = email! as String
                                                ContactObjNew.profile = strImage
                                                ContactObjNew.isfavourite = isfav
                                                ContactObjNew.isHistory = ishistory
                                                ContactObjNew.loginType = false
                                                ContactObjNew.firstName = name
                                                ContactObjNew.lastName = lName
                                                ContactObjNew.company = company
                                                
                                                self.realm.add(ContactObjNew)
                                                
                                                self.callbackObj?(ContactObjNew)
                                            }
                                        }
                                    }
                                }
                            }
                            alertController.addAction(action)
                            alertController.applyTheme(withScheme: scheme)
                            present(alertController, animated:true, completion: nil)
                        }catch let e{
                            indicator.stopAnimating()
                            indicator.removeFromSuperview()
                            
                            if self.isEditMode{
                                self.btnsave.setTitle("Update", for: .normal)
                            }else{
                                self.btnsave.setTitle("Save", for: .normal)
                            }
                            
                            print("Error2 = \(e)")
                        }
                        
                    } catch let e{
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                        
                        if self.isEditMode{
                            self.btnsave.setTitle("Update", for: .normal)
                        }else{
                            self.btnsave.setTitle("Save", for: .normal)
                        }
                        
                        print("Error1 = \(e)")
                    }
                } catch let err
                {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    
                    if self.isEditMode{
                        self.btnsave.setTitle("Update", for: .normal)
                    }else{
                        self.btnsave.setTitle("Save", for: .normal)
                    }
                    
                    print("Error = \(err)")
                }
            }
        }
    }
    func validateAllField() -> Bool
    {
        let isValidFirstName = self.isValidName(name: self.txtfirstname.text!)
        let isValidLastName = self.isValidName(name: self.txtlastname.text!)
        let isValidCompanyName = self.isValidName(name: self.txtcompany.text!)
        let isValidEmail = self.isValidEmail(email: self.txtemail.text!)
        let isValidPhoneNumber = self.isValidEmpty(name: self.txtphone.text!)
        
        if(isValidFirstName || isValidLastName || isValidCompanyName || isValidEmail || isValidPhoneNumber)
        {
            return true;
        }
        else
        {
            BasicMethod.showToast(message: "Please enter at least one field.")
            return false;
        }
        
    }
    @IBAction func onMoreAction(_ sender: UIButton) {
        
    }
    
    @IBAction func onCurrentDevice(_ sender: UIButton) {
        
    }
    //MARK: - extension
    
    //MARK: - Open the camera
      func openCamera(){
          if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
              imagePicker.sourceType = UIImagePickerController.SourceType.camera
              //If you dont want to edit the photo then you can set allowsEditing to false
              imagePicker.allowsEditing = true
              imagePicker.delegate = self
              self.present(imagePicker, animated: true, completion: nil)
          }
          else{
              let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      }
      
      //MARK: - Choose image from camera roll
      
      func openGallary(){
          imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
          //If you dont want to edit the photo then you can set allowsEditing to false
          imagePicker.allowsEditing = true
          imagePicker.delegate = self
          self.present(imagePicker, animated: true, completion: nil)
      }
    
    func ValidatePasswordWithConfirmPassword(pass:String,ConfirmPass:String) -> Bool
    {
        if(pass == ConfirmPass)
        {
            return true
        }
        return false
    }
    
    func isValidName(name: String) -> Bool
    {
        if name.count != 0{
            for chr in name {
                if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == ",")) {
                    return false
                }
            }
            return true
        }
        else{
            return false
        }
        
    }
    func isValidEmpty(name: String) -> Bool
    {
        if name.count != 0{
            
            return true
        }
        else{
            return false
        }
        
    }
    func isValidPassword(password: String) -> Bool{
        var iscapital = Bool()
        var islower = Bool()
        var isspecial = Bool()
        if password.count >= 8 {
            for chr in password{
                if (chr >= "A" && chr <= "Z"){
                    iscapital = true
                }
                if (chr >= "a" && chr <= "z"){
                    islower = true
                }
                if ((chr == "!") || (chr == "@") || (chr == "#") || (chr == "$") || (chr == "%") || (chr == "&") || (chr == "*")){
                    isspecial = true
                }
            }
            if ((iscapital == true) && (islower == true) && (isspecial == true)){
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    func isValidEmail (email: String) -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: email)
    }
    func isValidPhoneNumber (number: String) -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: number)
    }
    
}

extension AddContactVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension AddContactVC: CNContactViewControllerDelegate{
    //MARK:- contacts delegates
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        print("dismiss contact")
        viewController.dismiss(animated: true, completion: nil)
    }
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}
/*
extension AddContactVC: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("native ads failed to load")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        self.ad_title.text = nativeAd.headline
        self.ad_description.text = "\t \(nativeAd.body ?? "")"
        
        self.callToActionView.setTitle(nativeAd.callToAction, for: .normal)
        self.nativeAdPlaceholder.isUserInteractionEnabled = false
        
        self.nativeAdPlaceholder.callToActionView = self.callToActionView
        self.nativeAdPlaceholder.iconView = self.ad_icon
        self.nativeAdPlaceholder.headlineView = self.ad_title
        //        self.nativeAdPlaceholder.bodyView = self.ad_description
        (self.nativeAdPlaceholder.bodyView as? UILabel)?.text = "\t \(nativeAd.body ?? "")"
      
        self.ad_icon.image = nativeAd.icon?.image
        self.ad_icon.isHidden = nativeAd.icon == nil
        
        self.nativeAdPlaceholder.nativeAd = nativeAd
        constNativeAdsView.constant = 125
       // self.nativeAdPlaceholder.isHidden = false
        
    }
}
extension AddContactVC: GADVideoControllerDelegate
{
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    }
}


// MARK: - GADNativeAdDelegate implementation
extension AddContactVC: GADNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}
*/

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpegData(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    func getSizeIn(_ type: DataUnits)-> Double {
        
        guard let data = self.pngData() else {
            return 0.0
        }
        
        var size: Double = 0.0
        
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        
        return size //String(format: "%.2f", size)
    }
}

extension String {
    public var validPhoneNumber: Bool {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count)).first?.phoneNumber {
            return match == self
        } else {
            return false
        }
    }
}
