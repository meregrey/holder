//
//  SheetController.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/15.
//

import UIKit

class SheetController: UIViewController {
    
    var actions: [Action] = [] {
        didSet {
            containerViewHeight = containerViewHeight(with: actions)
            containerViewHeightConstraint.constant = containerViewHeight
            containerViewBottomConstraint.constant = containerViewHeight
            actions.forEach { stackView.addArrangedSubview($0) }
        }
    }
    
    var handlerToDisappear: () -> Void = {}
    
    @AutoLayout private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView(cornerRadius: 20)
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        return view
    }()
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private var containerViewHeight = CGFloat(0)
    
    private lazy var containerViewHeightConstraint = NSLayoutConstraint(item: containerView,
                                                                        attribute: .height,
                                                                        relatedBy: .equal,
                                                                        toItem: nil,
                                                                        attribute: .notAnAttribute,
                                                                        multiplier: 1,
                                                                        constant: 0)
    
    private lazy var containerViewBottomConstraint = NSLayoutConstraint(item: containerView,
                                                                        attribute: .bottom,
                                                                        relatedBy: .equal,
                                                                        toItem: view,
                                                                        attribute: .bottom,
                                                                        multiplier: 1,
                                                                        constant: 0)
    
    private enum Metric {
        static let stackViewTop = CGFloat(24)
        static let stackViewLeading = CGFloat(24)
        static let stackViewTrailing = CGFloat(-24)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToPresent()
    }
    
    func prepareToDisappear() {
        backgroundView.alpha = 0
        containerViewBottomConstraint.constant = containerViewHeight
    }
    
    func hideContainerView(_ completion: @escaping () -> Void) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.containerViewBottomConstraint.constant = self.containerViewHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
    
    private func configureViews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerViewHeightConstraint.isActive = true
        containerViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.stackViewTrailing)
        ])
    }
    
    private func containerViewHeight(with actions: [Action]) -> CGFloat {
        let actionHeight = 33
        let spacing = 12
        let count = actions.count
        let containerViewHeight = actionHeight * count + spacing * (count - 1) + 92
        return CGFloat(containerViewHeight)
    }
    
    private func animateToPresent() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.backgroundView.alpha = 0.7
            self.containerViewBottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func backgroundViewDidTap() {
        handlerToDisappear()
    }
}
