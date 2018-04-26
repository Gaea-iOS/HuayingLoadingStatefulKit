//
//  StateMachineInterface.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/25.
//

import Foundation


public typealias VoidCallback = () -> Void

/// 状态机管理加载流程视图的协议
public protocol ViewStateMachineProtocol: class {
    var state: ViewState { get set }
}

/// 加载流程弹窗协议
public protocol DropDownAlertProtocol: class {
    func dropAlert(error: NSError)
}


/// 状态机基类
public class ViewState: NSObject {
    
    /// 正常页面
    public static func normal() -> ViewState {
        return ViewNormalState()
    }
    /// 没有数据的页面 - 参数为空时读配置默认值
    public static func empty(_ toast: String? = nil) -> ViewState{
        return ViewEmptyState(emptyString: toast)
    }
    /// 没有数据的页面加载中页面 - 参数为空时读配置默认值
    public static func loading(_ toast: String? = nil) -> ViewState{
        return ViewLoadingState(loadingString: toast)
    }
    /// 没有数据的错误页面
    public static func error(error: NSError, resume: VoidCallback?) -> ViewState {
        return ViewErrorState(error: error, resume: resume)
    }
    
    
    var holderView: UIView = UIView()
    func renderView() {
        self.holderView.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.holderView.backgroundColor = ViewStateManager.shared.configuration.placeholderBackgroundColor
        self.holderView.addSubview(stack)
        stack.centerEqual(to: self.holderView)
        self.render(with: stack)
        
    }
    
    func render(with stack: UIStackView) {
        
    }
    
}

/// 状态机配置类
public class ViewStateConfiguration {
    
    public init() {
        
    }
    
    
    public var loadingIcon: UIImage = UIImage()
    public var loadingText: String = ""
    public var loadingTextColor: UIColor = UIColor.white
    public var loadingTextFontSize: CGFloat = 11
    
    public var emptyIcon: UIImage = UIImage()
    public var emptyText: String = ""
    public var emptyTextColor: UIColor = UIColor.white
    public var emptyTextFontSize: CGFloat = 11
    
    public var errorLoadingIcon: UIImage = UIImage()
    public var errorRetryButtonBackgroudColor: UIColor = UIColor.white
    public var errorRetryButtonFontSize: CGFloat = 11
    public var errorRetryButtonTitle: String = ""
    public var errorRetryButtonFontColor: UIColor = UIColor.white
    public var errorTextFontSize: CGFloat = 11
    public var errorTextFontColor: UIColor = UIColor.black
    
    public var placeholderBackgroundColor: UIColor = UIColor.white
    
    
    public var webProgressColor: UIColor = .red
    
    public static var `default`: ViewStateConfiguration {
        ///TODO
        return ViewStateConfiguration()
    }
    
}

/// 配置管理类
public class ViewStateManager {
    public static let shared = ViewStateManager()
    private init() {
        
    }
    public private(set) var configuration = ViewStateConfiguration.default
    
    public func loadConfiguration(configuration: ViewStateConfiguration) {
        self.configuration = configuration
    }
}




