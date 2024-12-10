//
//  CharacterDetailView.swift
//  RickyBuggy
//

import SwiftUI

// FIX: 9 - Fix title (character name) so it's displayed on the top, just below navigation bar - DONE
struct CharacterDetailView: View {
    @ObservedObject private var viewModel: CharacterDetailViewModel
    
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(viewModel.title)
                .navigationBarHidden(false)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: viewModel.requestData) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                    }
                }
        }
    }
}

private extension CharacterDetailView {
    @ViewBuilder var content: some View {
        if viewModel.data != nil {
            ScrollView {
                VStack(alignment: .leading) {
                    photoSection
                    detailsSection
                    locationSection
                }
            }
        } else if viewModel.characterErrors.isEmpty == false {
            FetchRetryView(errors: viewModel.characterErrors, onRetry: viewModel.requestData)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    viewModel.requestData()
                }
        }
    }
}

// MARK: - Section: Photo

private extension CharacterDetailView {
    // FIX : 10 - Fix so image isn't cropped and still looks good (see Morty for example of how broken it is now) -- DONE
    var photoSection: some View {
        HStack(alignment: .center, spacing: 8) {
            GeometryReader { geometry in
                CharacterPhoto(data: viewModel.CharacterPhotoData)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .cornerRadius(5)
            }
            .frame(height: UIScreen.main.bounds.height / 5)
        }
        .padding()
    }
}



// MARK: - Section: About

private extension CharacterDetailView {
    var detailsSection: some View {
        VStack(alignment: .center, spacing: 8) {
           
            HStack {
                Text(Constants.UiConstants.popularityTitle)
                    .font(.headline)
                Text(viewModel.popularityName)
                    .font(.headline)
            }
            
            Spacer()
            
            Text(Constants.UiConstants.about)
                .font(.headline)
            
            Text(viewModel.details)
                .font(.footnote)
                .fontWeight(.medium)
                .padding(.leading, 4)
        }
        .padding()
    }
}

// MARK: - Section: Location

private extension CharacterDetailView {
    var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(Constants.UiConstants.location)
                    .font(.headline)
                
                Spacer()
                // FIX : 12 - change to filled share icon using sfsymbols, confirm if functionallity works, fix if needed - DONE
                Button(action: viewModel.setShowsLocationDetails) {
                    Image(systemName: "arrow.up.right.circle.fill")
                        .accentColor(.orange)
                        .font(.title)
                }
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.showsLocationDetailsView) {
            if let locationDetail = viewModel.data?.location {
                VStack(alignment: .leading) {
                    Text(locationDetail.name)
                        .font(.headline)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    Text(locationDetail.created)
                        .font(.headline)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    List(locationDetail.residents, id: \.self) { resident in
                        HStack(alignment: .top) {
                            Text(resident)
                        }
                        
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(viewModel: CharacterDetailViewModel(characterId: 1, name: "Johnny"))
    }
}
    
