//
//  FetchRetryView.swift
//  RickyBuggy
//

import SwiftUI

struct FetchRetryView: View {
    private let errors: [APIError]
    private let onRetry: () -> Void
    
    init(errors: [APIError], onRetry: @escaping () -> Void) {
        self.errors = errors
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text(Constants.UiConstants.retryErrorTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                VStack {
                    ForEach(errors.map { IdentifiableAPIError(error: $0) }) { identifiableError in
                        Text(identifiableError.error.localizedDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Button(action: onRetry) {
                Text(Constants.UiConstants.retryTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding()
        }
        .padding()
    }
}

// MARK: - Preview

struct FetchRetryView_Previews: PreviewProvider {
    static var previews: some View {
        FetchRetryView(
            errors: [.locationRequestFailed(underlyingError: NSError(domain: "Preview", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock underlying error"]))],
            onRetry: {}
        )
    }
}
