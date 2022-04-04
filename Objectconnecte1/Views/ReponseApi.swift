//
//  ReponseAPI.swift
//  ChienAPI
//
//  Created by Élève 1 on 2022-04-04.
//

import Foundation


/// Pour recevoir les informations en provenance de l'API Dog Api : https://dog.ceo/api/breeds/image/random (aucune clé requise)
struct ReponseApi: Codable {
  var message: String
  var status: String
  var code: Int?
}

