//
//  Login.swift
//  iCamel
//
//  Created by Sayan Das on 04/07/15.
//  Copyright © 2015 Sayan Das. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var viewLabels: UIView!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var LoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let invertButton = AYVibrantButton(frame: CGRect(x: 20, y: 95, width: 120, height: 30), style: AYVibrantButtonStyleInvert)
        invertButton.vibrancyEffect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        invertButton.text = "Log In"
        invertButton.font = UIFont.systemFontOfSize(18.0)
        invertButton.center = LoginView.center
        invertButton.center.y = UserName.center.y
        LoginView.addSubview(invertButton)
        let pressGesture = UITapGestureRecognizer(target: self, action: "Submit")
        
        invertButton.addGestureRecognizer(pressGesture)

        
        
        // NSUser details for the username and password of the user
        if NSUserDefaults.standardUserDefaults().objectForKey("UserDetails") != nil {
            NSLog("Fetching details from Evarsity.")
            startSpinner()
        }
        
        //Start initial animations
        startAnimations()
        
    }
    
    
    
    func startAnimations(){
        
        UserName.center.y = self.view.frame.height + 30
        Password.center.y = self.view.frame.height + 30
        dividerView.alpha = 0.0
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 2.0, initialSpringVelocity: 6.5, options: UIViewAnimationOptions.TransitionNone, animations: ({
            self.UserName.center.y = self.view.frame.height / 2 - 19
            self.Password.center.y = self.view.frame.height / 2 + 19
            self.dividerView.alpha = 0.5
        
        
        }), completion: nil)
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
  
    //MARK :- Set Status Bar Style as Light
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

    func Submit() {
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
