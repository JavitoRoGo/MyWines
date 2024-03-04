//
//  ListView.swift
//  MyWines
//
//  Created by Javier Rodríguez Gómez on 26/6/22.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var model: MyWinesModel
    
    @State private var showingFavorites = false
    @State private var showingAddNew = false
    var showingData: [MyWine] {
        model.myWinesList.filter { !showingFavorites || $0.isFavorite }
    }
    
    var body: some View {
        NavigationView {
            List {
                if model.myWinesList.isEmpty {
                    Text("Prueba algún vino nuevo y regístralo pulsando el botón \"+\".")
                } else {
                    Toggle("Mostrar favoritos", isOn: $showingFavorites)
                    ForEach(showingData) { wine in
                        let index = model.myWinesList.firstIndex(of: wine)!
                        NavigationLink(destination: DetailView(wine: $model.myWinesList[index])) {
                            RowView(wine: wine)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                if let index = model.myWinesList.firstIndex(of: wine) {
                                    model.myWinesList[index].isFavorite.toggle()
                                }
                            } label: {
                                Image(systemName: wine.isFavorite ? "heart.slash" : "heart.fill")
                            }
                            .tint(wine.isFavorite ? .gray : .pink)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation() {
                                    model.myWinesList.removeAll(where: { $0 == wine })
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lista de vinos")
            .toolbar {
                Button {
                    showingAddNew = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddNew) {
                NavigationView {
                    AddView()
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(MyWinesModel())
    }
}
