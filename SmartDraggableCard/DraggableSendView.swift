//
//  DraggableSendView.swift
//  SmartDraggableCard
//
//  Created by Jae Lee on 9/20/19.
//  Copyright © 2019 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

protocol SendViewDelegate {
    func resetSendViewY()
}

class DraggableSendView: UIView {
    var nameLabel:UILabel!
    var delegate:SendViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layer.cornerRadius = 13
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        
        
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setNameLabel() {
        nameLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 400, height: 300))
        nameLabel.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        nameLabel.textColor = .white
        self.addSubview(nameLabel)
    }
    func setName(name:String) {
        nameLabel.text = name
    }
    
    public func rockTheView() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseInOut, .curveLinear], animations: {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .curveLinear], animations: {
                self.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }, completion: { (_) in
                self.delegate?.resetSendViewY()
            })
        })
    }
    
    
}
