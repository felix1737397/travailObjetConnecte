//
//  vueListeCaracteristique.swift
//  Objectconnecte1
//
//  Created by Élève 1 on 2022-03-10.
//
import SwiftUI
import Combine

struct AjoutItem: View {
    @State var nom = ""
    @State var type = ""
    @State var id_valeur = ""
    @State var id_valeur_int = 0
    @State var id_type_int = 0
    
    
    
    let gestionBD: GestionBD
    
    var body: some View {
        Form{
                
                TextField("Nom d'objet", text: $nom)
                
                TextField("Type", text: $type)
                    .keyboardType(.numberPad)
                    .onReceive(Just(type)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.type = filtered
                        }
                        id_type_int = Int(type) ?? 0
                    }
                
                
                TextField("id_valeur", text: $id_valeur)
                    .keyboardType(.numberPad)
                    .onReceive(Just(id_valeur)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.id_valeur = filtered
                        }
                        id_valeur_int = Int(id_valeur) ?? 0
                    }
                Section {
                    Button(action: {
                        let ajout = gestionBD.ajoutItem(nom: nom, type: id_type_int, id_valeur: id_valeur_int)
                        if ajout {
                            nom = ""
                            type = ""
                            id_valeur = ""
                        }
                    }) {
                        Text("Créer un item")
                    }
                }
        }
    }
}




