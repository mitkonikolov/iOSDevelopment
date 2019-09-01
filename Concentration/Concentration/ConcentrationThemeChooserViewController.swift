//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Mitko Nikolov on 8/14/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {    

  private let emojiThemes = [
    "Halloween": ["🎃", "😈", "💀", "🧟‍♀️", "🧛‍♂️", "🍭", "🍬", "👻", "☠️", "👽"],
    "Faces": ["😀", "😁", "😝", "😎", "😳", "😬", "🤠", "🤣", "😋", "🤓", "🧐","😘"],
    "Animals": ["🐶", "🐱", "🦊", "🐻", "🐭", "🐵", "🦁", "🐼", "🐹", "🐰", "🐯","🐷"],
    "Sports": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🥊", "🏓", "🏐", "🏒", "🎱", "🏸","⛸"],
    "Foods": ["🍉", "🥑", "🍅", "🍊", "🍋", "🍏", "🌽", "🥕", "🥔", "🥦", "🥥","🍍"],
    "Vehicles": ["🚗", "🚌", "🚎", "🏎", "🚓", "✈️", "🛳", "🚁", "🚀", "🚅", "🚃","⛵️"]]
  
  @IBAction func changeTheme(_ sender: Any) {
    if let cvc = splitViewDetailConcentrationViewController {
      if let themeName = (sender as? UIButton)?.currentTitle, let theme = emojiThemes[themeName] {
        cvc.emojiChoices = theme
      }
    }
    else if let cvc = lastSeguedToConcentrationViewController {
      if let themeName = (sender as? UIButton)?.currentTitle, let theme = emojiThemes[themeName] {
        cvc.emojiChoices = theme
      }
      navigationController?.pushViewController(cvc, animated: true)
    }
    else {
      performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
  }
  
  private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
    return splitViewController?.viewControllers.last as? ConcentrationViewController
  }
  
  private var lastSeguedToConcentrationViewController: ConcentrationViewController?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
      if let themeName = (sender as? UIButton)?.currentTitle, let theme = emojiThemes[themeName] {
        if let cvc = segue.destination as? ConcentrationViewController {
          cvc.emojiChoices = theme
          lastSeguedToConcentrationViewController = cvc
        }
      }
  }
 

}
