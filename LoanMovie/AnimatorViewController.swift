//
//  AnimatorViewController.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/24.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit

class AnimatorViewController: UIViewController {
    
    @IBOutlet weak var myView1: UIView!
    @IBOutlet weak var myView2: UIView!
    @IBOutlet weak var myView3: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var maskLabel: UILabel!
    
    var start3D = CATransform3DIdentity
    var end3D = CATransform3DIdentity
    
    fileprivate lazy var basicAnimator: CABasicAnimation = {
        /// transform 旋转动画
        let baseAnimator = CABasicAnimation.init(keyPath: "transform")
        baseAnimator.duration = 10 /// 动画时间
        baseAnimator.repeatCount = 0 // 循环次数
//        baseAnimator.autoreverses = false
        baseAnimator.isRemovedOnCompletion = false
        baseAnimator.fillMode = kCAFillModeForwards
        return baseAnimator
    }()
    
    fileprivate lazy var colorGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        return gradientLayer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startAnimator(_ sender: UIButton) {
        animation1()
    }
    
    @IBAction func drawTextLabelEvent(_ sender: UIButton) {
        animation2()
    }
    
    @IBAction func animator3Event(_ sender: UIButton) {
        
        animation4()
//        animator3()
    }
    
    
    func animation1() {
        let transition = CATransition.init()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.duration = 10
        
        myView1.layer.add(transition, forKey: "transition")
        myView2.layer.add(transition, forKey: "transition")
        
        myView1.isHidden = true
        myView2.isHidden = false
    }
    
    func animation2() {
        colorGradientLayer.removeFromSuperlayer()
        colorGradientLayer.frame = CGRect(x:0, y:0, width: maskLabel.frame.width, height:maskLabel.frame.height)
        colorGradientLayer.backgroundColor = UIColor.clear.cgColor
        colorGradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        colorGradientLayer.endPoint   = CGPoint.init(x: 1, y: 0.5)
        colorGradientLayer.colors     = [UIColor.white.cgColor,
                                         UIColor.white.cgColor,
                                         UIColor.white.cgColor]
        colorGradientLayer.locations  = [0.0,
                                         0.5,
                                         1.0]
        
        start3D = CATransform3DMakeTranslation(-10, 0, 1)
        end3D   = CATransform3DMakeTranslation(maskLabel.frame.width, 0, 1)
        
        maskLabel.layer.addSublayer(colorGradientLayer)
        maskLabel.layer.mask = colorGradientLayer
        colorGradientLayer.transform = start3D
        basicAnimator.fromValue = NSValue.init(caTransform3D: start3D)
        basicAnimator.toValue   = NSValue.init(caTransform3D: end3D)
        colorGradientLayer.removeAllAnimations()
        colorGradientLayer.add(basicAnimator, forKey: "animation2")
    }
    
    func animator3() {
//        let thePath = CGMutablePath()
//        thePath.move(to: myView3.frame.origin)
//        /// 创建 立方体贝塞尔曲线 to:结束曲线 control1: 曲线的第一个控制点 control2: 曲线第二个控制点
//        thePath.addCurve(to: CGPoint.init(x: 10, y: 50.0), control1: CGPoint.init(x: 20.0, y: 50.0), control2: CGPoint.init(x: 20.0, y: 10.0))
//        thePath.addCurve(to: CGPoint.init(x: 20.0, y: 50.0), control1: CGPoint.init(x: 60.0, y: 50.0), control2: CGPoint.init(x: 60.0, y: 10.0))
        
        let theAnimator = CAKeyframeAnimation.init(keyPath: "borderWidth")
        let widthValue: [String] = ["1.0",
                                    "10.0","5.0","30.0","0.5","15.0","2.0","50.0","0.0"]
        
        theAnimator.values = widthValue
//        theAnimator.calculationMode = kCAAnimationPaced
        
        let thereAnimator = CAKeyframeAnimation.init(keyPath: "borderColor")
        let thereValue: [CGColor] = [UIColor.green.cgColor,
                                    UIColor.red.cgColor,
                                    UIColor.blue.cgColor]
        
        thereAnimator.values = thereValue
//        thereAnimator.calculationMode = kCAAnimationPaced
        
        let group = CAAnimationGroup()
        group.animations = [theAnimator, thereAnimator]
        group.duration = 5.0

//        theAnimator.calculationMode = kCAAnimationLinear
//        theAnimator.path = thePath
//        theAnimator.duration = 5.0
        myView3.layer.add(group, forKey: "BorderChanges")
    }
    
    
    func animation4() {
        UIView.animate(withDuration: 1, animations: {
            self.myView3.transform = CGAffineTransform.identity
            self.myView3.alpha = 0.5
        }) { (isFinshed) in
            if isFinshed {
                self.myView3.alpha = 0.0
                self.myView3.transform = CGAffineTransform.init(scaleX: 4, y: 4)
                self.animation4()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
