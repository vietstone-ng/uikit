//
//  OnboardingVC.swift
//  Onboarding
//
//  Created by Viet Nguyen Tran on 22/08/2023.
//

import UIKit

// Use UiPageViewController to create onboarding screen
class OnboardingVC: UIPageViewController {
    var pages = [UIViewController]()

    let skipButton = UIButton()
    let pageControl = UIPageControl() // not part of underlying pages
    let initialPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
    
    static func new() -> OnboardingVC {
        return OnboardingVC(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
}

private extension OnboardingVC {
    func setup() {
        dataSource = self
        delegate = self
        
        let page1 = OnboardingContentVC(viewModel: .init(imageName: "onboarding_1", title: "Track daily weight", titleAlignment: .left, description: "This weight loss tracker will assist you in weight control and help you to lose weight.", nextBtTitle: "Continue", onNext: { [unowned self] in
            self.goToNextPage()
        }))
        
        let page2 = OnboardingContentVC(viewModel: .init(imageName: "onboarding_2", title: "Set weight goal", titleAlignment: .left, description: "Set a desired weight and follow your progress or reach your weight goal.", nextBtTitle: "Continue", onNext: { [unowned self] in
            self.goToNextPage()
        }))
        
        let page3 = OnboardingContentVC(viewModel: .init(imageName: "onboarding_3", title: "Weight chart", titleAlignment: .center, description: "You will have your weight height always at a glance with our beautiful chart.", nextBtTitle: "GET STARTED", onNext: { [unowned self] in
            
        }))
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .green
        pageControl.pageIndicatorTintColor = .gray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage

        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}

// MARK: - DataSource

extension OnboardingVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex > 0 {
            return pages[currentIndex - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

// MARK: - Delegate

extension OnboardingVC: UIPageViewControllerDelegate {
    // Keep pageControl in sync with viewControllers
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
            guard let currentVC = pageViewController.viewControllers?.first else { return }
            guard let currentIndex = pages.firstIndex(of: currentVC) else { return }
            
            pageControl.currentPage = currentIndex
            updateControls()
        }
}

// MARK: - Actions

extension OnboardingVC {
    func goToNextPage() {
        guard let currentVC = viewControllers?.first,
              let nextVC = pageViewController(self, viewControllerAfter: currentVC)
        else {
            return
        }
        
        setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage += 1
        updateControls()
    }
    
    @objc func skipTapped(_ sender: UIButton) {}
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        updateControls()
    }
    
    func updateControls() {
        let lastPage = pageControl.currentPage == pages.count - 1
        
        skipButton.isHidden = lastPage
    }
}
