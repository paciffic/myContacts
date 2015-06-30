//
//  ContactDetailViewController.swift
//  myContacts
//
//  Created by paciffic on 2015. 6. 30..
//  Copyright (c) 2015년 paciffic. All rights reserved.
//

import UIKit
import AddressBook

class ContactDetailViewController: UIViewController {

    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
}
