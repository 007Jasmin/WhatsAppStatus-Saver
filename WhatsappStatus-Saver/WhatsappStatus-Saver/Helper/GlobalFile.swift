//
//  GlobalFile.swift
//  BloodPressureApp
//
//  Created by ERASOFT on 12/11/22.
//

import Foundation
import UIKit

class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [StartColor.cgColor, EndColor.cgColor]
        l.startPoint = CGPoint(x: 0.25, y: 0.5)
        l.endPoint = CGPoint(x: 0.75, y: 0.5)
        l.cornerRadius = self.frame.height / 2
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

class themeImageView : UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor(named: "themeColor")
    }
}

class WhiteImageView : UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.white
    }
}

class GrayImageView : UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.lightGray
    }
}

class ViewBorderRadius : UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hexString: "#858585").cgColor
        self.layer.cornerRadius = 10
    }
}

func AlertWithMessage(_ vc:UIViewController,message:String)
{
    let dialogBox = UIAlertController(title: APPNAME, message: message, preferredStyle: .alert)
    dialogBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    vc.present(dialogBox, animated: true, completion: nil)
}
