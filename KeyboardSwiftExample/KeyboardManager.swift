//
//  KeyboardManager.swift
//  KeyboardSwiftExample
//
//  Created by 장효원 on 2022/10/02.
//

import UIKit

public class KeyboardManager: NSObject {
    /// saved value that is keyboard offset, default value : nil
    private var keyboardOffset: CGPoint?
    
    private var parentView:UIView!
    private var scrollView:UIScrollView!
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    
    /// - parameters:
    ///  - parentView: what you're using view of UIViewController
    ///  - scrollView: what you're using currently UIScrollView
    public func configuration(parentView:UIView, scrollView:UIScrollView) {
        self.parentView = parentView
        self.scrollView = scrollView
    }
    
    /// - parameter bool : true is activiting tapGesture of endEditing for ScrollView, false is deactivating
    public func isEndEditing(_ bool:Bool) {
        if bool {
            tapGesture.numberOfTapsRequired = 1
            tapGesture.isEnabled = true
            tapGesture.cancelsTouchesInView = false
            scrollView.addGestureRecognizer(tapGesture)
        } else {
            scrollView.removeGestureRecognizer(tapGesture)
        }
    }
    
    /// - parameter bool : true is activiting observer, false is deactivating observer
    public func register(_ bool: Bool) {
        if bool {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    /// if you want to find view that is "FirstResponder" Bool, you can use this function
    private func findViewThatIsFirstResponder(view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }

        for subView in view.subviews {
            if let result = findViewThatIsFirstResponder(view: subView) {
                return result
            }
        }

        return nil
    }
    
    @objc
    private func keyboardDidShowNotification(_ notification: NSNotification) {
        guard let view = parentView, let scrollView = self.scrollView else {
            print("💙 you must need to configuration parentView and scrollView")
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            let activeField: UIView? = findViewThatIsFirstResponder(view: view)
            
            var safeArea = view.frame
            safeArea.size.height -= scrollView.contentOffset.y
            safeArea.size.height -= keyboardSize.height
            safeArea.size.height -= view.safeAreaInsets.bottom
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            if let activeField = activeField {
                let activeFrameInView = view.convert(activeField.bounds, from: activeField)
                let distance = activeFrameInView.maxY - safeArea.size.height
                if keyboardOffset == nil {
                    keyboardOffset = scrollView.contentOffset
                }
                scrollView.setContentOffset(CGPoint(x: 0, y: distance), animated: true)
            }
        }
    }
    
    @objc
    private func keyboardWillHideNotification(_ notification: NSNotification) {
        guard let scrollView = self.scrollView else {
            print("💙 you must need to configuration parentView and scrollView")
            return
        }
        
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        guard let restoreOffset = keyboardOffset else {
            return
        }
        
        scrollView.setContentOffset(restoreOffset, animated: true)
        self.keyboardOffset = nil
    }
    
    @objc
    private func endEditing() {
        self.parentView.endEditing(true)
    }
}
