//
//  LocationButton.swift
//  MapAPIProject
//
//  Created by 박다혜 on 2023/08/27.
//

import UIKit

class LocationButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() {
        backgroundColor = .white
        setImage(UIImage(systemName: "scope"), for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}
