//
//  ContentView.swift
//  Shared
//
//  Created by Élève 1 on 2022-02-21.
//
import SwiftUI
struct ContentView: View {
    // @Environnement(\.colorScheme) var couleurEcran
    @State private var isOn : Bool = true
    @State private var isOn1 : Bool = true
    @State private var isOn2 : Bool = true
    @AppStorage("maCle") var maValeur = 20
    
    let gestionBD: GestionBD = GestionBD(nomBD: "objetconnecte.db")

    init() {
      gestionBD.ouvrirBD()
    }
    
    var body: some View {
    NavigationView{
        ZStack(alignment: .bottom) {
        VStack{
              if gestionBD.pointeurBD == nil {
                Text("Un problème empêche l'ouverture de la base de données.")
              } else {
                let items = gestionBD.listeItems()

                if items.count > 0 {
                  List {
                    ForEach (items) { item in
                      VStack {
                          NavigationLink(destination: vueListeCaracteristique(idObjet:item.id, gestionBD:gestionBD)) {
                              HStack {
                                Image(systemName: "circle.fill")
                                  .padding(10)
                                VStack(alignment: .leading) {
                                    Text(item.nom)
                                    Text(String(item.type))
                                }
                              }
                              .padding()
                        }
                      }
                    }
                  }
                } else {
                  Text("Il n'y a actuellement aucun item.")
                }
              }
        /*HStack(){
            Image(systemName:"battery.100")
            Text("Prise 1: ")
            Toggle("État", isOn: $isOn)
        }.padding()
        HStack(){
            Image(systemName:"battery.100")
            Text("Prise 2: ")
            Toggle("État", isOn: $isOn1)
            }.padding()
        HStack(){
                Image(systemName:"lightbulb.fill")
                Text("Ampoule")
                    Toggle("État", isOn: $isOn2)
            }.padding()*/
        }.font(.system(size:CGFloat(maValeur)))
        .toolbar(content: {
            ToolbarItem(placement:.navigationBarTrailing, content: {
                NavigationLink(destination: AppelAPI()) {
                    HStack {
                      Image(systemName: "cloud")
                      }
                    }
          })
            ToolbarItem(placement: .bottomBar, content: {
                Button(action:{
                    if (maValeur < 35){
                    maValeur += 2
                    }
                }) {
                    Image(systemName:"plus")
                }

            })
            ToolbarItem(placement:.navigationBarTrailing){
                NavigationLink(destination: AjoutItem(gestionBD:gestionBD)) {
                    HStack {
                      Image(systemName: "plus.circle")
                      }
                    }
        }
            
            ToolbarItem(placement: .bottomBar, content: {
                Button(action:{
                    if(maValeur>20){
                        maValeur -= 2
                        
                    }
                }) {
                    Image(systemName:"minus")
                }
            })
            
        }
        )}

}

}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
        ContentView().preferredColorScheme(.dark)
    }
}

