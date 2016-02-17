//
//  ViewController.swift
//  Meme
//
//  Created by Victor Jimenez on 2/16/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    //Text properties
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0,
    ]

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraToolbarConstraint: NSLayoutConstraint!
    
    var memedImage: UIImage!
    
    //MARK: Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool) {
        // Subscribe to the keyboard notifications
        subscribeToKeyboardNotifications()
        
        shareButton.enabled = imagePickerView.image != nil ? true : false
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setTextFields([topTextField, bottomTextField])
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    //Funcs for repetitive code
    func setTextFields(textFields: [UITextField]) {
        for textField in textFields {
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .Center
            textField.backgroundColor = UIColor.clearColor()
        }
    }
    
    func pickImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = imagePickerSource(sender)
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Save
    
    func save() -> Bool {
        memedImage = generateMemedImage()
        if memedImage != nil {
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memeImage: memedImage)
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
            dismissViewControllerAnimated(true, completion: nil)
            return true
        }
        return false
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5, 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard scaledImage != nil else {
            return (scaledImage)
        }
        
        return (scaledImage)
    }
    
    func imagePickerSource(type: AnyObject) -> UIImagePickerControllerSourceType {
        if type.title == "Pick" {
            return UIImagePickerControllerSourceType.PhotoLibrary
        } else {
            return UIImagePickerControllerSourceType.Camera
        }
    }
    
    //MARK: Animations
    
    func hideBottomToolbar(completion: ((Bool) -> Void)?) {
        //Hide navBar
        navigationController?.setNavigationBarHidden(true, animated: true)
        //Hide toolbar
        cameraToolbarConstraint.constant = -cameraToolbar.bounds.size.height
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                if (finished) {
                    completion!(true)
                }
        })
    }
    
    func showBottomToolbar() {
        //Show navBar
        navigationController?.setNavigationBarHidden(false, animated: true)
        //Show toolbar
        cameraToolbarConstraint.constant = 0.0
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    //MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
           view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Actions

    @IBAction func pickAnImage(sender: AnyObject) {
        pickImage(sender)
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickImage(sender)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        hideBottomToolbar { (finished) -> Void in
            let image = self.generateMemedImage()
            let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            controller.completionWithItemsHandler = {(activity, success, items, error) in
                controller.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
                self.showBottomToolbar()
                if success {
                    self.save()
                }
            }
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

//MARK: Extensions

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.text = textField.text?.uppercaseString
        textField.resignFirstResponder()
        return false
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
