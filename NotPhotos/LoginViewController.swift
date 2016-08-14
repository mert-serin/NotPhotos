//
//  LoginViewController.swift
//  NotPhotos
//
//  Created by Mert Serin on 28/01/16.
//  Copyright © 2016 Mert Serin. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var stepOneLabel: UILabel!
    @IBOutlet weak var stepTwoLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var fingerprintButton: UIButton!
    
    
    @IBOutlet weak var digitOne: UITextField!
    @IBOutlet weak var digitTwo: UITextField!
    @IBOutlet weak var digitThree: UITextField!
    @IBOutlet weak var digitFour: UITextField!
    @IBOutlet weak var digitFive: UITextField!
    @IBOutlet weak var digitSix: UITextField!
    
    //MARK: Public API
    var password = String()
    var userDefaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        digitOne.delegate = self
        digitTwo.delegate = self
        digitThree.delegate = self
        digitFour.delegate = self
        digitFive.delegate = self
        digitSix.delegate = self
        
        if let password = userDefaults.objectForKey("password"){
            firstTimeLabel.text = ""
            stepOneLabel.text = "Please enter your password"
        }
        fingerprintButton.userInteractionEnabled = false
    }
    
    
    @IBAction func textFieldChanged(sender: UITextField) {
        
        if(sender == digitOne){
            textFieldOperation(sender, index: 0)
        }
        if(sender == digitTwo){
            textFieldOperation(sender, index: 1)
        }
        if(sender == digitThree){
            textFieldOperation(sender, index: 2)
        }
        if(sender == digitFour){
            textFieldOperation(sender, index: 3)
        }
        if(sender == digitFive){
            textFieldOperation(sender, index: 4)
        }
        if(sender == digitSix){
            textFieldOperation(sender, index: 5)
        }
        print(password)
        
    }
    
    
    func textFieldOperation(sender:UITextField,index:Int){
        var textFieldArray = [digitOne,digitTwo,digitThree,digitFour,digitFive,digitSix]
        if(sender.text?.characters.count == 1){
            password += sender.text!
            if(index == 5){
                sender.text = "😍"
                checkPassword(password)
            }
            else{
                textFieldArray[index+1].becomeFirstResponder()
                sender.text = "😍"
            }
            
        }
        if(sender.text?.characters.count > 1){
            password = ""
            let lastChar = "\(sender.text![(sender.text?.endIndex.predecessor())!])"
            password += lastChar
            if(index == 5){
                sender.text = "😍"
                checkPassword(password)
                
            }
            else{
                textFieldArray[index+1].becomeFirstResponder()
                sender.text = "😍"
            }
            
        }
    }
    
    func checkPassword(password:String){
        if let userPass = userDefaults.objectForKey("password"){
            let brain = LoginBrain(password: password)
            if(brain.checkPassword()){
                fingerprintButton.userInteractionEnabled = true
                self.errorLabel.text = "Perfect!"
                touchIdCall()
            }
            else{
                self.view.shake()
                self.errorLabel.text = "Wrong Password"
                clearAll(0)
            }
        }
        else{
            fingerprintButton.userInteractionEnabled = true
            self.errorLabel.text = "Your password has been saved"
            userDefaults.setObject(password, forKey: "password")
            touchIdCall()
        }
        self.view.endEditing(true)
    }
    
    
    func clearAll(endIndex:Int){
        var textFieldArray = [digitOne,digitTwo,digitThree,digitFour,digitFive,digitSix]
        let count = textFieldArray.count-1
        for var i = count; i>=endIndex; --i{
            textFieldArray[i].text = ""
            password = String(password.characters.dropLast())
        }
    }
    
    
    @IBAction func fingerprintAction() {
        touchIdCall()
    }
    
    func touchIdCall(){
        let authContext = LAContext()
        var error: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Testing Touch ID", reply: { (complete, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if complete {
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! UITabBarController
                        vc.selectedIndex = 0
                        self.presentViewController(vc, animated: true, completion: nil)
                    }

                else{
                    //Uyarı
                }
                })
                
            })
            
        }
        else{
            
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text?.characters.count == 1){
        if(textField == digitOne){
            clearAll(0)
        }
        if(textField == digitTwo){
            clearAll(1)
        }
        if(textField == digitThree){
            clearAll(2)
        }
        if(textField == digitFour){
            clearAll(3)
        }
        if(textField == digitFive){
            clearAll(4)
        }
        if(textField == digitSix){
            clearAll(5)
        }
        }
        print(password)
    }
    
    
    

}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
}

