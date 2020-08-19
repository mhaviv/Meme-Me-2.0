//
//  ViewController.swift
//  Meme Me
//
//  Created by Michael Haviv on 6/17/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var memeViewContainer: UIView!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    let labelText = "Caption".uppercased()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "impact", size: 28)!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldAttributes(textField: topTextField)
        textFieldAttributes(textField: bottomTextField)
        
        shareButton.isEnabled = false
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Capture the screen as screenshot
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Create a rect from imagePickerView containers view bounds
        let rect: CGRect = memeViewContainer.bounds
        let scale = memedImage.scale
        let scaledRect = CGRect(x: memeViewContainer.frame.origin.x * scale, y: memeViewContainer.frame.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        
        // Crop captured screen with rect created above and return just the contents of the image container view
        if let cgImage = memedImage.cgImage?.cropping(to: scaledRect) {
            let temp: UIImage = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
            return temp
        } else {
            return memedImage
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    // resizes the memeViewContainer to the inserted image size to align the label text fields
    func resizeViewToImage() {
        if let image = imagePickerView.image {
            let ratio = image.size.width / image.size.height
            let memeViewContainerWidth = memeViewContainer.frame.width
            let memeViewContainerHeight = memeViewContainer.frame.height
            
            if memeViewContainerWidth > memeViewContainerHeight {
                let newHeight = memeViewContainerWidth / ratio
                imagePickerView.frame.size = CGSize(width: memeViewContainerWidth, height: newHeight)
                print("Height: \(newHeight)")
            }
            
            if memeViewContainerWidth < memeViewContainerHeight {
                let newWidth = memeViewContainerHeight * ratio
                imagePickerView.frame.size = CGSize(width: newWidth, height: memeViewContainerHeight)
                print("Width: \(newWidth)")
            }
            if memeViewContainerWidth == memeViewContainerHeight && image.size.width > image.size.height {
                print("there!")
                let newWidth = memeViewContainerHeight * ratio
                imagePickerView.frame.size = CGSize(width: newWidth, height: memeViewContainerHeight)
            }
            if memeViewContainerWidth == memeViewContainerHeight && image.size.width < image.size.height {
                    print("here!")
//                    imagePickerView.backgroundColor = UIColor.black
//                    let newHeight = memeViewContainerWidth / ratio
                    imagePickerView.frame.size = CGSize(width: memeViewContainerWidth, height: memeViewContainerHeight)
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) || UIImagePickerController.isSourceTypeAvailable(.camera) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                imagePickerView.image = image
                imagePickerView.contentMode = .scaleAspectFill
                shareButton.isEnabled = true
                dismiss(animated: true, completion: nil)
                resizeViewToImage()
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // resizes image again when returning to portrait
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            resizeViewToImage()
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
            resizeViewToImage()
        default:
            text="View Not Changed"
        }
        print("You have moved: \(text)")
    }
    
    func defaultImageView() {
        imagePickerView.image = nil
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        topTextField.text = labelText
        bottomTextField.text = labelText
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated:true, completion:nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePickerWith(sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: UIImagePickerController.SourceType.camera)
    }
}



// MARK: - UINavigationControllerDelegate

extension MemeEditorViewController: UINavigationControllerDelegate {
    @IBAction func cancelMeme(_ sender: Any) {
        shareButton.isEnabled = false
        defaultImageView()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.popoverPresentationController?.barButtonItem = shareButton
        controller.completionWithItemsHandler = {( type, ok, items, error ) in
            if ok {
                self.saveMeme()
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func saveMeme() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
//        defaultImageView()
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - UITextFieldDelegate

extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldAttributes(textField: UITextField) {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = labelText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == labelText {
            textField.text = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = labelText
        }
    }
    
    
}


// MARK: - Keyboard Subscriptions and Functionality

extension MemeEditorViewController {
    
    func subscribeToKeyboardNotifications() {
        print("subscribe")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        print("unsubscribe!")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object:  nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        print("Keyboard Show!")
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        print("Keyboard Hide!")
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

