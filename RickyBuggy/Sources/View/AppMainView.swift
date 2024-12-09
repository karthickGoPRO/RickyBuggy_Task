//
//  AppMainView.swift
//  RickyBuggy
//

import SwiftUI

struct AppMainView: View {
    // FIX : 13 - fix issue with re-invoking network request on tapping show list/hide list -- Working fine When clicking on hide and show list the list is loading/getting error page based on the condition in fetch data URL
    @ObservedObject var viewModel: AppMainViewModel = AppMainViewModel()
    
    var body: some View {
        NavigationView {
            characterListView
                .navigationTitle(Text(Constants.UiConstants.homepageTitle))
                .navigationBarTitleDisplayMode(.automatic)
            // FIX : 7 - Fix issue with glitching toolbar on entering details view -- DONE
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        sortButton
                    }
                }
        }
        .actionSheet(isPresented: $viewModel.showsSortActionSheet) {
            sortActionSheet
        }
    }
}

// MARK: - View

private extension AppMainView {
    @ViewBuilder var characterListView: some View {
        if viewModel.characters.isEmpty == false {
            CharactersListView(characters: $viewModel.characters, sortMethod: $viewModel.sortMethod)
        } else if viewModel.characterErrors.isEmpty == false {
            FetchRetryView(errors: viewModel.characterErrors, onRetry: {
                viewModel.requestData()
            })
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
    var sortButton: some View {
        Button(action: viewModel.setShowsSortActionSheet) {
            Text(Constants.UiConstants.sortingChoosingTitle)
        }
    }
    
    // FIX: 8 - Fix action sheet only appearing once, in other words - after it gets opened and closed, it cannot be opened again - DONE
    var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text(Constants.UiConstants.sortTitle),
            message: Text(Constants.UiConstants.sortDescTitle),
            buttons: [
                .default(Text(Constants.SortTypes.episodeCount)) {
                    viewModel.setSortMethod(.episodesCount)
                },
                .default(Text(Constants.SortTypes.name)) {
                    viewModel.setSortMethod(.name)
                },
                .cancel(Text(Constants.UiConstants.cancelTitle)),
            ]
        )
    }
}

// MARK: - Preview

struct AppMainView_Previews: PreviewProvider {
    static var previews: some View {
        AppMainView()
    }
}
