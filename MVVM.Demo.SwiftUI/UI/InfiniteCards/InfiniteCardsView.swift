//
//  InfiniteCardsView.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/29/24.
//

import SwiftUI

struct InfiniteCardsView: View {
  @State var viewModel: InfiniteCardsViewModel
  
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 0.0) {
        ForEach(self.viewModel.cards) { card in
          CardView(viewModel: card)
            .task {
              guard card.shouldFetchNextBatch else {
                return
              }
              self.viewModel.fetchNextBatch(currentCardViewModel: card)
            }
            .id(card.id)
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.paging)
    .navigationTitle("Infinite Cards")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          self.viewModel.close()
        } label: {
          Image(systemName: "xmark")
        }
      }
    }
  }
}

extension InfiniteCardsView {
  struct CardView: View {
    @ScaledMetric var cardPadding: CGFloat = 8.0
    @ScaledMetric private var cornerRadius: CGFloat = 16.0
    
    @State var viewModel: InfiniteCardsViewModel.CardViewModel
    
    var body: some View {
      RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous)
        .fill(self.viewModel.colorModel.asColor())
        .overlay(alignment: .bottomLeading) {
          Text(self.viewModel.id.uuidString)
            .minimumScaleFactor(0.5)
            .font(.headline)
            .fontDesign(.monospaced)
            .lineLimit(1)
            .bold()
            .foregroundStyle(self.viewModel.colorModel.asContrastColor())
            .padding(self.cardPadding)
        }
        .padding(self.cardPadding)
        .containerRelativeFrame(.horizontal)
    }
  }
}
