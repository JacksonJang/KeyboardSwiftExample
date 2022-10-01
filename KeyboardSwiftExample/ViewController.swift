//
//  ViewController.swift
//  KeyboardSwiftExample
//
//  Created by 장효원 on 2022/10/01.
//

import UIKit

class ViewController: UIViewController {
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    
    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        sv.spacing = 10
        
        return sv
    }()
    
    let firstTextView = RoundTextView()
    let secondTextView = RoundTextView()
    let thirdTextView = RoundTextView()
    let forthTextView = RoundTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerObserver(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        registerObserver(false)
    }

    private func setupUI() {
        self.scrollView.addSubview(stackView)
        self.view.addSubview(scrollView)
        
        setupTextView()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
        ])
    }
    
    private func setupTextView() {
        [
            firstTextView,
            secondTextView,
            thirdTextView,
            forthTextView
        ].forEach{
            stackView.addArrangedSubview($0)
        }
    }
    
    /// - parameter bool : true is activiting observer, false is deactivating observer
    private func registerObserver(_ bool:Bool) {
        registerScrollObserver(bool)
        registerKeyboardObserver(bool)
    }
    
    /// - parameter bool : true is activiting observer, false is deactivating observer
    private func registerScrollObserver(_ bool:Bool) {
        if bool {
            tapGesture.numberOfTapsRequired = 1
            tapGesture.isEnabled = true
            tapGesture.cancelsTouchesInView = false
            scrollView.addGestureRecognizer(tapGesture)
        } else {
            scrollView.removeGestureRecognizer(tapGesture)
        }
    }
    
    @objc
    private func endEditing() {
        self.view.endEditing(true)
    }
}

//MARK: - Keyboard Observer
extension ViewController {
    /// - parameter bool : true is activiting observer, false is deactivating observer
    private func registerKeyboardObserver(_ bool: Bool) {
        if bool {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc
    private func keyboardDidShowNotification(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            print("💙 keyboardDidShowNotification contentInsets : \(contentInsets)")
        }
    }
    
    @objc
    private func keyboardWillHideNotification(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        print("💙 keyboardWillHideNotification contentInsets : \(contentInsets)")
    }

}
