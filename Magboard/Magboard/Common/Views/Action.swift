//
//  Action.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/14.
//

import UIKit

protocol ActionListener: AnyObject {
    func dismiss()
}

final class Action: UIButton {
    
    typealias Handler = () -> Void
    
    var handler: Handler
    weak var listener: ActionListener?
    
    init(title: String, handler: @escaping Handler) {
        self.handler = handler
        super.init(frame: .zero)
        configure(with: title)
    }
    
    required init?(coder: NSCoder) {
        self.handler = {}
        super.init(coder: coder)
        configure(with: "")
    }
    
    private func configure(with title: String) {
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        setTitle(title, for: .normal)
        setTitleColor(Asset.Color.primaryColor, for: .normal)
        addTarget(nil, action: #selector(executeHandler), for: .touchUpInside)
    }
    
    @objc
    private func executeHandler() {
        handler()
        listener?.dismiss()
    }
}
