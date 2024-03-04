//
//  AddView.swift
//  MyWines
//
//  Created by Javier Rodríguez Gómez on 26/6/22.
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var model: MyWinesModel
    @Environment(\.dismiss) var dismiss
    
    var isButtonDisabled: Bool {
        guard !name.isEmpty && !description.isEmpty && !origin.isEmpty &&
                price != 0.0 && year != 0 && !buyingReason.isEmpty else { return true }
        return false
    }
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var origin: String = ""
    @State private var year: Int = 0
    @State private var price: Double = 0.0
    @State private var typeOfWine: String = ""
    @State private var buyingReason: String = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State private var showingImagePicker = false
    @State private var showingSavingAlert = false
    
    var body: some View {
        Form {
            Section {
                TextField("Nombre del vino", text: $name)
                TextField("Origen", text: $origin)
                TextField("Variedad: seco, afrutado...", text: $typeOfWine)
                HStack {
                    Text("Año de la cosecha:")
                    TextField("Año de la cosecha", value: $year, format: .number)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Precio de la botella:")
                    TextField("Precio de la botella", value: $price, format: .currency(code: "eur"))
                        .keyboardType(.decimalPad)
                }
            }
            Section("Motivo de compra") {
                TextField("Indica el motivo de la compra", text: $buyingReason)
            }
            Section("Información de la etiqueta") {
                TextEditor(text: $description)
                    .frame(height: 100)
                VStack {
                    Button("Añadir foto de la etiqueta") {
                        showingImagePicker = true
                    }
                    
                    if let image = image {
                        image
                            .resizable()
                            .frame(width: 100, height: 140)
                    } else {
                        Image(systemName: "questionmark.diamond")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                }
            }
        }
        .navigationTitle("Nuevo registro...")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Añadir") {
                    addNewWine()
                    showingSavingAlert = true
                }
                .disabled(isButtonDisabled)
            }
        }
        .alert("Datos guardados correctamente.", isPresented: $showingSavingAlert) {
            Button("Aceptar") {
                dismiss()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .disableAutocorrection(true)
    }
    
    func addNewWine() {
        let newWine = MyWine(id: UUID(), name: name, typeOfWine: typeOfWine, description: description, year: year, origin: origin, price: price, isFavorite: false, date: nil, rating: 0, buyingReason: buyingReason)
        model.myWinesList.insert(newWine, at: 0)
        if let inputImage = inputImage {
            saveToJpg(inputImage, cover: name)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView()
                .environmentObject(MyWinesModel())
        }
    }
}
