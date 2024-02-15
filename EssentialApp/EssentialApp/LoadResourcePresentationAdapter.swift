//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Tan Vinh Phan on 05/08/2023.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    private var loading = false
    
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        if loading { return }
        
        presenter?.didStartLoading()
        loading = true
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.loading = false
            })
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self.presenter?.didFinishLoading(with: error)
                }
                
                self.loading = false
            }, receiveValue: { [weak self] resource in
                self?.presenter?.didFinishLoading(with: resource)
            })
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
