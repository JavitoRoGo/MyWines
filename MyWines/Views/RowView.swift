//
//  RowView.swift
//  MyWines
//
//  Created by Javier Rodríguez Gómez on 26/6/22.
//

import SwiftUI

struct RowView: View {
    let wine: MyWine
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(wine.name)
                    .font(.title2)
                Text(wine.typeOfWine)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if wine.rating > 0 {
                    RatingView(rating: .constant(wine.rating))
                        .font(.caption)
                }
            }
            Spacer()
            if let value = wine.repeating {
                Image(systemName: value ? "cart" : "hand.raised.slash")
                    .font(.system(size: 20))
                    .foregroundColor(value ? .green : .red)
            }
            if wine.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.pink)
            }
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(wine: MyWine.example[1])
    }
}
