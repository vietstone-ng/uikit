//
//  CustomTabBarVC.swift
//  CustomTabBar
//
//  Created by Viet Nguyen Tran on 22/08/2023.
//

import UIKit

class CustomTabBarVC: UIViewController {
    @IBOutlet var tab0: CustomTab!
    @IBOutlet var tab1: CustomTab!
    @IBOutlet var tab2: CustomTab!
    @IBOutlet var tab3: CustomTab!
    
    @IBOutlet var vcContainerView: UIView!
    
    private lazy var tabs = [tab0, tab1, tab2, tab3]
    
    private(set) var viewControllers: [UIViewController] = [] {
        didSet {
            // review old
            oldValue.forEach {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
            
            // add new
            viewControllers.forEach {
                self.addChild($0)
                $0.view.frame = vcContainerView.bounds
                $0.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                vcContainerView.addSubview($0.view)
                $0.didMove(toParent: self)
            }
        }
    }
    
    var selectedIndex: Int = -1 {
        didSet {
            guard selectedIndex != oldValue else { return }
            
            tabs.forEach { $0?.isSelected = false }
            tabs[selectedIndex]?.isSelected = true
            
            viewControllers.forEach { $0.view.isHidden = true }
            viewControllers[selectedIndex].view.isHidden = false
        }
    }
    
    static func new() -> CustomTabBarVC {
        let vc = CustomTabBarVC()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        assert(viewControllers.count == 4)
        self.viewControllers = viewControllers
        selectedIndex = 0
    }
    
    private func setup() {
        tabs.forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnTab(_:)))
            $0?.addGestureRecognizer(tap)
        }
    }
    
    @objc func tapOnTab(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? CustomTab,
              let index = tabs.firstIndex(of: view)
        else { return }
        selectedIndex = index
    }
}

@IBDesignable
class CustomTabBarBgView: UIView {
    @IBInspectable
    var holeRadius: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 16 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var fillColor: UIColor = .systemGreen {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .init(arrayLiteral: [.topLeft, .topRight]), cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        fillColor.setFill()
        path.fill()
        
        let holeRect = CGRect(x: rect.midX - holeRadius, y: 0 - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
        let holePath = UIBezierPath(ovalIn: holeRect)
        
        UIColor.black.setFill()
        holePath.fill()
    }
}

@IBDesignable
class CustomTab: UIView {
    @IBInspectable
    var imageName: String = "house.fill" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let selectedColor = UIColor.white
        let unselectedColor = UIColor.white.withAlphaComponent(0.5)
        let color = isSelected ? selectedColor : unselectedColor
        
        // image
        let config = UIImage.SymbolConfiguration(pointSize: 22)
        if let image = UIImage(systemName: imageName, withConfiguration: config)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
        {
            let imageSize = image.size
            image.draw(at: CGPoint(x: CGRectGetMidX(rect) - imageSize.width / 2, y: 40 - imageSize.height / 2))
        }
        
        // indicator
        if isSelected {
            let indicatorRect = CGRect(x: 4, y: 0, width: rect.width - 8, height: 4)
            let indicatorPath = UIBezierPath(roundedRect: indicatorRect, cornerRadius: 2)
            color.setFill()
            indicatorPath.fill()
        }
    }
}
