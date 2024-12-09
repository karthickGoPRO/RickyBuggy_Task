//
//  CharactersListItemView.swift
//  RickyBuggy
//

import SwiftUI

struct CharactersListItemView: View {
    @ObservedObject private var viewModel: CharactersListItemViewModel
    
    init(viewModel: CharactersListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {

            NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(characterId: viewModel.id, name: viewModel.title))) {
                EmptyView()
            }
            
            HStack {
                CharacterPhoto(data: viewModel.characterImageData)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height / 5)
                    .cornerRadius(5)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text(viewModel.title)
                            .titleStyle()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    //Fix - 6 Make the link tapable - DONE
                    if let url = URL(string: viewModel.url) {
                        Link(destination: url) {
                            Text(viewModel.url)
                                .font(.body)
                                .foregroundColor(.blue)
                                .padding(.bottom, 4)
                        }
                        .padding(.top, 4)
                    }
                    
                    Text(viewModel.created)
                        .contentsStyle()
                    
                    Spacer()
                    
                    Text("\(Constants.UiConstants.episodeCountTitle) \(viewModel.countEPISODE)")
                        .contentsStyle()
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct characterListCell_Previews: PreviewProvider {
    static var previews: some View {
        CharactersListItemView(viewModel: CharactersListItemViewModel(character: .dummy))
            .frame(maxHeight: UIScreen.main.bounds.height / 5)
    }
}
