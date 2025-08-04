<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Carousel 실습</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .carousel-inner img {
      width: 100%;
      height: 400px;
      object-fit: cover;
    }
  </style>
</head>
<body>

<div class="container mt-5">
  <h2>Bootstrap Carousel 예제</h2>
  <div id="myCarousel" class="carousel slide" data-bs-ride="carousel">

    <!-- 인디케이터 (하단 점 버튼) -->
    <div class="carousel-indicators">
      <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="0" class="active"></button>
      <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="1"></button>
      <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="2"></button>
    </div>

    <!-- 슬라이드 이미지들 -->
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img src="https://placekitten.com/800/400" class="d-block w-100" alt="고양이 1">
      </div>
      <div class="carousel-item">
        <img src="https://placekitten.com/801/400" class="d-block w-100" alt="고양이 2">
      </div>
      <div class="carousel-item">
        <img src="https://placekitten.com/802/400" class="d-block w-100" alt="고양이 3">
      </div>
    </div>

    <!-- 좌우 화살표 버튼 -->
    <button class="carousel-control-prev" type="button" data-bs-target="#myCarousel" data-bs-slide="prev">
      <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#myCarousel" data-bs-slide="next">
      <span class="carousel-control-next-icon"></span>
    </button>

  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
