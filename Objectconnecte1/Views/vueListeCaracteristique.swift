//
//  vueListeCaracteristique.swift
//  Objectconnecte1
//
//  Created by Élève 1 on 2022-03-10.
//
import SwiftUI

struct vueListeCaracteristique: View {
    
    let idObjet: Int
    let gestionBD: GestionBD
    
    var body: some View {
        NavigationView{
        ZStack(alignment: .bottom){
                VStack{
                    if gestionBD.pointeurBD == nil {
                            Text("Un problème empêche l'ouverture de la base de données.")
                        }
                        else {
                            let items = gestionBD.listeCaract(id: idObjet)
                            if items.count > 0 {
                                List {
                                    ForEach (items) { item in
                                        VStack {
                                            HStack {
                                                Image(systemName: "circle.fill")
                                                    .padding(10)
                                                VStack(alignment: .leading) {
                                                    Text(item.date_captation)
                                                    Text(String(item.nom_valeur))
                                                    Text(String(item.valeur))
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("Il n'y a actuellement aucune valeur pour cet item.")
                            }
                        }

                    }
                }
                .toolbar(content: {
                    ToolbarItem(placement:.navigationBarTrailing, content: {
                        Button(action:{}) {
                            Image(systemName:"plus.circle")
                            Image(systemName: "cloud")
                        }
                    })
                    ToolbarItem(placement: .bottomBar, content: {
                        Button(action:{
                        }) {
                            Image(systemName:"plus")
                        }

                    })
                    ToolbarItem(placement: .bottomBar, content: {
                        Button(action:{
                        }) {
                            Image(systemName:"minus")
                        }
                    })

                }
                )

                }
        }
        
    }

