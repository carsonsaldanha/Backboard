//
//  RadioButton.swift
//  Backboard
//
//  Created by Alexy Correa on 11/4/21.
//

import UIKit

protocol RadioButtonDelegate {
    func onClick(_ sender: UIView)
}

class RadioButton: UIButton {
    var checkedView: UIView?
    var uncheckedView: UIView?
    var delegate: RadioButtonDelegate?
    
    var isChecked: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(onClick), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkedView?.removeFromSuperview()
        uncheckedView?.removeFromSuperview()
        removeConstraints(self.constraints)
        
        let view = isChecked == true ? checkedView : uncheckedView
        if let view = view {
            addSubview(view)
            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    @objc func onClick(sender: UIButton) {
        if sender == self {
            delegate?.onClick(self)
        }
    }
}
