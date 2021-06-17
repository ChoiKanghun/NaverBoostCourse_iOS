# BoostCourse iOS (by. Yagom)

처음으로 xcode를 접하고 많은 것들을 배울 수 있었던 프로젝트 기반의 교육과정입니다.

해당 Repository는 그 배움의 기록들을 저장해놓은 공간입니다.

총 5가지의 프로젝트를 진행했으며, 해당 프로젝트들은 몇 시간도 안 걸리는 아주 간단한 프로젝트부터 약 한 달 간의 노력을 들여 완성한 프로젝트까지 난이도별로 구성되어 있습니다.

또한 프로젝트를 하기에 앞서 각각의 코스는 난이도별로 강의를 먼저 제공합니다. 이들 강의에서 제공하는 지식을 가지고 프로젝트를 진행하였습니다.

언어는 `Swift5`, 뷰는 `UIKit` 을 이용했고, 프로젝트를 진행하면서 `GCD, URLSession 통신, Delegate & DataSource` 등 iOS 애플리케이션 개발에 필수적이고 기초적인 개념들을 학습하고 프로젝트를 통해 다루어보았습니다.

<br>

기간: 2020.10 ~ 


<br>



# Course1. 음원 재생기 애플리케이션

iOS 애플리케이션을 만들기 위한 환경에 대해 배울 수 있었습니다.

xcode 설치부터 시작해 `IBOutlet`과 `IBAction`, 그리고 각종 `UI` 들을 공부할 수 있었습니다.

또한 오토레이아웃(constraints)과 MVC 패턴에 대해 이해하고 적용했습니다.



<br>



![01](https://user-images.githubusercontent.com/41955126/120279928-02378800-c2f2-11eb-82e3-ccef3c704702.gif)



<br>



# Course2. 회원가입 화면 구현

해당 코스에서는 네비게이션 인터페이스와 모달에 대해 학습하고 구현해보았습니다.

또한 Delegate를 이용해 상태변화를 감지해보았습니다.

Singleton 패턴을 이용해 어떤 viewController 하나가 dismiss 된 상황에서도 정보를 가지고 있어야 할 상황에 대비해 객체를 만들어 활용하였습니다.

Gesture Recognizer를 이용해 어떤 요소에 대한 사용자와의 상호작용을 구현했습니다.



<br>



![2](https://user-images.githubusercontent.com/41955126/120279903-fba91080-c2f1-11eb-8e2f-1d3700484124.gif)



<br>



# Course3. 날씨 앱

TableView를 접해보면서 Delegate와 DataSource에 대해 익혔습니다. 

customCell을 사용해보고, 메모리 관리를 위해 cell을 reuse하는 법부터 다졌습니다.

storyBoard의 segue에 대해 이해하고, 다음 ViewController에 데이터를 전달하는 법에 대해 익혔습니다.

JSON을 Encode/Decode 하고 URLSession을 이용해 통신하는 법에 대해 익혔습니다.



<br>



![3](https://user-images.githubusercontent.com/41955126/120279947-05cb0f00-c2f2-11eb-8e9c-e85a47d6c246.gif)



<br>



# Course4. 사진첩 앱

내 사진첩에 있는 사진들을 가져와서 나만의 앨범을 만들어보았습니다.

이 과정에서 GCD의 OperationQueue를 이용해 비동기 처리를 백그라운드에서 진행해보았습니다.

스크롤뷰를 통해 storyBoard에서 보는 화면보다 더 길어진 뷰를 구현해보았습니다.

Navigation Item과 Bar Button Item을 다뤄봤고,

CollectionView를 사용해 앨범형으로 사진들을 나타내보았습니다.

이 과정에서 UICollectionViewFlowLayout에 대해 익히면서 부가적으로 UIScreen 속성에 대해서도 배우고 활용해보았습니다.



<br>



![4](https://user-images.githubusercontent.com/41955126/120279937-04014b80-c2f2-11eb-9bd2-7f86ce63f89d.gif)



<br>



# Course5. 영화정보 애플리케이션

Alert와 ActionSheet를 배우고 활용해보았습니다.

TabBar Controller로 같은 데이터에 대해 TableView와 CollectionView로 나누어 화면을 구성해보았습니다.

URLSession을 이용해 서버와 통신하고 DispatchQueue를 이용하면서 통신 및 GCD 활용을 좀 더 깊이있게 해보았습니다.

NotificationCenter를 이용해 화면 간 데이터 처리에 대해 제가 원하는 시점에 원하는 데이터를 주고받을 수 있도록 하는 것을 익혔습니다.



<br>



![5](https://user-images.githubusercontent.com/41955126/120279944-05327880-c2f2-11eb-93f6-a04612753833.gif)

