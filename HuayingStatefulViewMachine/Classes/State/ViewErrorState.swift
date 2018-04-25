//
//  ViewErrorState.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/25.
//

import Foundation

public class ViewErrorState: ViewState {
    var error: NSError
    var callback: VoidCallback?
    
    public init(error: NSError, resume: VoidCallback?) {
        self.error = error
        self.callback = resume
    }
    
    override func render(with stack: UIStackView) {
        super.render(with: stack)
        self.holderView.backgroundColor = .white
        
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(errorLabel)
        stack.addArrangedSubview(retryButton)
        
        
        self.errorLabel.text = self.error.localizedDescription
        self.retryButton.addTarget(self, action: #selector(onErrorRetry), for: UIControlEvents.touchUpInside)
    }
    
    var iconView: UIImageView = {
        let view = UIImageView()
        view.image = ViewStateManager.shared.configuration.errorLoadingIcon
        return view
    }()
    
    var errorLabel : UILabel = {
        let label = UILabel()
        label.textColor = ViewStateManager.shared.configuration.errorTextFontColor
        label.font = UIFont.systemFont(ofSize: ViewStateManager.shared.configuration.errorTextFontSize)
        label.textAlignment = .left
        return label
    }()
    
    var retryButton : UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle(ViewStateManager.shared.configuration.errorRetryButtonTitle, for: .normal)
        button.setTitleColor(ViewStateManager.shared.configuration.errorRetryButtonFontColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: ViewStateManager.shared.configuration.errorTextFontSize)
        button.backgroundColor = ViewStateManager.shared.configuration.errorRetryButtonBackgroudColor
        button.heightCons(30)
            .widthCons(90)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        
        
        return button
    }()
    
    @objc func onErrorRetry() {
        self.callback?()
    }
    
}


