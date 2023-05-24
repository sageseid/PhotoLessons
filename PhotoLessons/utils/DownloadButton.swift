//
//  DownloadButton.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 20/05/2023.
//

import Foundation
import UIKit

class DownloadButton: UIButton{
    convenience init(target: Any?, selector: Selector) {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        tintColor = UIColor(red: 41/255, green: 114/255, blue: 217/255, alpha: 1.0)
        setTitle("  Download", for: .normal)
        setTitleColor(UIColor(red: 41/255, green: 114/255, blue: 217/255, alpha: 1.0), for: .normal)
        addTarget(target, action: selector, for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
