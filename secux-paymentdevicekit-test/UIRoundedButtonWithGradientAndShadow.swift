//
//  UIRoundedButtonWithGradientAndShadow.swift
//  FlipRAS
//
//  Created by Maochun Sun on 2019/9/1.
//  Copyright © 2019 Maochun Sun. All rights reserved.
//

import UIKit

class UIRoundedButtonWithGradientAndShadow: UIButton {
    
    let gradientColors : [UIColor]
    let disabledGradientColors = [UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
                                  UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)]
    let startPoint : CGPoint
    let endPoint : CGPoint
    let hasShadow = false
    
    required init(gradientColors: [UIColor],
                  startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                  endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        self.gradientColors = gradientColors
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let halfOfButtonHeight = layer.frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 10, left: halfOfButtonHeight, bottom: 10, right: halfOfButtonHeight)
        
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        backgroundColor = UIColor.clear
        
        // setup gradient
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        
        if self.isEnabled{
            gradient.colors = gradientColors.map { $0.cgColor }
            
        }else{
            gradient.colors = disabledGradientColors.map { $0.cgColor }
        }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = 10 //halfOfButtonHeight
        
        // replace gradient as needed
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, below: nil)
        }
        
        // setup shadow
        if hasShadow{
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: halfOfButtonHeight).cgPath
            layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 2.0
        }
    }
    
    /*
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.clipsToBounds = true  
            self.setBackgroundImage(colorImage, for: state)
        }
    }
    */
    
    override var isEnabled: Bool{
        didSet{
            if isEnabled{
                let gradient: CAGradientLayer = CAGradientLayer()
                gradient.frame = self.bounds
                gradient.colors = gradientColors.map { $0.cgColor }
                gradient.startPoint = startPoint
                gradient.endPoint = endPoint
                gradient.cornerRadius = 10
                
                if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
                    layer.replaceSublayer(oldGradient, with: gradient)
                }
                
            }else{
                let gradient: CAGradientLayer = CAGradientLayer()
                gradient.frame = self.bounds
                gradient.colors = [UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)]
                gradient.startPoint = startPoint
                gradient.endPoint = endPoint
                gradient.cornerRadius = 10
                if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
                    layer.replaceSublayer(oldGradient, with: gradient)
                }
               
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            let newOpacity : Float = isHighlighted ? 0.6 : 0.85
            let newRadius : CGFloat = isHighlighted ? 6.0 : 4.0
            
            if hasShadow{
                let shadowOpacityAnimation = CABasicAnimation()
                shadowOpacityAnimation.keyPath = "shadowOpacity"
                shadowOpacityAnimation.fromValue = layer.shadowOpacity
                shadowOpacityAnimation.toValue = newOpacity
                shadowOpacityAnimation.duration = 0.1
                
                let shadowRadiusAnimation = CABasicAnimation()
                shadowRadiusAnimation.keyPath = "shadowRadius"
                shadowRadiusAnimation.fromValue = layer.shadowRadius
                shadowRadiusAnimation.toValue = newRadius
                shadowRadiusAnimation.duration = 0.1
                
                layer.add(shadowOpacityAnimation, forKey: "shadowOpacity")
                layer.add(shadowRadiusAnimation, forKey: "shadowRadius")
                
                layer.shadowOpacity = newOpacity
            }
            layer.shadowRadius = newRadius
            
            let xScale : CGFloat = isHighlighted ? 1.1 : 1.0 //1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.1 : 1.0//1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
}
