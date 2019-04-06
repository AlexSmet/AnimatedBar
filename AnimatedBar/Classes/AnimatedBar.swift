//
//  AnimatedBar.swift
//
//  Created by Alexander Smetannikov on 27/07/2018.
//  Copyright © 2018 AlexSmetannikov. All rights reserved.
//

import UIKit


/// Анимированный прогрессбар с градиентным заполнением
public class AnimatedBar: UIView, CAAnimationDelegate {
    /// Цвета для построения градиента, необходимо минимум два цвета
    public var barColors: [UIColor] {
        get { return gradientLayer.barColors.map { UIColor(cgColor: $0) } }
        set { gradientLayer.barColors = newValue.map { $0.cgColor } }
    }

    /// Цвет границы, необязательный параметр
    public var borderColor: UIColor? {
        get { return gradientLayer.aBorderColor == nil ? nil: UIColor(cgColor: gradientLayer.aBorderColor!) }
        set { gradientLayer.aBorderColor = newValue?.cgColor }
    }

    /// Ширина границы
    public var borderWidth: CGFloat {
        get { return gradientLayer.aBorderWidth }
        set { gradientLayer.aBorderWidth = newValue }
    }

    /// Угол наклона правой части прогрессбара, в градусах
    public var barTipAngle: CGFloat {
        get { return gradientLayer.barTipAngle }
        set { gradientLayer.barTipAngle = newValue }
    }

    @objc dynamic private var progress: CGFloat = 0.0 {
        didSet {
            gradientLayer.progress = progress
        }
    }

    /// Устанавливает заполненность индикатора
    /// - Parameters:
    ///   - progress: значение заполненности индикатора от 0 до 1
    ///   - withDuration: длительность анимации
    ///   - completion: необязательный параметр, функция которая будет вызвана после окончания анимации
    public func setPosition(_ position: CGFloat, withDuration animationDuration: Double, completion: ((Bool) -> Void)? = nil) {
        if animationDuration > 0 {
            onAnimationCompletion = completion
            let animation = CABasicAnimation(keyPath: "progress")
            animation.fromValue = CGFloat(0.0)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation.toValue = position
            animation.duration = animationDuration
            animation.delegate = self
            layer.add(animation, forKey: "progress")
            gradientLayer.progress = position
        } else {
            gradientLayer.progress = position
            completion?(true)
        }

    }

    override public class var layerClass: AnyClass {
        return GradientLayer.self
    }

    private var gradientLayer: GradientLayer {
        return self.layer as! GradientLayer
    }

    private var onAnimationCompletion: ((Bool) -> Void)?

    public func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        guard finished else {
            return
        }
        onAnimationCompletion?(finished)
    }

    override public var frame: CGRect {
        didSet {
            layer.setNeedsDisplay()
        }
    }
}

private class GradientLayer: CAShapeLayer {
    var barTipAngle: CGFloat = 60
    @NSManaged var barColors: [CGColor]
    @NSManaged var progress: CGFloat
    @NSManaged var aBorderColor: CGColor?
    @NSManaged var aBorderWidth: CGFloat

    private var gradientTailLength: CGFloat {
        return bounds.height / tan(barTipAngle * CGFloat.pi / 180)
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "progress" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        UIGraphicsPushContext(ctx)

        var tailLength = gradientTailLength
        if progress == 0 || progress == 1 {
            tailLength = 0
        }

        let progressLength = bounds.width * progress
        let width = bounds.width
        let height = bounds.height

        // Draw border
        if let borderColor1 = aBorderColor {
            let borderPath = UIBezierPath()
            UIColor(cgColor: borderColor1).setStroke()
            borderPath.lineWidth = aBorderWidth
            let borderWidth2 = aBorderWidth / 2
            if progress == 0 {
                borderPath.move(to: CGPoint(x: progressLength - tailLength + borderWidth2, y: height - borderWidth2))
                borderPath.addLine(to: CGPoint(x: progressLength - tailLength + borderWidth2, y: borderWidth2))
            } else {
                borderPath.move(to: CGPoint(x: progressLength - tailLength, y: borderWidth2))
            }
            borderPath.addLine(to: CGPoint(x: width - borderWidth2, y: borderWidth2))
            borderPath.addLine(to: CGPoint(x: width - borderWidth2, y: height - borderWidth2))
            borderPath.addLine(to: CGPoint(x: progressLength - borderWidth2, y: height - borderWidth2))
            borderPath.stroke()
            borderPath.close()
        }

        // Draw gradient
        let gradientPath = UIBezierPath()
        gradientPath.move(to: CGPoint(x: 0, y: 0))
        gradientPath.addLine(to: CGPoint(x: progressLength - tailLength, y: 0))
        gradientPath.addLine(to: CGPoint(x: progressLength, y: height))
        gradientPath.addLine(to: CGPoint(x: 0, y: height))
        gradientPath.addLine(to: CGPoint(x: 0, y: 0))
        gradientPath.addClip()
        gradientPath.close()

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var colorLocations: [CGFloat] = Array(repeating: 0, count: barColors.count)
        let space: CGFloat = 1 / CGFloat(colorLocations.count - 1)
        for i in 1..<colorLocations.count - 1 {
            colorLocations[i] = space * CGFloat(i)
        }
        colorLocations[colorLocations.count - 1] = 1

        let gradient = CGGradient(colorsSpace: colorSpace, colors: barColors as CFArray, locations: colorLocations)!

        ctx.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: bounds.width * progress, y: 0), options: [])

        UIGraphicsPopContext()
    }
}
