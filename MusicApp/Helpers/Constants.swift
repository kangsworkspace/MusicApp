//
//  Constants.swift
//  MusicApp
//
//  Created by Kang on 2023/09/25.
//

import UIKit

// 네트워크에 사용할 문자열
public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

// Cell의 Identifier 문자열
public enum Cell {
    static let musicCellIdentifier = "MusicCell"
    static let musicCollectionViewCellIdentifier = "MusicCollectionViewCell"
}

// 컬렉션뷰 UI 구성을 위한 설정
public enum CVCell {
    static let spacingWitdh: CGFloat = 1
    static let cellColumns: CGFloat = 3
}
