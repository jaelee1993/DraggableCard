//
//  ViewController.swift
//  SmartDraggableCard
//
//  Created by Jae Lee on 9/20/19.
//  Copyright © 2019 Jae Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, SendViewDelegate {
    var numberField:UITextField!
    var readyButton:UIButton!
    var sendView:DraggableSendView!
    var sendViewY:CGFloat = UIScreen.main.bounds.maxY - 100
    var timer:Timer = Timer()
    var time:Float = 0
    var iVelocity:Float = 0
    var fVelocity:Float = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberField()
        drawReadyButton()
        drawDragSendView()
        drawUserInfoButton()
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
    
    fileprivate func setupNumberField() {
        numberField = UITextField()
        numberField.delegate = self
        numberField.becomeFirstResponder()
        numberField.backgroundColor = .white
        numberField.textColor = .black
        numberField.font = UIFont.systemFont(ofSize: 40, weight: .light)
        numberField.keyboardType = .numberPad
        numberField.keyboardAppearance = .dark
        numberField.textAlignment = .center
        numberField.textContentType = .telephoneNumber
        numberField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(numberField)
        
        numberField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        numberField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        numberField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    
    fileprivate func drawReadyButton() {
        readyButton = UIButton()
        readyButton = UIButton(type: .custom)
        readyButton.backgroundColor = .black
        readyButton.setTitle("ready", for: .normal)
        readyButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        readyButton.setTitleColor(.white, for: .normal)
        readyButton.layer.cornerRadius = 13
        readyButton.layer.borderWidth = 1
        readyButton.layer.borderColor = UIColor.clear.cgColor
        readyButton.addTarget(self, action: #selector(readyIsPressed), for: .touchUpInside)
        readyButton.alpha = 0.0
        self.view.addSubview(readyButton)
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        readyButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        readyButton.topAnchor.constraint(equalTo: self.numberField.bottomAnchor, constant: 10).isActive = true
        readyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    fileprivate func drawUserInfoButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.frame = CGRect(x: UIScreen.main.bounds.maxX - 50, y: UIScreen.main.bounds.minY + 50, width: 50, height: 50)
        infoButton.addTarget(.none, action: #selector(showInfoView), for: .touchUpInside)
        self.view.addSubview(infoButton)
    }
    @objc private func showInfoView() {
        
    }
    
    fileprivate func showReadyButton() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.readyButton.alpha = 1
        }, completion: nil)
    }
    fileprivate func hideReadyButton() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.readyButton.alpha = 0.0
        }, completion: nil)
    }
    
    fileprivate func drawDragSendView() {
        sendView = DraggableSendView(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        sendView.setNameLabel()
        sendView.setName(name: "Harry Potter")
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.drag(_:)))
        sendView.isUserInteractionEnabled = true
        sendView.addGestureRecognizer(gesture)
        sendView.delegate = self
        self.view.addSubview(sendView)
    }
    
    func resetSendViewY() {
        sendViewY = UIScreen.main.bounds.maxY - 100
    }
    
    fileprivate func setAndRunTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.time = self.time + 0.01
        }
    }
    
    fileprivate func endTimer() {
        timer.invalidate()
        time = 0.0
    }
    
    /**
     Calculates velocity with displacement and time
     */
    fileprivate func velocity<F:FloatingPoint>(distance:F, time:F) -> F {
        return distance/time
    }
    
    /**
     Calculates velocity with two points and time
     */
    fileprivate func velocity(x1:Float, x2:Float, time:Float) -> Float {
        return (x2-x1)/time
    }
    
    
    @objc private func drag(_ sender:UIPanGestureRecognizer) {
        let translationY = sender.translation(in: self.view).y
        
        if sender.state == .began {
            setAndRunTimer()
        }
        
        if sender.state == .changed {
            sendViewY = sendViewY + translationY
            sendView.frame = CGRect(x: 0, y: sendViewY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            fVelocity = velocity(distance: Float(translationY), time: time)
        }
        
        if sender.state == .ended {
            endTimer()
            
            /**
             When swipe velocity is less (<) than -300 (frames/milisecond)
             note: as lower the number is the faster it is
             */
            if fVelocity < -300 {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                    self.sendView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }) { (_) in
                    UIView.animate(withDuration: 1.2, delay: 0.2, options: [.curveLinear], animations: {
                        /** SEND CARD API GOES HERE */
                        self.sendCardApi()
                        /** end */
                        self.sendView.alpha = 0.0
                    }, completion: { (_) in
                        self.sendView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        self.sendView.alpha = 1.0
                        self.resetSendViewY()
                        return
                    })
                }
            }
                
                /**
                 When swipe velocity is greater (>) than 300
                 note: as lower the number is the faster it is
                 */
            else {
                
                /**
                 When point of scroll is less than 4/10 from the bottom of screen it animates back
                 */
                if sendViewY > UIScreen.main.bounds.height * 6/10 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.sendView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        self.sendView.alpha = 1.0
                        self.resetSendViewY()
                        return
                    }, completion: { (_) in
                        
                    })
                }
                
                /**
                 When point of scroll is greater than 4/10 from the bottom of screen it animates all the way
                 */
                if sendViewY <= UIScreen.main.bounds.height * 6/10 {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                        self.sendView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        self.sendView.backgroundColor?.withAlphaComponent(1.0)
                        self.resetSendViewY()
                        self.view.layoutIfNeeded()
                        sender.setTranslation(CGPoint.zero, in: self.view)
                    }) { (_) in
                        UIView.animate(withDuration: 1.2, delay: 0.2, options: [.curveLinear], animations: {
                            /** SEND CARD API GOES HERE */
                            self.sendCardApi()
                            /** end */
                            
                            self.sendView.alpha = 0.0
                        }, completion: { (_) in
                            self.sendView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            self.sendView.alpha = 1.0
                            self.resetSendViewY()
                            return
                        })
                    }
                }
            }
            
            
        }
        self.view.layoutIfNeeded()
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    
    @objc func readyIsPressed() {
        numberField.resignFirstResponder()
        sendView.rockTheView()
    }
    
    /**
     This function formats the number for the purpose of the UI/UX
     */
    fileprivate func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count >= 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
            showReadyButton()
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
            hideReadyButton()
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    
}



extension ViewController {
    func sendCardApi() {
        
    }
}
