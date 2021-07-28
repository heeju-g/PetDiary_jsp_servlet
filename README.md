# :pushpin: Pet Diary
>반려동물과 함께 하는 삶에 필요한 기능을 모은 웹사이트    
>기획안 링크 : [Click](https://www.notion.so/9e7fe502eb814e82a649b57b8a466582 "notion link")   

### 프로젝트 전체 기능     

<details>
<summary><b>전체 기능 설명 펼치기</b></summary>
<div markdown="1"> </br>  
   1. 로그인/회원가입 – 로그인(소셜로그인 지원) , 회원가입 및 아이디 비밀번호 찾기, 이메일 인증 기능 </br></br>    
   2. 캘린더 - 해당 날짜의 일정 확인, 추가, 수정, 삭제하는 기능   </br></br>    
   3. 결제 - 예약 수수료 결제 기능, 화상채팅 진료시간에 따른 결제, 업체 서비스 이용료 결제   </br></br>    
   4. 게시판 - 병원/식당/여행/정보공유 게시판 글 작성 수정, 삭제, 댓글작성, 선택, 확인 등의 기능   </br></br>    
   5. 예약 - 예약 페이지 리스트 구현, 문자발송, 예약기능   </br></br>    
   6. 닮은 동물 찾기 - 머신러닝(특정 동물과 닮은 연예인 사진 이용)을 통해 실제 사용자의 웹캠 혹은 사진 업로드 시, 닮은 동물을 찾는 기능    </br></br>    
   7. 날씨 - 원하는 지역 날씨정보 제공   </br></br>    
   8. 지도 - 가게 및 병원 등의 위치 표기 및 거리, 이동시간 확인기능. 데이터베이스에 등록된 업체 위치 표기 및 검색기능   </br></br>    
   9. 비속어 필터링 - 게시글에서 필터링 기능을 통해 비속어로 판단되는 단어를 특수문자로 변경   </br></br>    
   10. 화상채팅 - 원격 진료 기능 구현   </br></br>    
   11. 챗봇 - AI 대화처리를 통해 병원 예약과 반려동물 관련 질의응답 기능   
</div>
</details>
</br>

## 1. 제작 기간 & 참여 인원
- 21.04.12 ~ 21.05.07 
- TEAM : 6명(이장근, 박관우, 심희주, 김인겸, 한지현, 김정규)  

</br>

## 2. 사용 기술
#### `Back-end`
  - <img src="https://img.shields.io/badge/9-Java-red"/> 
  - <img src="https://img.shields.io/badge/Mybatis-grey"/>
  - <img src="https://img.shields.io/badge/3.9-Python-blue"/>
  - <img src="https://img.shields.io/badge/11-Oracle-yellow"/>
  - <img src="https://img.shields.io/badge/node.js-green"/>
 
#### `Front-end`
  - <img src="https://img.shields.io/badge/Javacript-red"/>
  - <img src="https://img.shields.io/badge/html/css-orange"/>

</br>

## 3. ERD 설계   
![](https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F3af238f9-c97e-4031-8aa2-38ddbf5ddec6%2FCopy_of_(1%EC%B0%A8_%EC%88%98%EC%A0%95)%EB%B0%98%EB%A0%A4%EB%8F%99%EB%AC%BC_%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC.png?table=block&id=a2f64a55-ca72-42f8-8561-e02bfe8a41f8&spaceId=02035cac-9dbb-4a33-9431-b4b67098f6ba&width=2840&userId=7b670629-fe67-41bb-a78d-7cbf6af5b506&cache=v2)

## 4. 트러블 슈팅
### 4.1. 지도 api와 데이터베이스 연결
- 지도에서 특정 버튼을 클릭할 시, 데이터베이스에 등록된 업체(병원 및 가게)들을 지도 상에 마커로 표시하여 사용자가 한 눈에 확인할 수 있도록 구현하고자 하였습니다. 해당 기능을 구현하기 위해 세 가지 질문에 관한 해결 방안을 생각해보았습니다.   
   
  - **'도로명 주소, 업체명이 담긴 리스트에서 어떻게 하나씩 가져와 뿌려줄 수 있을까'**   
   ->  각 업체의 정보 리스트를 가져와 반복문을 사용하여 JSON 객체에 도로명주소, 업체명을 하나씩 담아주고, 이를 JSON배열에 담아서 보내주는 방식으로 해결하였습니다.  
  - **'사용한 api에선 주소의 위도 및 경도 정보가 필요한데 도로명 주소를 어떤 방법으로 변환해야 할까'**   
   -> 도로명주소를 위도, 경도 좌표로 변환해주는 라이브러리(daum.maps.services)를 사용하여 변환해주었습니다.   
  - **'ajax 사용여부'**   
   -> 페이지를 새로 로딩하여 지도를 다시 띄우는 방법보단, 이미 띄워진 지도에 사용자가 원할 경우 업체 리스트를 마커로 표시되도록 구현하고자 하였습니다. 이는 ajax 비동기 통신을 사용하여 업체 리스트 데이터만 받아와 지도에 표시하는 것으로 해결하였습니다.

