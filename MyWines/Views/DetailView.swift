//
//  DetailView.swift
//  MyWines
//
//  Created by Javier Rodríguez Gómez on 26/6/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var wine: MyWine
    
    @State private var opinion: String = ""
    @State private var showingSavingAlert = false
    @State private var repeating = false
    @FocusState private var opinionIsFocused: Bool
    var opinionHeader: String {
        if let date = wine.date {
            return "Valorado el \(date.formatted(date: .numeric, time: .omitted))"
        } else {
            return "Escribe tu valoración"
        }
    }
    var isDisabled: Bool {
        guard !opinion.isEmpty && opinion != wine.opinion else { return true }
        return false
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(uiImage: getCoverImage(from: wine.name))
                        .resizable()
                        .frame(width: 120, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white, lineWidth: 4)
                        }
                        .shadow(color: .gray, radius: 7)
                    Spacer()
                    VStack {
                        Text(wine.name)
                            .font(.title)
                            .foregroundColor(.red)
                        HStack(spacing: 25) {
                            RatingView(rating: $wine.rating)
                            Button {
                                wine.isFavorite.toggle()
                            } label: {
                                Image(systemName: wine.isFavorite ? "heart.fill" : "heart")
                                    .font(.title)
                                    .foregroundColor(wine.isFavorite ? .pink : .gray.opacity(0.2))
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding()
                        Toggle("¿Repetirías este vino?", isOn: $repeating)
                            .onChange(of: repeating) { newValue in
                                wine.repeating = newValue
                            }
                    }
                }
            }
            
            Section {
                Text(wine.typeOfWine)
                Text(wine.origin)
                HStack {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Spacer()
                    Text(String(wine.year))
                }
                HStack {
                    Image(systemName: "eurosign.circle")
                        .font(.title2)
                        .foregroundColor(.green)
                    Spacer()
                    Text(wine.price, format: .currency(code: "eur"))
                }
                Text(wine.buyingReason ?? "Motivo de compra no indicado.")
            }
            Section(opinionHeader) {
                TextEditor(text: $opinion)
                    .focused($opinionIsFocused)
                    .frame(height: 100)
            }
            Section("Descripción") {
                Text(wine.description)
            }
        }
        .navigationTitle("Detalle...")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Modificar") {
                    wine.opinion = opinion
                    wine.date = .now
                    showingSavingAlert = true
                }
                .disabled(isDisabled)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    opinionIsFocused = false
                }
            }
        }
        .alert("Se han modificado los datos.", isPresented: $showingSavingAlert) {
            Button("Aceptar") { }
        }
        .task {
            if let text = wine.opinion {
                opinion = text
            }
            if let wineRepeating = wine.repeating {
                repeating = wineRepeating
            } else {
                wine.repeating = false
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(wine: .constant(MyWine.example[1]))
        }
    }
}
