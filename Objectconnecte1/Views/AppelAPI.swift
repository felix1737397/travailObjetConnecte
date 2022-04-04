//
//  AppelAPI.swift
//  Objectconnecte1
//
//  Created by Élève 1 on 2022-04-04.
//
//
import SwiftUI
struct AppelAPI: View {

  @State private var reponseApi: ReponseApi? = nil
  @State private var messageErreur = ""
  @State private var appelApiFait = false   // permettra d'afficher une image de chargement en cours

  var body: some View {
    NavigationView {
      VStack {

        Spacer()

        if !appelApiFait {
          ProgressView()
        }
        else {
          if messageErreur == "" {
            AsyncImage(
              url: URL(string: reponseApi != nil ? reponseApi!.message : ""),
              content: { image in
                image.resizable()
                .aspectRatio(contentMode: .fit)
              },
              placeholder: {
                ProgressView()
              }
            )
          }
          else {
            Text(messageErreur)
          }
        }

        Spacer()

        Button(action: {
          Task {
            do {
              try await appelerAPI()
            } catch {
              messageErreur = error.localizedDescription
            }
          }
        }) {
          Text("Nouvelle image")
            .padding()
            .foregroundColor(Color.white)
            .background(Color.gray)
            .cornerRadius(15.0)
        }
      } // fin VStack
      .navigationTitle("Les pitous")
    } // fin NavigationView
    .task {
      // Image chargée au départ
      do {
        try await appelerAPI()
      } catch {
        messageErreur = error.localizedDescription
      }
    }
  }

  func appelerAPI() async throws {
    appelApiFait = true
    let chaineURL = "https://dog.ceo/api/breeds/image/random"

    guard let url = URL(string: chaineURL) else {
      // Arrivera ici si l'URL est invalide, par exemple s'il s'agit d'une chaîne vide ou qui contient des caractères accentués.
      messageErreur = "Un problème empêche de retrouver l'image (code 1)."
      print("URL invalide : \(chaineURL)")
      return
    }

    do {
      // lance la requête HTTP
      let (data, response) = try await URLSession.shared.data(from: url)

      // retrouve le code d'état HTTP
      if let etatHTTP = (response as? HTTPURLResponse)?.statusCode {

        switch etatHTTP {
        case 200 :
          // décode la réponse JSON
          if let reponseDecodee = try? JSONDecoder().decode(ReponseApi.self, from: data) {
            reponseApi = reponseDecodee
          }
          else {
            // Arrivera ici si la réponse JSON ne correspond pas à la structure ReponseApi.
            messageErreur = "Un problème empêche de retrouver l'image (code 2)."
            print("Chaîne JSON non compatible : \(String(data: data, encoding: .utf8) ?? "La chaîne est nil.")")
          }
        case 500 :
          messageErreur = "Un problème empêche de retrouver l'image (code 3)."
          print("Code d'erreur 500")
        default :
          messageErreur = "Un problème empêche de retrouver l'image (code 4)."
          print("Code d'état HTTP : \(etatHTTP)")
        }
      }
      else {
        // Arrivera ici si la réponse ne peut pas être transtypée vers HTTPURLResponse. En principe, ceci ne devrait jamais arriver.
        messageErreur = "Un problème empêche de retrouver l'image (code 5)."
        print("Mauvaise réponse : ", response)
      }
    }
    catch {
      // Arrivera ici si la requête HTTP a échoué, par exemple s'il n'y a plus d'internet ou si le serveur ne répond pas.
      messageErreur = "Un problème empêche de retrouver l'image (code 6)."
      print("Erreur : ", error)
    }
  }
}

