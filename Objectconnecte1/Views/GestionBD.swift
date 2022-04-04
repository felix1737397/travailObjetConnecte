//
//  GestionBD.swift
//  Objectconnecte1
//
//  Created by Élève 1 on 2022-03-07.
//

import Foundation
import SQLite3

/// Gestion d'une base de données SQLite.
class GestionBD {
  var nomBD: String = ""
  var pointeurBD: OpaquePointer? = nil

  /**
   Constructeur.

   - Parameters:
     - nomBD: nom de la base de données
  */
  init(nomBD: String) {
    self.nomBD = nomBD
  }

   /**
    Ouvre la base de données et initialise la propriété pointeurBD.
   */
  func ouvrirBD() {
    var reussi: Bool = false

    do {
      let fileManager = FileManager.default

      let urlApplicationSupport = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(nomBD)
      // print(urlApplicationSupport)

      // ouvre la base de données mais ne la crée pas si elle n'existe pas
      var codeRetour = sqlite3_open_v2(urlApplicationSupport.path, &pointeurBD, SQLITE_OPEN_READWRITE, nil)

      // si la base de données n'est pas trouvée, va chercher la version originale dans le paquet de l'application
      if codeRetour == SQLITE_CANTOPEN {
        print("Tentative de retrouver la base de données dans le paquet.")

        if let urlPaquet = Bundle.main.url(forResource: nomBD, withExtension: "") { // ici, l'extension fait déjà partie du nom de la BD
          // print(urlPaquet)

          try fileManager.copyItem(at: urlPaquet, to: urlApplicationSupport)
          codeRetour = sqlite3_open_v2(urlApplicationSupport.path, &pointeurBD, SQLITE_OPEN_READWRITE, nil)
        } else {
          print("Erreur : la base de données ne fait pas partie du paquet.")
        }
      }

      if codeRetour == SQLITE_OK {
        reussi = true;
      } else {
        print("La connexion à la base de données a échoué : \(codeRetour)")
      }

    } catch {
      print("Erreur inattendue : \(error)")
    }

    if (!reussi) {
      // Selon la doc officielle : Whether or not an error occurs when it is opened, resources associated with the database connection handle should be released by passing it to sqlite3_close() when it is no longer required (source : https://www.sqlite.org/c3ref/open.html).
      sqlite3_close(pointeurBD)
      pointeurBD = nil
    }
  }
    
    /**
     Retrouve la liste des itemss dans la base de données en ordre de code.

     - Returns: Tableau des items.
    */
    func listeItems() -> [Objet] {
      let requete: String = "SELECT id_valeur, nom, type FROM objet ORDER BY nom"
      var items: [Objet] = []
      var preparation: OpaquePointer? = nil

      // prépare la requête
      if sqlite3_prepare_v2(pointeurBD, requete, -1, &preparation, nil) == SQLITE_OK {

        // exécute la requête
        while sqlite3_step(preparation) == SQLITE_ROW {

          // lecture d'un champ INTEGER (même technique pour un booléen puisqu'il est représenté comme un entier)
          let id = Int(sqlite3_column_int(preparation, 0)) // sans la conversion, on avait un Int32
            
           // lecture d'un champ qui peut être nul
            var nom = "-"

            if let pointeurColonne = sqlite3_column_text(preparation, 1) {
              nom = String(cString: pointeurColonne)
            }
          
            let type = Int(sqlite3_column_int(preparation, 2))          // lecture d'un champ qui peut être nul


            items.append(Objet(id: id, nom: nom, type: type, id_valeur: 0 ))
            
        }
      } else {
        let erreur = String(cString: sqlite3_errmsg(pointeurBD))
        print("\nLa requête n'a pas pu être préparée : \(erreur)")
      }

      // libération de la mémoire
      sqlite3_finalize(preparation)

      return items
    }
    
    
    func listeCaract(id: Int) -> [Valeur] {
      let requete: String = "SELECT  nom_valeur, value, date_captation FROM valeur WHERE id_Objet = ? ORDER BY nom_valeur"
      var items: [Valeur] = []
      var preparation: OpaquePointer? = nil

      // prépare la requête
      if sqlite3_prepare_v2(pointeurBD, requete, -1, &preparation, nil) == SQLITE_OK {
          sqlite3_bind_int(preparation, 2, Int32(id))
        // exécute la requête
        while sqlite3_step(preparation) == SQLITE_ROW {

          // lecture d'un champ INTEGER (même technique pour un booléen puisqu'il est représenté comme un entier)
            
          var date_captation = "-"
            if let pointeurColonne = sqlite3_column_text(preparation, 0){
                date_captation = String(cString: pointeurColonne)
            }
            
            var nom_valeur = "-"
              if let pointeurColonne = sqlite3_column_text(preparation, 1){
                  nom_valeur = String(cString: pointeurColonne)
              }
            
            let valeur = Int(sqlite3_column_int(preparation, 2)) // sans la conversion, on avait un Int32
            

            items.append(Valeur(id: id, date_captation: date_captation, id_objet: id, nom_valeur:nom_valeur, valeur: valeur ))
            
        }
      } else {
        let erreur = String(cString: sqlite3_errmsg(pointeurBD))
        print("\nLa requête n'a pas pu être préparée : \(erreur)")
      }

      // libération de la mémoire
      sqlite3_finalize(preparation)

      return items
    }
    
    
    func ajoutItem(nom: String, type: Int, id_valeur: Int) -> Bool {
      let requete: String = "INSERT INTO objet(nom, type, id_valeur) VALUES (?,?,?)"
      var retour = false;
      var preparation: OpaquePointer? = nil

          // prépare la requête
          if sqlite3_prepare_v2(pointeurBD, requete, -1, &preparation, nil) == SQLITE_OK {

            sqlite3_bind_text(preparation, 1, NSString(string: nom).utf8String, -1, nil)
            sqlite3_bind_int(preparation, 2, Int32(type))
              sqlite3_bind_int(preparation, 3, Int32(id_valeur))



            // exécute la requête
            if sqlite3_step(preparation) != SQLITE_DONE {
              let erreur = String(cString: sqlite3_errmsg(pointeurBD))
              print("\nErreur lors de l'insertion : \(erreur)")
            } else {
              retour = true
            }
          } else {
            let erreur = String(cString: sqlite3_errmsg(pointeurBD))
            print("\nLa requête n'a pas pu être préparée : \(erreur)")
          }

          // libération de la mémoire
          sqlite3_finalize(preparation)
        return retour
    }
}
