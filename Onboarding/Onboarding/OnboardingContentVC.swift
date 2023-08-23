//
//  OnboardingContentVC.swift
//  Onboarding
//
//  Created by Viet Nguyen Tran on 22/08/2023.
//

import UIKit

class OnboardingContentVC: UIViewController {
    
    struct ViewModel {
        let imageName: String
        let title: String
        let titleAlignment: NSTextAlignment
        let description: String
        let nextBtTitle: String
        let onNext: (() -> Void)?
    }
    
    private var viewModel: ViewModel!
    
    init(viewModel: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nextBt: UIButton!
    @IBOutlet weak var descriptionLb: UILabel!
    
    private var onNext: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    @IBAction func onNext(_ sender: Any) {
        onNext?()
    }
    
    func setup() {
        titleLb.text = viewModel.title
        titleLb.textAlignment = viewModel.titleAlignment
        descriptionLb.text = viewModel.description
        imgView.image = UIImage(named: viewModel.imageName)
        nextBt.setTitle(viewModel.nextBtTitle, for: .normal)
        onNext = viewModel.onNext
    }
}
