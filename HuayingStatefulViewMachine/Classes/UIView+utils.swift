//
//  UIView+utils.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/26.
//

import Foundation


extension UIColor {
    convenience init(hex : Int , alpha : CGFloat) {
        let r = CGFloat((hex >> 16) & 0xff) / 255.0
        let g = CGFloat(hex >> 8 & 0xff) / 255.0
        let b = CGFloat(hex & 0xff) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIImage {
    convenience init?(pkName: String) {
        self.init(named: pkName, in: Bundle.privateBd, compatibleWith: nil)
    }
}

extension Bundle {
    private class _PrivateClass {
        
    }
    
    static var privateBd: Bundle {
        let pbd = Bundle.init(for: _PrivateClass.self)
        let url = pbd.url(forResource: "HuayingStatefulViewMachine", withExtension: "bundle")
        let bd = Bundle.init(url: url!)
        return bd!
    }
}

extension UIView {
    
    
    @discardableResult
    func centerEqual(to target: UIView) -> UIView {
        let constraint = NSLayoutConstraint.init(
            item: self,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: target,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1,
            constant: 0
        )
        
        let constraint1 = NSLayoutConstraint.init(
            item: self,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: target,
            attribute: NSLayoutAttribute.centerY,
            multiplier: 1,
            constant: 0
        )
        target.addConstraints([constraint] + [constraint1])
        return target
        
    }
    
    @discardableResult
    func heightCons(_ constant: CGFloat) -> UIView {
        let heightConstraint = NSLayoutConstraint.init(
            item: self,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: constant
        )
        self.addConstraint(heightConstraint)
        return self
    }
    @discardableResult
    func widthCons(_ constant: CGFloat) -> UIView {
        let heightConstraint = NSLayoutConstraint.init(
            item: self,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: constant
        )
        self.addConstraint(heightConstraint)
        return self
    }
    @discardableResult
    func equalAttribute(to target: UIView , attribute: NSLayoutAttribute) -> UIView {
        let cons = NSLayoutConstraint.init(
            item: self,
            attribute: attribute,
            relatedBy: NSLayoutRelation.equal,
            toItem: target,
            attribute: attribute,
            multiplier: 1,
            constant: 0
        )
        self.addConstraint(cons)
        return self
    }
    @discardableResult
    func equalEdge(to target: UIView) -> UIView {
        return self.equalAttribute(to: target, attribute: NSLayoutAttribute.leading)
            .equalAttribute(to: target, attribute: NSLayoutAttribute.trailing)
            .equalAttribute(to: target, attribute: NSLayoutAttribute.top)
            .equalAttribute(to: target, attribute: NSLayoutAttribute.bottom)
    }
    
}

let _isiPoneX: Bool = UIScreen.main.bounds.height == 812
func isiPhoneX() -> Bool {
    return _isiPoneX
}

