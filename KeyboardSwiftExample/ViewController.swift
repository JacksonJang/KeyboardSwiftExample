//
//  ViewController.swift
//  KeyboardSwiftExample
//
//  Created by 장효원 on 2022/10/01.
//

import UIKit

class ViewController: UIViewController {
    let keyboardManager = KeyboardManager()
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
        setupKeyboardManager()
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
        keyboardManager.register(bool)
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

//MARK: - KeyboardManager
extension ViewController {
    private func setupKeyboardManager() {
        keyboardManager.configuration(parentView: self.view, scrollView: self.scrollView)
    }
}
