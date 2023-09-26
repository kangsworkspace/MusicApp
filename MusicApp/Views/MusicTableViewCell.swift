//
//  MusicTableViewCell.swift
//  MusicApp
//
//  Created by Kang on 2023/09/25.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    // 생성 - 이미지 URL을 전달받는 변수
    var imageUrl: String? {
        // Url이 변하면 이미지를 로드한다.
        didSet {
            loadImage()
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 이미지가 바뀌는 것처럼 보이는 형상을 없애기 위해서 실행
        self.mainImageView.image = nil
    }
    
    // 생성 - 메인 이미지 뷰
    lazy var mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // 생성 - 곡 제목 레이블
    var songNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 생성 - 아티스트 이름 레이블
    var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 앨범 이름 레이블
    var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 생성 - 출시 일자 레이블
    var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        label.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 생성 - 스택 뷰
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [songNameLabel, artistNameLabel, albumNameLabel, releaseDateLabel])
        sv.axis = .vertical
        sv.spacing = 6
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setupMain()
    }
    
    // 오토 레이아웃 설정
    override func updateConstraints() {
        setupAutoLayout()
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMain() {
        setupAddView()
    }
    
    // 셋업 - 애드 뷰
    func setupAddView() {
        self.addSubview(mainImageView)
        self.addSubview(mainStackView)
    }
    
    // 셋업 - 오토 레이아웃
    func setupAutoLayout() {
     
        // 셋 - 메인 이미지 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 100),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainImageView.trailingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: -20)
        ])
        
        // 셋 - 스택 뷰 오토 레이아웃
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    // URL -> 이미지 로드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
        
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }

}
