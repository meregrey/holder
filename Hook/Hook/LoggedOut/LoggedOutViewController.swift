//
//  LoggedOutViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import AuthenticationServices
import RIBs
import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    func didSucceedLogin(withCredential credential: Credential)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private enum Metric {
        static let loginButtonWidthMultiplier = CGFloat(0.8)
        static let loginButtonHeight = CGFloat(50)
        static let loginButtonBottom = CGFloat(-180)
    }

    weak var listener: LoggedOutPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        configureLoginButton()
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Metric.loginButtonWidthMultiplier),
            stackView.heightAnchor.constraint(equalToConstant: Metric.loginButtonHeight),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.loginButtonBottom)
        ])
    }
    
    private func configureLoginButton() {
        let loginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        loginButton.cornerRadius = Metric.loginButtonHeight
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        stackView.addArrangedSubview(loginButton)
    }
    
    @objc
    private func loginButtonDidTap() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LoggedOutViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let authorizationCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let name = authorizationCredential.fullName.map({ PersonNameComponentsFormatter.localizedString(from: $0, style: .default) }) else { return }
        let credential = Credential(identifier: authorizationCredential.user, name: name)
        listener?.didSucceedLogin(withCredential: credential)
    }
}

extension LoggedOutViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
