//
//  CircleProgressBar.swift
//  AuctionGame
//
//  Created by Developer on 12.09.2020.


import UIKit

@IBDesignable
class CircleProgressBar: UIView {
    
    @IBInspectable var progress: CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var titleColor: UIColor = UIColor.black
    @IBInspectable var showTitle: Bool = true
    
    private var startAngle = CGFloat(-90 * Double.pi / 180)
    private var endAngle = CGFloat(270 * Double.pi / 180)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        // General Declarations
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Error getting context")
            return
        }
        
        // Color Declarations
        var progressColor = UIColor.blue
        if let g_tint = tintColor
        {
            progressColor = g_tint
        }
        let progressBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        
        // Shadow Declarations
        let innerShadow = UIColor.black.withAlphaComponent(0.22)
        let innerShadowOffset = CGSize(width: 3.1, height: 3.1)
        let innerShadowBlurRadius = CGFloat(4)
        
        // Background Drawing
        let backgroundPath = UIBezierPath(ovalIn: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height))
        backgroundColor?.setFill()
        backgroundPath.fill()
        
        // Background Inner Shadow
        context.saveGState();
        UIRectClip(backgroundPath.bounds);
        context.setShadow(offset: CGSize.zero, blur: 0, color: nil);
        
        context.setAlpha(innerShadow.cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let opaqueShadow = innerShadow.withAlphaComponent(1)
        context.setShadow(offset: innerShadowOffset, blur: innerShadowBlurRadius, color: opaqueShadow.cgColor)
        context.setBlendMode(CGBlendMode.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        opaqueShadow.setFill()
        backgroundPath.fill()
        context.endTransparencyLayer();
        
        context.endTransparencyLayer();
        context.restoreGState();
        
        // ProgressBackground Drawing
        let kMFPadding = CGFloat(15)
        
        let progressBackgroundPath = UIBezierPath(ovalIn: CGRect(x: rect.minX + kMFPadding/2, y: rect.minY + kMFPadding/2, width: rect.size.width - kMFPadding, height: rect.size.height - kMFPadding))
        progressBackgroundColor.setStroke()
        progressBackgroundPath.lineWidth = 5
        progressBackgroundPath.stroke()
        
        // Progress Drawing
        let progressRect = CGRect(x: rect.minX + kMFPadding/2, y: rect.minY + kMFPadding/2, width: rect.size.width - kMFPadding, height: rect.size.height - kMFPadding)
        let progressPath = UIBezierPath()
        progressPath.addArc(withCenter: CGPoint(x: progressRect.midX, y: progressRect.midY), radius: progressRect.width / 2, startAngle: startAngle, endAngle: (endAngle - startAngle) * (progress / 100) + startAngle, clockwise: true)
        progressColor.setStroke()
        progressPath.lineWidth = 4
        progressPath.lineCapStyle = CGLineCap.round
        progressPath.stroke()
        
        // Text Drawing
        if (showTitle)
        {
            let textRect = CGRect(x: rect.minX, y: rect.minY, width: rect.size.width, height: rect.size.height)
            let textContent = NSString(string: "\(Int(progress))")
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = .center
            
            let textFontAttributes = [
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: rect.width / 3)!,
                NSAttributedString.Key.foregroundColor: titleColor,
                NSAttributedString.Key.paragraphStyle: textStyle]
            
            let textHeight = textContent.boundingRect(with: CGSize(width: textRect.width, height: textRect.height), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
            
            context.saveGState()
            context.clip(to: textRect)
            textContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textHeight) / 2, width: textRect.width, height: textHeight), withAttributes: textFontAttributes)
            context.restoreGState();
        }
    }
    
    func setProgressAnimated(_ new_progress: CGFloat, animationInterval: TimeInterval, animationSteps: Int)
    {
        var delta = new_progress - progress
        delta = abs(delta) / CGFloat(animationSteps)
        let animStepInterval: TimeInterval = animationInterval / Double(animationSteps)
        var userInfo: [String: Any] = [:]
        userInfo["begin"] = progress
        userInfo["end"] = new_progress
        userInfo["delta"] = delta
        userInfo["stockTag"] = tag
        self.tag = Int(progress)
        Timer.scheduledTimer(timeInterval: animStepInterval, target: self, selector: #selector(progressEditTick), userInfo: userInfo, repeats: true)
    }
    
    @objc fileprivate func progressEditTick(_ timer: Timer)
    {
        let data: [String: Any] = timer.userInfo as? [String: Any] ?? [:]
        let begin: CGFloat = data["begin"] as? CGFloat ?? 0.0
        let end: CGFloat = data["end"] as? CGFloat ?? 0.0
        var delta: CGFloat = data["delta"] as? CGFloat ?? 0.0
        if (delta == 0.0)
        {
            delta = 1.0
        }
        var currValue: CGFloat = CGFloat(self.tag)
        
        let plus = end > begin
        if (plus)
        {
            currValue += delta
        }
        else
        {
            currValue -= delta
        }
        self.tag = Int(currValue)
        progress = currValue
        if ((plus && currValue >= end) || (!plus && currValue <= end))
        {
            progress = end
            self.tag = data["stockTag"] as? Int ?? 0
            timer.invalidate()
        }
    }
}
