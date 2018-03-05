//
//  AlertViewController.swift
//  Mp3 Player
//
//  Created by Sarim Ashfaq on 01/03/2018.
//

import UIKit

class PopupView {
    
    private var titleString: String? = nil
    private var messageString: String? = nil
    private var buttons: [PopupAction] = []
    private var picture: UIImage? = nil
    
    public var actions: [PopupAction]{
        get{
            return buttons
        }
        set {
            buttons = newValue
        }
    }
    
    init() {
    }
    
    init(_ title: String? , _ message: String?, _ image: UIImage?) {
        titleString = title
        messageString = message
        picture = image
    }
    
    func show(in viewController: UIViewController, _ animated: Bool){
        let vc = AlertViewController(nibName: "AlertViewController", bundle: nil)
//        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.buttons = buttons
        vc.titleString = titleString
        vc.messageString = messageString
        vc.animated = animated
        vc.picture = picture
        viewController.present(vc, animated: false,completion: nil)
    }
    
}

class PopupAction {
    
    typealias ButtonAction = () -> ()
    
    enum PopupActionAtyle {
        case normal, cancel, destructive
    }
    
    var titleString: String = ""
    var buttonStyle: PopupActionAtyle = .normal
    var buttonAction: ButtonAction? = nil
    
    private init(_ title: String) {
        titleString = title
    }
    
    init(_ title: String, _ style: PopupActionAtyle, action: ButtonAction?) {
        buttonStyle = style
        titleString = title
        buttonAction = action
    }
    
}

extension Notification.Name{
    static let popupComplitionAction = Notification.Name("popupComplitionAction")
}

class AlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popupImage: UIImageView!
    @IBOutlet weak var popupImageHeight: NSLayoutConstraint!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupMessage: UITextView!
    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    
    var picture: UIImage? = nil
    var titleString: String? = nil
    var messageString: String? = nil
    var buttons: [PopupAction] = []
    var alertButtons: [AlertButton] = []
    var animated: Bool = true
    var indexTag: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 5.0
        popupImageHeight.constant = picture != nil ? 100:0
        popupImage.image = picture
        popupTitle.text = titleString
        popupMessage.text = messageString
//        imageBottom.constant = CGFloat(40 * buttons.count) + 4.0
        popupMessage.translatesAutoresizingMaskIntoConstraints = true
        popupMessage.sizeToFit()
        popupMessage.isScrollEnabled = false
        for button in buttons {
            let btn = AlertButton(button.titleString, button.buttonStyle, indexTag)
            btn.delegate = self
            alertButtons.append(btn)
            buttonsView.add(btn, indexTag == 0 ? nil:alertButtons[indexTag - 1])
            indexTag += 1
        }
        buttonViewHeight.constant = CGFloat(40 * alertButtons.count)
        alertView.sizeToFit()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        resizeAlertView()
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.alertView.center.y = self.view.center.y
            }) { (status) in
                
            }
        } else {
            self.alertView.center.y = self.view.center.y
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        dismissAlertView()
    }
    
    @IBAction func swipeAction(_ sender: UIPanGestureRecognizer) {
        dismissOnSwipe(sender: sender)
    }
    
    @IBAction func alertViewSwipeAction(_ sender: UIPanGestureRecognizer) {
        dismissOnSwipe(sender: sender)
    }
    
    func resizeAlertView(){
        let textViewFrame = popupMessage.frame
        let titleFrame = popupTitle.frame
        let totalHeight = textViewFrame.height + titleFrame.height + buttonViewHeight.constant + popupImageHeight.constant + 36.0
        let alertBounds = alertView.frame
        print(alertBounds.height)
        print(self.view.bounds.height - 100)
        if totalHeight >= self.view.bounds.height - 100 {
            let newHeight = self.view.bounds.height - (100 + 32.0 + titleFrame.height + buttonViewHeight.constant + popupImageHeight.constant)
            popupMessage.frame = CGRect(x: textViewFrame.origin.x, y: textViewFrame.origin.y, width: textViewFrame.width, height: newHeight)
            popupMessage.isScrollEnabled = true
            alertView.frame = CGRect(x: alertBounds.origin.x, y: alertBounds.origin.y, width: alertBounds.width, height: self.view.bounds.height - 100)
//            alertView.addAtBottom(buttonsView, CGFloat(40 * alertButtons.count), popupImage)
        }
    }
    
    func dismissOnSwipe(sender: UIPanGestureRecognizer){
        let velocity = sender.velocity(in: self.view)
        if velocity.y < 0 {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.alertView.center.y = self.alertView.center.y - 1
                if self.alertView.center.y <= self.view.center.y - 150 {
//                    self.view.alpha = 1
                    self.alertView.center.y = self.view.center.y
                }
            }) { (status) in
                
            }
        } else {
            UIView.animate(withDuration: 0.03, delay: 0, options: .curveEaseInOut, animations: {
//                self.view.alpha -= 0.05
                self.alertView.center.y = self.alertView.center.y + 10
                if self.alertView.center.y >= self.view.center.y + 200 {
                    self.backImage.isHidden = true
                    self.alertView.center.y = self.alertView.center.y + 500
                    self.dismiss(animated: true, completion: nil)
                }
            }) { (status) in
                
            }
        }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseInOut, animations: {
                self.alertView.center.y = self.view.center.y
            }) { (status) in
                
            }
        }
    }
    
    func dismissAlertView(){
        for _ in 0...4 {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.alertView.center.y = self.alertView.center.y + 50
                if self.alertView.center.y >= self.view.center.y + 200 {
                    self.backImage.isHidden = true
                    self.alertView.center.y = self.alertView.center.y + 500
                    self.dismiss(animated: true, completion: nil)
                }
            }) { (status) in
                
            }
        }
        
    }
    
}

extension AlertViewController: AlertViewButtonDelegate {
    func didPressedButton(with identifier: String, _ tag: Int, _ state: PopupAction.PopupActionAtyle) {
        if let action = buttons[tag].buttonAction {
            action()
        }
        dismissAlertView()
    }
}

extension UIView {
    func add(_ view: UIView, _ below: UIView?){
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
        NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: below != nil ? below!:self, attribute: .top, multiplier: 1.0, constant: below != nil ? 40:0.0).isActive = true
        
        
    }
    
    func addAtBottom(_ view: UIView, _ height: CGFloat, _ below: UIView){
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: below, attribute: .bottom, multiplier: 1.0, constant: 4.0).isActive = true
    }
    
}
