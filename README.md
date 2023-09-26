# TabBarCode

## 🖥️ 프로젝트 소개

- 간단한 네트워킹을 통해 검색한 내용을 보여주는 프로젝트를 코드 베이스로 진행하였습니다. 
- 프로젝트를 통해 네트워킹, UISearchController, UICollectionView를 학습하였습니다.


<br>

## 👀 프로젝트 구성

- 검색어를 담는 변수 `searchTerm`을 통해 네트워킹을 요청하고
  받아온 정보를 JOSNDecoder()를 통해 JSON형식으로 바꾸어 필요한 정보를 구조체 `[music]`에 담아 사용하였습니다.
  
- 앱을 실행시키고 나오는 첫화면은 테이블 뷰로 기본 검색어를 "zazz"로 설정하였습니다.

- `UISearchResultsUpdating`프로토콜 확장을 통해 서치바가 동작하면 해당 검색어를 네트워킹 하여 `UICollectionView()`로 결과물을 표시하도록 하였습니다.

<br>

## 📌 학습한 주요 내용

#### 네트워킹
네트워킹을 사용하는 기초적인 방법에 대해 이해하였습니다.
싱글톤으로 설정하였으며 작업에 시간이 걸리기 때문에 비동기 처리를 했고
비동기 처리를 했기 때문에 함수가 종료되는 시점에 콜백 함수로 결과물을 받아왔습니다.
받아온 데이터는 JSONDecoder를 통해 데이터를 JSON형식으로 바꾼 후 필요한 데이터를 변수에 담아 사용했습니다.


#### UISearchController
검색 기능을 제공하는 UISearchController에 대해 이해하였습니다.
UISearchController를 선언하며 파라미터로 결과를 리턴할 searchResultsController에 ResultViewController()를 입력하였습니다.
또한 UISearchResultsUpdating 프로토콜을 확장하여 searchBar의 검색어가 변화할때마다 호출되는 메서드 updateSearchResults를 통해
ResultViewController의 컬렉션 뷰로 화면을 전환하였습니다.


#### UICollectionView
UITableView와 비슷하게 선언 후 view.addSubView()로 화면에 나타내고
UICollectionViewDataSource 프로토콜을 확장하여 Cell의 갯수와 구성등을 설정했습니다.
또한 UITableView와 달리 UICollectionViewFlowLayout()을 설정해야 했으며
Cell의 간격, 높이 등을 설정해야 했습니다.


## 🎬 완성된 모습
![화면 기록 2023-09-27 오전 1 12 27 복사본](https://github.com/kangsworkspace/DataStorage/assets/141600830/fbc7584d-996e-4ead-96e8-16e7b2eb135d)
![화면 기록 2023-09-27 오전 1 12 27 복사본 2](https://github.com/kangsworkspace/DataStorage/assets/141600830/45057c21-0170-4bdb-9d55-2ba9a0f2154c)


## 🙉 문제점 및 해결

#### `CollectionView`에서 셀이 출력이 되지 않는 문제가 발생하였습니다.
정확히는 Cell에 속한 `mainImageView`가 화면에 나타나지 않았습니다.
`addSubView(mainImageView)`로 분명히 화면에 나타냈고 오토 레이아웃을 설정했기에 오류를 찾는데 어려움을 겪었습니다..
단계적으로 문제점을 찾아갔는데 셀의 `backgoroundColor`를 `.blue`로 설정하면 셀이 표시가 되었기에 `CollectionView`와 `MusicCollectionViewCell`이 연결되었음을 확인했습니다.

![error](https://github.com/kangsworkspace/DataStorage/assets/141600830/5a2edcd9-ade9-42c0-bf7d-80f100f3b742)

따라서 문제는 `mainImageView`를 화면에 나타내는 부분에 있다고 생각하고 관련 코드를 점검했습니다.
문제는 오토 레이아웃을 설정하는 방법에 있었습니다.
에러가 난 코드에서는 오토레이아웃을 다음과 같이 설정하였습니다.
```swift
override func updateConstraints() {
    setupAutoLayout()
    super.updateConstraints()
}
```

이후 오토 레이아웃을 다음과 같이 `init()`에서 설정하여 해결했습니다.
```swift
override init(frame: CGRect) {
    super.init(frame: frame)

    setupMain()
}

// 셋업 - 메인
func setupMain() {

    setupAddView() 
    setupAutoLayout()
}
```
`updateConstraint()`에 대해 완전히 잘못 이해하고 있었는데 서브뷰에서 오토 레이아웃을 정할 때 사용하는 시점이라고 이해했었습니다.
다시 확인하니 `updateConstraint()`는 초기 설정 후 레이아웃이 변하는 동적인 상황에서 사용하는 것이었습니다.
