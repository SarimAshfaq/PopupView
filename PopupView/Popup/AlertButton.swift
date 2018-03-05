//
//  AlertButton.swift
//  Mp3 Player
//
//  Created by Sarim Ashfaq on 02/03/2018.
//

import UIKit

protocol AlertViewButtonDelegate {
    func didPressedButton(with identifier: String, _ tag: Int, _ state: PopupAction.PopupActionAtyle)
}

class AlertButton: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    
    public var delegate: AlertViewButtonDelegate? = nil
    var state: PopupAction.PopupActionAtyle = .normal
    private var identifier: String = ""
    private var buttonTag: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(_ title: String, _ buttonState: PopupAction.PopupActionAtyle, _ tag: Int) {
        self.init()
        commonInit()
        buttonTag = tag
        identifier = title
        state = buttonState
        configureButton(title)
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("AlertButton", owner: self, options: nil)
        self.backgroundColor = UIColor.black
        addSubview(contentView)
        contentView.frame = self.bounds
        //        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton){
        delegate?.didPressedButton(with: identifier, buttonTag, state)
    }
    
    func configureButton(_ titleText: String){
        switch state {
        case .normal:
            button.setTitle(titleText, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(red: 0.1608, green: 0.502, blue: 0.7255, alpha: 1.0)
        case .destructive:
            button.setTitle(titleText, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(red: 0.7412, green: 0.149, blue: 0.1529, alpha: 1.0)
        case .cancel:
            button.setTitle(titleText, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.white
        default:
            button.setTitle(titleText, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor(red: 0.1608, green: 0.502, blue: 0.7255, alpha: 1.0)
        }
    }

}

