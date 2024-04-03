//
//  ConstRecources.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 19/03/24.
//

import Foundation
import UIKit

class ConstResource {
    private static let base_url = "https://finance-learning-app.onrender.com"
    private static let getChapters = "/api/v1/finance/get_chapters"
    private static let getCertificate = "/api/v1/finance/get_certificate"
    private static let getQuizQuestion = "/api/v1/finance/get_quiz_questions"
    
    
    static func getChapterURI() -> String {
        return self.base_url + self.getChapters
    }
    
    static func getCertificateURI() -> String {
        return self.base_url + self.getCertificate
    }
    
    static func getQuizURI() -> String {
        return self.base_url + self.getQuizQuestion
    }
    
    static func makeAlert(title: String, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    
    static func generateRandomUsername() -> String {
        let adjectives = ["Swift", "Random", "Creative", "Savvy", "Dynamic", "Clever", "Unique", "Vibrant", "Brilliant", "Mystic"]
        let nouns = ["Coder", "Ninja", "Genius", "Guru", "Whiz", "Wizard", "Master", "Pro", "Legend", "Champion"]
        let randomAdjective = adjectives.randomElement() ?? ""
        let randomNoun = nouns.randomElement() ?? ""
        return randomAdjective + randomNoun
    }
    
    static func generateReferralCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<5).map { _ in letters.randomElement()! })
    }
}
