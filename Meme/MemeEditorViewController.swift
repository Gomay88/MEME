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
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3.0,
        ] as [NSAttributedString.Key : Any]

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to the keyboard notifications
        subscribeToKeyboardNotifications()
        
        shareButton.isEnabled = imagePickerView.image != nil ? true : false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        
        setTextFields(textFields: [topTextField, bottomTextField])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    //Funcs for repetitive code
    func setTextFields(textFields: [UITextField]) {
        for textField in textFields {
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
            textField.backgroundColor = .clear
        }
    }
    
    func pickImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = imagePickerSource(type: sender)
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Save
    
    func save() -> Bool {
        memedImage = generateMemedImage()
        if memedImage != nil {
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memeImage: memedImage)
            
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            dismiss(animated: true, completion: nil)
            return true
        }
        return false
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0);
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        let size = image!.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image!.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard scaledImage != nil else {
            return (scaledImage!)
        }
        
        return (scaledImage!)
    }
    
    func imagePickerSource(type: AnyObject) -> UIImagePickerController.SourceType {
        if type.title == "Pick" {
            return UIImagePickerController.SourceType.photoLibrary
        } else {
            return UIImagePickerController.SourceType.camera
        }
    }
    
    //MARK: Animations
    
    func hideBottomToolbar(completion: ((Bool) -> Void)?) {
        //Hide navBar
        navigationController?.setNavigationBarHidden(true, animated: true)
        //Hide toolbar
        cameraToolbarConstraint.constant = -cameraToolbar.bounds.size.height
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
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
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    //MARK: Keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Actions

    @IBAction func pickAnImage(sender: AnyObject) {
        pickImage(sender: sender)
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickImage(sender: sender)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        hideBottomToolbar { (finished) -> Void in
            let image = self.generateMemedImage()
            let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            controller.completionWithItemsHandler = {(activity, success, items, error) in
                controller.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
                self.showBottomToolbar()
                if success {
                    _ = self.save()
                }
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: Extensions

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.uppercased()
        textField.resignFirstResponder()
        return false
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}
