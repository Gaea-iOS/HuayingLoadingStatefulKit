//
//  ViewEmptyState.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/25.
//

import Foundation

public class ViewEmptyState: ViewState {
    var emptyString: String?
    init(emptyString: String?) {
        self.emptyString = emptyString
    }
    
    var iconView: UIImageView = {
        let view = UIImageView()
        view.image = ViewStateManager.shared.configuration.emptyIcon
        return view
    }()
    
    var emptyLabel : UILabel = {
        let label = UILabel()
        label.textColor = ViewStateManager.shared.configuration.emptyTextColor
        label.font = UIFont.systemFont(ofSize: ViewStateManager.shared.configuration.emptyTextFontSize)
        label.textAlignment = .left
        label.text = ViewStateManager.shared.configuration.emptyText
        return label
    }()
    
    override func render(with stack: UIStackView) {
        super.render(with: stack)
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(emptyLabel)
        if let _ = emptyString , !emptyString!.isEmpty {
            self.emptyLabel.text = emptyString
        }
    }
    
    
}
