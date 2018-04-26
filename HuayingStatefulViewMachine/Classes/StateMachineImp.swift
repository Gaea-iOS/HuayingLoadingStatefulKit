//
//  StateMachineImp.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/25.
//

import Foundation

extension ViewStateMachineProtocol {
    func transitionState(old: ViewState , latest: ViewState, targetView: UIView) {
        old.holderView.removeFromSuperview()
        if latest is ViewNormalState {
            return
        }
        targetView.addSubview(latest.holderView)
        latest.holderView.frame = CGRect.init(origin: .zero, size: targetView.frame.size)
        targetView.equalEdge(to: latest.holderView)
        latest.renderView()
    }
}

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
        self.transitionState(old: old, latest: latest, targetView: self.view)
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
        self.transitionState(old: old, latest: latest, targetView: self)
        
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



