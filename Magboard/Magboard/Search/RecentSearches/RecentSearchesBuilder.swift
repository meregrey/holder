//
//  RecentSearchesBuilder.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs

protocol RecentSearchesDependency: Dependency {
    var searchTermStream: MutableStream<String> { get }
}

final class RecentSearchesComponent: Component<RecentSearchesDependency>, RecentSearchesInteractorDependency {
    
    var searchTermStream: ReadOnlyStream<String> { dependency.searchTermStream }
}

// MARK: - Builder

protocol RecentSearchesBuildable: Buildable {
    func build(withListener listener: RecentSearchesListener) -> RecentSearchesRouting
}

final class RecentSearchesBuilder: Builder<RecentSearchesDependency>, RecentSearchesBuildable {
    
    override init(dependency: RecentSearchesDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: RecentSearchesListener) -> RecentSearchesRouting {
        let component = RecentSearchesComponent(dependency: dependency)
        let viewController = RecentSearchesViewController()
        let interactor = RecentSearchesInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RecentSearchesRouter(interactor: interactor, viewController: viewController)
    }
}
