//
//  EnableSharingViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/05/12.
//

import UIKit

final class EnableSharingViewController: UIViewController {
    
    @AutoLayout private var scrollView = UIScrollView()
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = Font.explanationLabel
        label.textColor = Asset.Color.primaryColor
        label.numberOfLines = 0
        return label
    }()
    
    @AutoLayout private var firstStepLabel: UILabel = {
        let label = UILabel()
        label.font = Font.stepLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var firstStepImageView: UIImageView = {
        let imageView = UIImageView(image: Image.firstStepImageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @AutoLayout private var secondStepLabel: UILabel = {
        let label = UILabel()
        label.font = Font.stepLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var secondStepImageView: UIImageView = {
        let imageView = UIImageView(image: Image.secondStepImageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @AutoLayout private var thirdStepLabel: UILabel = {
        let label = UILabel()
        label.font = Font.stepLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var thirdStepImageView: UIImageView = {
        let imageView = UIImageView(image: Image.thirdStepImageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @AutoLayout private var fourthStepLabel: UILabel = {
        let label = UILabel()
        label.font = Font.stepLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var fourthStepImageView: UIImageView = {
        let imageView = UIImageView(image: Image.fourthStepImageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 26, weight: .bold)
        static let explanationLabel = UIFont.systemFont(ofSize: 17)
        static let stepLabel = UIFont.systemFont(ofSize: 17)
    }
    
    private enum Image {
        static let backButton = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        static let firstStepImageView = UIImage(named: "EnableSharing1")
        static let secondStepImageView = UIImage(named: "EnableSharing2")
        static let thirdStepImageView = UIImage(named: "EnableSharing3")
        static let fourthStepImageView = UIImage(named: "EnableSharing4")
    }
    
    private enum Metric {
        static let titleLabelTop = CGFloat(60)
        static let explanationLabelTop = CGFloat(20)
        static let stepLabelTop = CGFloat(60)
        static let stepImageViewTop = CGFloat(15)
        static let leading = CGFloat(20)
        static let trailing = CGFloat(-20)
        static let bottom = CGFloat(-20)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViews() {
        titleLabel.text = LocalizedString.LabelText.enableSharing
        explanationLabel.attributedText = explanationLabelAttributedText(explanation: LocalizedString.LabelText.enableSharingExplanation)
        firstStepLabel.text = LocalizedString.LabelText.enableSharingFirstStep
        secondStepLabel.text = LocalizedString.LabelText.enableSharingSecondStep
        thirdStepLabel.text = LocalizedString.LabelText.enableSharingThirdStep
        fourthStepLabel.text = LocalizedString.LabelText.enableSharingFourthStep
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.backButton, style: .done, target: self, action: #selector(backButtonDidTap))
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.detailBackgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(explanationLabel)
        scrollView.addSubview(firstStepLabel)
        scrollView.addSubview(firstStepImageView)
        scrollView.addSubview(secondStepLabel)
        scrollView.addSubview(secondStepImageView)
        scrollView.addSubview(thirdStepLabel)
        scrollView.addSubview(thirdStepImageView)
        scrollView.addSubview(fourthStepLabel)
        scrollView.addSubview(fourthStepImageView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Metric.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.leading),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.trailing),
            
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metric.explanationLabelTop),
            explanationLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.leading),
            explanationLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.trailing),
            
            firstStepLabel.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: Metric.stepLabelTop),
            firstStepLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.leading),
            firstStepLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.trailing),
            
            firstStepImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.4),
            firstStepImageView.topAnchor.constraint(equalTo: firstStepLabel.bottomAnchor, constant: Metric.stepImageViewTop),
            firstStepImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            firstStepImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            secondStepLabel.topAnchor.constraint(equalTo: firstStepImageView.bottomAnchor, constant: Metric.stepLabelTop),
            secondStepLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.leading),
            secondStepLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.trailing),
            
            secondStepImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.75),
            secondStepImageView.topAnchor.constraint(equalTo: secondStepLabel.bottomAnchor, constant: Metric.stepImageViewTop),
            secondStepImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            secondStepImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            thirdStepLabel.topAnchor.constraint(equalTo: secondStepImageView.bottomAnchor, constant: Metric.stepLabelTop),
            thirdStepLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.leading),
            thirdStepLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.trailing),
            
            thirdStepImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.75),
            thirdStepImageView.topAnchor.constraint(equalTo: thirdStepLabel.bottomAnchor, constant: Metric.stepImageViewTop),
            thirdStepImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            thirdStepImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            fourthStepLabel.topAnchor.constraint(equalTo: thirdStepImageView.bottomAnchor, constant: Metric.stepLabelTop),
            fourthStepLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.leading),
            fourthStepLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.trailing),
            
            fourthStepImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.75),
            fourthStepImageView.topAnchor.constraint(equalTo: fourthStepLabel.bottomAnchor, constant: Metric.stepImageViewTop),
            fourthStepImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            fourthStepImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            fourthStepImageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: Metric.bottom)
        ])
    }
    
    private func explanationLabelAttributedText(explanation: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        return NSAttributedString(string: explanation, attributes: [.paragraphStyle: paragraphStyle])
    }
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}
