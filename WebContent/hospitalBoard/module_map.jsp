<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% request.setCharacterEncoding("UTF-8");%>
<% response.setContentType("text/html; charset=UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style type="text/css">
      .map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
      .map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}
      .map_wrap {position:relative;width:100%;height:500px;}
      #menu_wrap {position:absolute;top:0;left:0;bottom:0;width:250px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(255, 255, 255, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}
      .bg_white {background:#fff;}
      #menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
      #menu_wrap .option{text-align: center;}
      #menu_wrap .option p {margin:10px 0;}  
      #menu_wrap .option button {margin-left:5px;}
      #placesList li {list-style: none;}
      #placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
      #placesList .item span {display: block;margin-top:4px;}
      #placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
      #placesList .item .info{padding:10px 0 10px 55px;}
      #placesList .info .gray {color:#8a8a8a;}
      #placesList .info .jibun {padding-left:26px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
      #placesList .info .tel {color:#009900;}
      #placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
      #placesList .item .marker_1 {background-position: 0 -10px;}
      #placesList .item .marker_2 {background-position: 0 -56px;}
      #placesList .item .marker_3 {background-position: 0 -102px}
      #placesList .item .marker_4 {background-position: 0 -148px;}
      #placesList .item .marker_5 {background-position: 0 -194px;}
      #placesList .item .marker_6 {background-position: 0 -240px;}
      #placesList .item .marker_7 {background-position: 0 -286px;}
      #placesList .item .marker_8 {background-position: 0 -332px;}
      #placesList .item .marker_9 {background-position: 0 -378px;}
      #placesList .item .marker_10 {background-position: 0 -423px;}
      #placesList .item .marker_11 {background-position: 0 -470px;}
      #placesList .item .marker_12 {background-position: 0 -516px;}
      #placesList .item .marker_13 {background-position: 0 -562px;}
      #placesList .item .marker_14 {background-position: 0 -608px;}
      #placesList .item .marker_15 {background-position: 0 -654px;}
      #pagination {margin:10px auto;text-align: center;}
      #pagination a {display:inline-block;margin-right:10px;}
      #pagination .on {font-weight: bold; cursor: default;color:#777;}
      .detailView{background-color: wheat; color:salmon; padding: 3px 10px; border-radius:3px; border: 2px solid salmon;}
      .bookableMap{text-align:center; background-color:salmon;color:white;border-radius:3px;}
      .bookableBtn{background-color:#fae8ac;color:salmon;border:2px solid white;padding: 3px 20px;border-radius:4px cursor:pointer;font-style:strong;}
      .mapHeader{text-align:center;color:white;background-color:salmon;border-radius:4px;margin: 7px;padding:5px; }
</style>

<body>
	<div class="mapHeader"> Insert title </div>
	<div class="map_wrap">
          <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
      
          <div id="menu_wrap" class="bg_white">
              <div class="option">
                  <div>
                      <form onsubmit="searchPlaces(); return false;">
                          키워드 : <input type="text" value="" id="keyword" size="15"> 
                          <button type="submit">검색</button> 
                      </form>
                  </div>
              </div>
              <hr>
              <ul id="placesList"></ul>
              <div id="pagination"></div>
          </div>
      </div>
      <p class="bookableMap">
      	<input class="bookableBtn" type="button" value="Click" onclick="addressToMarker();"/>
      </p>
      <!-- 카카오맵 api키 -->
 <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dc7ccb141837d7f5a52ed786b3831578&libraries=services"></script>
    
 <script>
      // 마커를 담을 배열
      var markers = [];
      
      var mapContainer = document.getElementById('map'), 
          mapOption = {
              center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
              level: 9 // 지도의 확대 레벨
          };  
      
      // 지도
      var map = new kakao.maps.Map(mapContainer, mapOption); 
      
      // 장소 검색 객체
      var ps = new kakao.maps.services.Places();  
      
      // 검색 결과 목록
      var infowindow = new kakao.maps.InfoWindow({zIndex:1});
      
     
      searchPlaces();
      
      // 키워드 검색
      function searchPlaces() {
      
          var keyword = document.getElementById('keyword').value;

          ps.keywordSearch( keyword, placesSearchCB); 
      }
      
      // 장소검색이 완료됐을 때 호출
      function placesSearchCB(data, status, pagination) {
          if (status === kakao.maps.services.Status.OK) {
      
              // 검색이 완료됐으면 검색 목록과 마커표시
              displayPlaces(data);
      
              // 페이지 번호
              displayPagination(pagination);
      
          } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
      
              alert('검색 결과가 존재하지 않습니다.');
              return;
      
          } else if (status === kakao.maps.services.Status.ERROR) {
      
              alert('검색 결과 중 오류가 발생했습니다.');
              return;
      
          }
      }
      
      // 검색 결과 목록과 마커를 표출하는 함수입니다
      function displayPlaces(places) {
      
          var listEl = document.getElementById('placesList'), 
          menuEl = document.getElementById('menu_wrap'),
          fragment = document.createDocumentFragment(), 
          bounds = new kakao.maps.LatLngBounds(), 
          listStr = '';
          
          // 검색 결과 목록에 추가된 항목들을 제거합니다
          removeAllChildNods(listEl);
      
          // 지도에 표시되고 있는 마커를 제거합니다
          removeMarker();
          
          for ( var i=0; i<places.length; i++ ) {
      
              // 마커를 생성하고 지도에 표시합니다
              var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                  marker = addMarker(placePosition, i), 
                  itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다
      
              // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
              // LatLngBounds 객체에 좌표를 추가합니다
              bounds.extend(placePosition);
      
              // 마커와 검색결과 항목에 mouseover 했을때
              // 해당 장소에 인포윈도우에 장소명을 표시합니다
              // mouseout 했을 때는 인포윈도우를 닫습니다
              (function(marker, title) {
                  kakao.maps.event.addListener(marker, 'mouseover', function() {
                      displayInfowindow(marker, title);
                  });
      
                  kakao.maps.event.addListener(marker, 'mouseout', function() {
                      infowindow.close();
                  });
      
                  itemEl.onmouseover =  function () {
                      displayInfowindow(marker, title);
                  };
      
                  itemEl.onmouseout =  function () {
                      infowindow.close();
                  };
              })(marker, places[i].place_name);
      
              fragment.appendChild(itemEl);
          }
      
          // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
          listEl.appendChild(fragment);
          menuEl.scrollTop = 0;
      
          // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
          map.setBounds(bounds);
      }
      
      // 검색결과 항목을 Element로 반환하는 함수입니다
      function getListItem(index, places) {
      
          var el = document.createElement('li'),
          itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                      '<div class="info">' +
                      '   <h5>' + places.place_name + '</h5>';
      
          if (places.road_address_name) {
              itemStr += '    <span>' + places.road_address_name + '</span>' +
                          '   <span class="jibun gray">' +  places.address_name  + '</span>';
          } else {
              itemStr += '    <span>' +  places.address_name  + '</span>'; 
          }
                       
            itemStr += '  <span class="tel">' + places.phone  + '</span>' ;
           <%--상세보기 클릭 시, 관련 페이지로 넘어가도록 추가 --%>                    
            itemStr += '<br><a class="detailView" href=' + places.place_url;
            itemStr += ' target="_blank"> 상세보기 </a>' + '</div>'; 
          el.innerHTML = itemStr;
          el.className = 'item';
      
          return el;
      }
      
      // 마커를 생성하고 지도 위에 마커를 표시
      function addMarker(position, idx, title) {
          var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
              imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
              imgOptions =  {
                  spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
                  spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
                  offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
              },
              markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
                  marker = new kakao.maps.Marker({
                  position: position, // 마커의 위치
                  image: markerImage 
              });
      
          marker.setMap(map); // 지도 위에 마커
          markers.push(marker);  // 배열에 생성된 마커를 추가합니다
      
          return marker;
      }
      
      // 지도 위에 표시되고 있는 마커를 모두 제거
      function removeMarker() {
          for ( var i = 0; i < markers.length; i++ ) {
              markers[i].setMap(null);
          }   
          markers = [];
      }
      
      // 페이지번호
      function displayPagination(pagination) {
          var paginationEl = document.getElementById('pagination'),
              fragment = document.createDocumentFragment(),
              i; 
      
        
          while (paginationEl.hasChildNodes()) {
              paginationEl.removeChild (paginationEl.lastChild);
          }
      
          for (i=1; i<=pagination.last; i++) {
              var el = document.createElement('a');
              el.href = "#";
              el.innerHTML = i;
      
              if (i===pagination.current) {
                  el.className = 'on';
              } else {
                  el.onclick = (function(i) {
                      return function() {
                          pagination.gotoPage(i);
                      }
                  })(i);
              }
      
              fragment.appendChild(el);
          }
          paginationEl.appendChild(fragment);
      }
      
      // 검색결과 목록 또는 마커를 클릭했을 때 
      // 인포윈도우에 장소명을 표시
      function displayInfowindow(marker, title) {
          var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';
      
          infowindow.setContent(content);
          infowindow.open(map, marker);
      }
      
       // 검색결과 목록의 자식 Element를 제거
      function removeAllChildNods(el) {   
          while (el.hasChildNodes()) {
              el.removeChild (el.lastChild);
          }
      }
       
      //주소(도로명주소),이름을 지도상에 마커로 표시하는 함수
      function addressToMarker(url,type,dataType){
    	 // 1. ajax를 이용해 db에서 값을 받아온 뒤, 마커로 표시하는 방식
    		 var url = "../pet.do?command=bookableMap";
          	 var type = "Post";
             var dataType = "json";
       
	  		$.ajax({
	  			url : url,
	  			type: type,
	  			dataType : dataType,
	  			success:function(data){
	  						
	 				//자바스크립트는 [][] 이렇게 2차원배열 생성 불가해서 아래처럼 만들어줘야한다
	  				var list = new Array();
	  				for(var i = 0; i<data.length;i++){
	  					
	  						list[i] = new Array();
	  						//list[i][0]: 주소
	  						//list[i][1]: 이름
	  						list[i][0] = data[i].business_addr;
	  						list[i][1] = data[i].business_name;
						
	  				} 				
	  				//주소로 위도,경도 변환해줄 객체
	  		  	   var geocoder = new daum.maps.services.Geocoder();
	  				//지도에 마커로 표시
	  		  	   list.forEach(function(addr, index) { 
	  		  		  geocoder.addressSearch(addr[0], function(result, status) { 
	  		  			  if (status === daum.maps.services.Status.OK) { 
	  		  				  var coords = new daum.maps.LatLng(result[0].y, result[0].x);
	  		  				  var marker = new daum.maps.Marker({ position: coords, clickable: true });
	  		  				  
	  		  				  marker.setMap(map); 
	  		  				  
	  		  				 //마커클릭시 이름표시되는 부분css
	  		  				  var infowindow = new kakao.maps.InfoWindow({ content: '<div style="width:150px;text-align:center;padding:6px 0; background-color:wheat; color:salmon;">' + addr[1] + '</div>', removable : true });
	  		  				 //클릭하면 표시
	  		  				  kakao.maps.event.addListener(marker, 'click', function() { 
	  		  						  infowindow.open(map, marker); 
	  		  				 
	  		  					  });
	  		  				  } 
	  		  			  });
	  		  		  });
	  		 
	  			
	  			},
	  			error:function(){
	  				alert("통신 실패");
	  			}
  			
  		});
    	 
    	
  		
     } 
	

   	 
  	       
      </script>
	



</body>
</html>