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

    weak var listener: LoggedOutPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        configureLoginButton()
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Size.Multiplier.containerWidth),
            stackView.heightAnchor.constraint(equalToConstant: Size.Constant.heightforLoginButton),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Size.Constant.bottomForLoginButton)
        ])
    }
    
    private func configureLoginButton() {
        let loginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        loginButton.cornerRadius = Size.Constant.heightforLoginButton
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        stackView.addArrangedSubview(loginButton)
    }
    
    @objc private func loginButtonDidTap() {
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
