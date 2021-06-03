//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import SwiftLazy
import Combine
import Coordinator


struct ProfileControllerRoutingPoints {
    let editProfile: EditProfileController.Endpoint
    let fillInfo: FinishProfileUpdatingController.Endpoint
    let shareProfile: ShareProfileController.Endpoint
}

final class ProfileController: UIHostingController<ProfileScene>, RoutableController {
    
    typealias Endpoint = Provider1<ProfileController, ProfileInput>
    
    var routePublisher: AnyPublisher<ProfileState.Route?, Never> {
        viewStore.publisher.route
            .handleEvents(receiveOutput: { [weak viewStore] point in
                guard let viewStore = viewStore, point != nil else { return }
                viewStore.send(.changeDetail(.closed))
            })
            .eraseToAnyPublisher()
    }
    
    private let store: Store<ProfileState, ProfileAction>
    private let viewStore: ViewStore<ProfileState, ProfileAction>
    private let routingPoints: ProfileControllerRoutingPoints

    var coordinator: Coordinator!
    
    private var bag = Set<AnyCancellable>()
    
    init(input: ProfileInput, env: ProfileEnvironment, routingPoints: ProfileControllerRoutingPoints) {
        let store = Store(initialState: ProfileState(userID: input.userID),
                          reducer: profileReducer,
                          environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.routingPoints = routingPoints

        super.init(rootView: ProfileScene(store: store))
        
        observeRouting().store(in: &bag)
    }
    
    func handle(routing: ProfileState.Route) {
        switch routing {
        case .editProfile:
            let vc = routingPoints.editProfile.value
            present(controller: vc, preferredPresentation: .detail)
        case .fillInfo:
            let vc = routingPoints.fillInfo.value
            present(controller: vc, preferredPresentation: .detail)
        case let .shareProfile(userID):
            let vc = routingPoints.shareProfile.value(userID)
            present(controller: vc, preferredPresentation: .detail)
        case let .openedStudent(userID):
			let vc = coordinator.view(for: .dictionaries(.init(userID: userID, welcomeMessageShow: false)))
            present(controller: vc, preferredPresentation: .detail)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
