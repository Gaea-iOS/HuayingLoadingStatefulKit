//
//  DropAlertView.swift
//  FBSnapshotTestCase
//
//  Created by lzc1104 on 2018/4/26.
//

import Foundation

extension DropDownAlertProtocol where Self: UIViewController {
    
    private var dropTag: Int {
        return 1008610000
    }
    
    public func dropAlert(error: NSError) {
        
        let previousAlert = self.view.viewWithTag(self.dropTag)
        
        let sheet = DropdownView.Sheet.sheet(for: self)
        let alertView = DropdownView(sheet: sheet,desc: error.localizedDescription)
        let offsetY = DropdownView.Sheet.offsetY(for: self)
        alertView.tag = self.dropTag
        print(alertView)
        self.view.addSubview(alertView)
        
        let cons1 = NSLayoutConstraint.init(item: alertView,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: offsetY)
        self.view.addConstraint(cons1)
        alertView.transform = CGAffineTransform.init(translationX: 0, y: -sheet.height)
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            alertView.transform = CGAffineTransform.identity
        }, completion: { _ in
            previousAlert?.removeFromSuperview()
            UIView.animateKeyframes(withDuration: 0.5, delay: 1.5, animations: {
                alertView.transform = CGAffineTransform.init(translationX: 0, y: -sheet.height)
            }, completion: { (_) in
                alertView.removeFromSuperview()
            })
            
        })
    }
}

class DropdownView: UIView {
    
    enum Sheet {
        case withNavigationBar
        case withoutNavigationBar
        case withoutNavigationBarAndiPoneX
        
        static func sheet(for viewcontroller: UIViewController) -> Sheet {
            if let _ = viewcontroller.navigationController ,
                !viewcontroller.navigationController!.isNavigationBarHidden {
                return .withNavigationBar
                
            } else {
                if isiPhoneX() {
                    return .withoutNavigationBarAndiPoneX
                } else {
                    return .withoutNavigationBar
                }
            }
        }
        
        static func offsetY(for viewcontroller: UIViewController) -> CGFloat {
            if let _ = viewcontroller.navigationController ,
                !viewcontroller.navigationController!.isNavigationBarHidden,
                viewcontroller.navigationController!.navigationBar.isTranslucent {
                return isiPhoneX() ? 84: 64
                
            } else {
                return 0
            }
        }
        
        var height: CGFloat {
            switch self {
            case .withNavigationBar:
                return 40
            case .withoutNavigationBar:
                return 64
            case .withoutNavigationBarAndiPoneX:
                return 84
            }
        }
        
    }
    private var sheet: Sheet
    private var desc: String
    //MARK: -Override Intializer
    init(sheet: Sheet, desc: String) {
        self.sheet = sheet
        self.desc = desc
        super.init(frame: CGRect.zero)
        self._initialSubViews()
        self._layoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Private Layout
    private func _initialSubViews() {
        self.backgroundColor = UIColor.init(hex: 0xFBF8E3, alpha: 1)
        self.titleLabel.text = self.desc
        let image = UIImage.init(pkName: "icon_server")
        self.imageView.image = image
    }
    
    private func _layoutConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        do {
            let cons1 = NSLayoutConstraint.init(item: self.imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 14)
            let cons2 = NSLayoutConstraint.init(item: self.imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10)
            self.addConstraints([cons1,cons2])
            
            let cons3 = NSLayoutConstraint.init(item: self.imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            let cons4 = NSLayoutConstraint.init(item: self.imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            
            self.addConstraint(cons3)
            self.addConstraint(cons4)
            
        }
        
        do {
            let cons1 = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.imageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 10)
            let cons2 = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 5)
            let cons3 = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.imageView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            self.addConstraints([cons1,cons2,cons3])
        }
        
        switch self.sheet {
            
        case .withNavigationBar:
            let cons1 = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            self.addConstraint(cons1)
        case .withoutNavigationBar:
            let cons1 = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
            self.addConstraint(cons1)
        case .withoutNavigationBarAndiPoneX:
            let cons1 = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 84)
            self.addConstraint(cons1)
        }
        
        let widthCons = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)
        self.addConstraint(widthCons)
        
        do {
            let sep = UIView()
            sep.translatesAutoresizingMaskIntoConstraints = false
            sep.backgroundColor = UIColor.init(hex: 0xdddddd, alpha: 1)
            self.addSubview(sep)
            self.equalAttribute(to: sep, attribute: NSLayoutAttribute.left)
                .equalAttribute(to: sep, attribute: NSLayoutAttribute.right)
                .equalAttribute(to: sep, attribute: NSLayoutAttribute.bottom)
            sep.heightCons(0.5)
            
        }
    }
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    var imageView: UIImageView = UIImageView(image: UIImage.init(pkName: "icon_server"))
}

