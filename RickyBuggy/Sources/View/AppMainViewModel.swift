//
//  AppMainViewModel.swift
//  RickyBuggy
//

import Combine
import Foundation

final class AppMainViewModel: ObservableObject {
    @Published var showsSortActionSheet: Bool = false
    @Published var showsAlertForCache: Bool = false
    @Published var sortMethod: SortMethod = .name
    @Published var characters: [CharacterResponseModel] = []

    @Published private(set) var characterErrors: [APIError] = []
    @Published private(set) var sortMethodDescription: String = Constants.UiConstants.sortingOptionTitle

    private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let sortMethodSubject = CurrentValueSubject<SortMethod?, Never>(nil)

    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private let diskCacheManager: DiskCacheManager?
    
    init() {
        diskCacheManager = DiskCacheManager()
        bindSortMethod()
        showsSortActionSheetSubject
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.showsSortActionSheet, on: self)
            .store(in: &cancellables)
        
        requestData()
    }
    
    func setSortMethod(_ sortMethod: SortMethod) {
        sortMethodSubject.send(sortMethod)
    }
    
    func setShowsSortActionSheet() {
        self.showsSortActionSheet.toggle()
    }
    
    func logOutClicked() {
        self.diskCacheManager?.clearCache()
        self.showsAlertForCache.toggle()
    }
    
    func requestData() {
        #if DEBUG
        debugPrint("Fetching data")
        #endif
        
        characterErrors.removeAll()

        isLoading = true

        let apiService = SwiftInjectDI.shared.resolve(APIClient.self)
        
        apiService?.charactersPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case let .failure(error):
                    self.characterErrors.append(error)
                case .finished:
                    break
                }
                
                self.isLoading = false
            }, receiveValue: { [weak self] characters in
                guard let self = self else { return }
                self.characters = characters
            })
            .store(in: &cancellables)
    }
    
    private func bindSortMethod() {
        sortMethodSubject
            .compactMap { $0 }
            .sink { [weak self] method in
                guard let self = self else { return }
                self.sortMethod = method
                self.sortMethodDescription = method.description
                self.characters = self.characters.sorted(by: method.sortingClosure)
            }
            .store(in: &cancellables)
    }
}
