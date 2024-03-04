//
//  RatingView.swift
//  MyWines
//
//  Created by Javier Rodríguez Gómez on 27/6/22.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var maximumRating = 5
    var offImage = Image(systemName: "cross")
    var onImage = Image(systemName: "cross.fill")
    var offColor = Color.gray.opacity(0.4)
    var onColor = Color.indigo
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}
