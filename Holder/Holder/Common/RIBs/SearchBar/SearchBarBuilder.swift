//
//  SearchBarBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs

protocol SearchBarDependency: Dependency {
    var searchTermStream: MutableStream<String> { get }
}

final class SearchBarComponent: Component<SearchBarDependency>, SearchBarInteractorDependency {
    
    var searchTermStream: MutableStream<String> { dependency.searchTermStream }
}

// MARK: - Builder

protocol SearchBarBuildable: Buildable {
    func build(withListener listener: SearchBarListener) -> SearchBarRouting
}

final class SearchBarBuilder: Builder<SearchBarDependency>, SearchBarBuildable {
    
    override init(dependency: SearchBarDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: SearchBarListener) -> SearchBarRouting {
        let component = SearchBarComponent(dependency: dependency)
        let viewController = SearchBarViewController()
        let interactor = SearchBarInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SearchBarRouter(interactor: interactor, viewController: viewController)
    }
}
