//
//  StateMachineImp.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/25.
//

import Foundation



extension ViewStateMachineProtocol where Self: UIViewController  {
    public var state: ViewState {
        get {
            return self._machineState
        }
        set {
            self.transitionState(old: self._machineState, latest: newValue)
            self._machineState = newValue
        }
    }
    
    func transitionState(old: ViewState , latest: ViewState) {
        old.holderView.removeFromSuperview()
        if latest is ViewNormalState {
            return
        }
        self.view.addSubview(latest.holderView)
        latest.holderView.frame = CGRect.init(origin: .zero, size: self.view.frame.size)
        
        latest.renderView()
    }
}

extension UITableView: ViewStateMachineProtocol {
    public var state: ViewState {
        get {
            return self._machineState
        }
        set {
            self.transitionState(old: self._machineState, latest: newValue)
            self._machineState = newValue
        }
    }
}

///MARK: - private
extension UIViewController {
    
    private struct _ViewStateMachine {
        static var key: String = "_ViewStateMachine"
    }
    
    
    
    fileprivate var _machineState: ViewState {
        set {
            return objc_setAssociatedObject(self, &_ViewStateMachine.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return (objc_getAssociatedObject(self, &_ViewStateMachine.key) as? ViewState) ?? ViewState()
        }
    }
    
}

extension UIView {
    
    private struct _ViewStateMachine {
        static var key: String = "_ViewStateMachine"
    }
    
    
    
    fileprivate var _machineState: ViewState {
        set {
            return objc_setAssociatedObject(self, &_ViewStateMachine.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return (objc_getAssociatedObject(self, &_ViewStateMachine.key) as? ViewState) ?? ViewState()
        }
    }
    
}

extension ViewStateMachineProtocol where Self: UIView {
    
    public var state: ViewState {
        get {
            return self._machineState
        }
        set {
            self.transitionState(old: self._machineState, latest: newValue)
            self._machineState = newValue
        }
    }
    
    func transitionState(old: ViewState , latest: ViewState) {
        old.holderView.removeFromSuperview()
        if latest is ViewNormalState {
            return
        }
        self.addSubview(latest.holderView)
        latest.holderView.frame = CGRect.init(origin: .zero, size: self.frame.size)
        latest.renderView()
        self.equalEdge(to: latest.holderView)
        
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

