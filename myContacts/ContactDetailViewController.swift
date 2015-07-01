//
//  ContactDetailViewController.swift
//  myContacts
//
//  Created by paciffic on 2015. 6. 30..
//  Copyright (c) 2015년 paciffic. All rights reserved.
//

import UIKit
import AddressBook

class ContactDetailViewController: UITableViewController {

    var addressBookRef: ABAddressBook = []
    var contactList: NSArray = []
    var contactNames: [String]!
    var contactImages: [UIImage]!
    
    func initVar() {
        addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        contactList = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVar()
        process_authorization()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // authorzation 처리 함수
    func process_authorization() {
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            println("Denied")
            //displayCantAddContactAlert()
        case .Authorized:
            //2
            println("Authorized")
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef,{success, error in
                if success {
                    println("success")
                    self.getAllContactsList()
                }
                else
                {
                    println("error")
                }
            })
           
        
            //addPetToContacts(petButton)
        case .NotDetermined:
            //3
            println("Not Determined")
            promptForAddressBookRequestAccess()
        }
    }
    
    // AddressBook에 대한 access prompt를 보여주는 함수
    func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    println("Just denied")
                    self.displayCantAddContactAlert()
                } else {
                    println("Just authorized")
                    self.getAllContactsList()
                    //self.addPetToContacts(petButton)
                }
            }
        }
    }
    
    // url처리를 위한 세팅 함수
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // 연락처를 추가하지 못할때 alert하는 함수
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
            message: "You must give the app permission to add the contact first.",
            preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    // 전체 연락처 목록을 얻어오는 함수
    func getAllContactsList() {
        let allRecord : ABRecordRef = ABPersonCreate().takeRetainedValue()
        
        var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue()
        //println("records in the array \(contactList.count)") // returns 0
        
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
            var phones : ABMultiValueRef = ABRecordCopyValue(record,kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValueRef
            
            for(var numberIndex : CFIndex = 0; numberIndex < ABMultiValueGetCount(phones); numberIndex++)
            {
                let phoneUnmaganed = ABMultiValueCopyValueAtIndex(phones, numberIndex)
                
                let phoneNumber : NSString = phoneUnmaganed.takeUnretainedValue() as NSString
                
                let locLabel : CFStringRef = (ABMultiValueCopyLabelAtIndex(phones, numberIndex) != nil) ? ABMultiValueCopyLabelAtIndex(phones, numberIndex).takeUnretainedValue() as CFStringRef : ""
                
                var cfStr:CFTypeRef = locLabel
                var nsTypeString = cfStr as NSString
                var swiftString:String = nsTypeString as String
                
                //let customLabel = String (stringInterpolationSegment: ABAddressBookCopyLocalizedLabel(locLabel))
                let customLabel = ABAddressBookCopyLocalizedLabel(locLabel)
                
                
                println("Name : \(contactName), NO : \(phoneNumber)" )
           
        }

        
        //println(addressBookRef.)
        }
    } //func getAllContactsList() End
    
    
    func getContactListCount() -> Int {
        var contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue()
        println("records in the array \(contactList.count)")
        return contactList.count  // returns count of contacList
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return getContactListCount()
    }
    
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ContactsTableCell", forIndexPath: indexPath) as ContactTableViewCell
        let row = indexPath.row
    
        cell.lblContactName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    
        contactNames = Array()
        contactImages = Array()
    
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
            var phones : ABMultiValueRef = ABRecordCopyValue(record,kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValueRef
            var contactImage = ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail)?
            
            if contactImage != nil
            {
                var imgTemp : NSObject? = Unmanaged<NSObject>.fromOpaque(contactImage! .toOpaque()).takeRetainedValue()
                
                if imgTemp != nil
                {
                    contactImages.append(UIImage(data: imgTemp as NSData)!)
                }
                else {
                    contactImages.append(UIImage(named: "grand_canyon.jpg")!)
                }
            } else {
                contactImages.append(UIImage(named: "grand_canyon.jpg")!)
            }
            
            if (contactNames != nil)
            {
                contactNames.append(contactName)
            }
            else {
                contactNames.append("")
            }
        }
    
        println("contactImages : \(contactImages.count)")
        println("contactList.count : \(contactList.count), row : \(indexPath.row)")
        //println("contactName : \(contactNames[indexPath.row]), contactImage : \(contactImages[indexPath.row])")
    
        cell.lblContactName.text = contactNames[indexPath.row]
        cell.imvContact.image = contactImages[indexPath.row]
        return cell
    }
    
    
}
