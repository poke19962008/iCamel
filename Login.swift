//
//  Login.swift
//  iCamel
//
//  Created by Sayan Das on 04/07/15.
//  Copyright © 2015 Sayan Das. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NSUser details for the username and password of the user
        if NSUserDefaults.standardUserDefaults().objectForKey("UserDetails") != nil {
            NSLog("Fetching details from Evarsity.")
            startSpinner()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Check if the user is already signed in
        if NSUserDefaults.standardUserDefaults().objectForKey("UserDetails") != nil {
            
            NSLog("User already signed it.")
            self.performSegueWithIdentifier("AttendanceOverviewSegue", sender: nil)
            
        }else{
            NSLog("Geting user details.")
        }
    }
  
    //MARK :- Set Status Bar Style as white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    func storeUserDetails(RegisterNo: String, Password: String){
        let data = ["RegisterNo": RegisterNo, "Password": Password]
        
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "UserDetails")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func startSpinner(){
        let spinnerView = FeHourGlass(view: self.view)
        
        spinnerView.show()
        self.view.addSubview(spinnerView)
    }

    @IBAction func Submit(sender: AnyObject) {
        let ID = UserName.text
        let PD = Password.text
        
        
        //Check the user and password fields
        if ((ID == "") || (PD == "")){
            
            let alert = UIAlertController(title: "Incomplete", message: "Please Fill The Form", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            startSpinner()
            
            storeUserDetails(ID!, Password: PD!)
            NSLog("User Logged In.")
            self.performSegueWithIdentifier("AttendanceOverviewSegue", sender: nil)
        }
    }
    
    
}
