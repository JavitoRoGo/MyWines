//
//  MyWinesModel.swift
//  MyWines
//
//  Created by Javier Rodríguez Gómez on 26/6/22.
//

import UIKit

// MARK: - Data structure

struct MyWine: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let typeOfWine: String
    let description: String
    let year: Int
    let origin: String
    let price: Double
    var isFavorite: Bool
    var date: Date?
    var rating: Int
    var opinion: String?
    var buyingReason: String?
    var repeating: Bool?
    
    static let example = [MyWine(id: UUID(), name: "Pruebita", typeOfWine: "Seco", description: "Descripción de la etiqueta", year: 2020, origin: "Origen de prueba", price: 5.55, isFavorite: false, date: .now, rating: 3, opinion: "Guay", buyingReason: "Porque sí", repeating: false),
                          MyWine(id: UUID(), name: "Favorito", typeOfWine: "Afrutado", description: "Descripción de la etiqueta favorito", year: 2020, origin: "Origen de prueba favorito", price: 6.66, isFavorite: true, date: .now, rating: 4, opinion: "Muy guay", buyingReason: "Por probar", repeating: true)]
}

// MARK: - Data model

final class MyWinesModel: ObservableObject {
    @Published var myWinesList: [MyWine] {
        didSet {
            saveToJson()
        }
    }
    
    init() {
        guard var url = Bundle.main.url(forResource: "MYWINES.json", withExtension: nil),
              let documents = getDocumentDirectory() else {
            myWinesList = []
            return
        }
        let fileDocuments = documents.appendingPathComponent("MYWINES.json")
        if FileManager.default.fileExists(atPath: fileDocuments.path) {
            url = fileDocuments
            print("Carga desde archivo.")
        } else {
            print("Carga desde bundle.")
        }
        do {
            let jsonData = try Data(contentsOf: url)
            myWinesList = try JSONDecoder().decode([MyWine].self, from: jsonData)
        } catch {
            myWinesList = []
            print("Error al cargar de json: \(error)")
        }
    }
    
    func saveToJson() {
        guard let documentPath = getDocumentDirectory() else { return }
        let fileURL = documentPath.appendingPathComponent("MYWINES.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(myWinesList)
            try data.write(to: fileURL, options: .atomic)
            print(fileURL.absoluteString)
        } catch {
            print("Error al guardar en json: \(error)")
        }
    }
}


// MARK: - Functions

func getDocumentDirectory() -> URL? {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path.first
}

func getCoverName(from name: String) -> String {
    let charsToRemove = [" ", ",", ".", ":", ";", "?", "¿", "!", "¡", "-"]
    let charsToReplace = ["á", "é", "í", "ó", "ú", "ñ"]
    let charsToReplaceBy = ["a", "e", "i", "o", "u", "n"]
    var text = name
    for item in charsToRemove where text.contains(item) {
        text = text.replacingOccurrences(of: item, with: "", options: [.literal, .caseInsensitive], range: nil)
    }
    for (index, item) in charsToReplace.enumerated() where text.contains(item) {
        text = text.replacingOccurrences(of: item, with: charsToReplaceBy[index], options: [.literal, .caseInsensitive])
    }
    return text.lowercased()
}

func saveToJpg(_ image: UIImage, cover: String) {
    let name = getCoverName(from: cover)
    if let jpgData = image.jpegData(compressionQuality: 0.5),
       let path = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
        try? jpgData.write(to: path)
        print("Imagen guardada en Archivos")
        print(path.absoluteString)
    } else {
        print("No se pudo guardar la imagen")
    }
}

func getCoverImage(from cover: String) -> UIImage {
    let name = getCoverName(from: cover)
    var coverToShow = UIImage(systemName: "questionmark")!
    if let existingCover = UIImage(named: name) {
        coverToShow = existingCover
    } else {
        if let file = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    let coverData = try Data(contentsOf: file)
                    if let savedCover = UIImage(data: coverData) {
                        coverToShow = savedCover
                    }
                } catch {
                    print("Error al convertir la imagen: \(error)")
                }
            }
        }
    }
    return coverToShow
}
