//
//  ResultAlertViewModel.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/31/24.
//

import Foundation
import UIKit

class AlertViewModel: ObservableObject {
    
    let imageLoaderService = ImageLoaderService()
    
    @Published var imageData: UIImage? = nil

    func viewAppeared() {
        imageLoaderService.fetchImage(from: Constants.frogWizardImageSource) { data in
            if let validData = data {
                DispatchQueue.main.async {
                    let uiImage = UIImage(data: validData)
                    self.imageData = uiImage
                }
            }
        }
    }
}
