//
//  ResultViewController.swift
//  MusicApp
//
//  Created by Kang on 2023/09/25.
//

import UIKit

final class ResultViewController: UIViewController {

    // 생성 - 컬렉션 뷰
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // 생성 - 컬렉션 뷰 플로우 레이아웃
    let flowLayout = UICollectionViewFlowLayout()
    
    // 생성 - 네트워크 매니저(싱글톤)
    let networkManager = NetworkManager.shared
    
    // 생성 - 음악 데이터(빈배열로 시작)
    var musicArrays: [Music] = []
    
    // 생성 - 검색 단어(서치바에서 전달받음)
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMain()
    }
    
    // 셋업 - 메인
    func setupMain() {
        setupCollectionView()
        setupCollectionViewAutoLayout()
    }

    // 셋업 - 컬렉션 뷰
    func setupCollectionView() {
        
        // 뷰에 컬렉션 뷰 추가
        view.addSubview(collectionView)
        
        // 만들어진 셀 등록하기
        collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: Cell.musicCollectionViewCellIdentifier)
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        flowLayout.scrollDirection = .vertical
        
        // 컬렉션 뷰 길이 계산 공식
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
    }
    
    // 셋업 - 컬렉션 뷰 오토 레이아웃
    func setupCollectionViewAutoLayout() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    
    // 데이터 셋업
    func setupDatas() {
        // 옵셔널 바인딩
        guard let term = searchTerm else { return }
        print("네트워킹 시작 단어 \(term)")
        
        // (네트워킹 시작전에) 다시 빈배열로 만들기
        self.musicArrays = []
        
        // 네트워킹 시작 (찾고자하는 단어를 가지고)
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                // 결과를 배열에 담고
                self.musicArrays = musicDatas
                // 컬렉션뷰를 리로드 (메인쓰레드에서)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        cell.imageUrl = musicArrays[indexPath.item].imageUrl
        return cell
    }
}
