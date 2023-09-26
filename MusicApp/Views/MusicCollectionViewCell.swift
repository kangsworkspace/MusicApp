//
//  MusicCollectionViewCell.swift
//  MusicApp
//
//  Created by Kang on 2023/09/25.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    
    // 생성 - 이미지 URL을 전달받을 변수
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    // 생성 - 메인 이미지 뷰
    lazy var mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셋업 - 메인
    func setupMain() {
        
        setupAddView()
        setupAutoLayout()
    }
    
    // 셋업 - 애드 뷰
    func setupAddView() {
        self.addSubview(mainImageView)
    }
    
    // 셋업 - 오토 레이아웃
    func setupAutoLayout() {
        // 메인 이미지 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }

    // URL ===> 이미지를 셋팅하는 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        // 오래걸리는 작업을 동시성 처리
        DispatchQueue.global().async {
            // URL을 가지고 데이터를 만드는 메서드
            // (일반적으로 이미지를 가져올때 많이 사용)
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard self.imageUrl! == url.absoluteString else { return }
            
            // 작업의 결과물을 이미지로 표시 (메인큐)
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        self.mainImageView.image = nil
    }
}
