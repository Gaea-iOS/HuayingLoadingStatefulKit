//
//  ViewLoadingState.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/25.
//

import Foundation

public class ViewLoadingState: ViewState {
    var loadingString: String?
    init(loadingString: String?) {
        self.loadingString = loadingString
    }
    var iconView: UIImageView = {
        let view = UIImageView()
        view.image = ViewStateManager.shared.configuration.loadingIcon
        return view
    }()
    
    var loadingLabel : UILabel = {
        let label = UILabel()
        label.textColor = ViewStateManager.shared.configuration.loadingTextColor
        label.font = UIFont.systemFont(ofSize: ViewStateManager.shared.configuration.loadingTextFontSize)
        label.textAlignment = .left
        label.text = ViewStateManager.shared.configuration.loadingText
        return label
    }()
    
    override func render(with stack: UIStackView) {
        super.render(with: stack)
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(loadingLabel)
        if let _ = loadingString , !loadingString!.isEmpty {
            self.loadingLabel.text = loadingString
        }
    }
}

