app.controller(
  "ProductListController",
  function ($scope, $http, $location, $routeParams, ProductService) {
    // Khởi tạo các biến
    $scope.isLogin = false;
    $scope.userName = "My Account";
    $scope.cartProducts = [];
    $scope.totalPrice = 0;
    $scope.products = [];
    $scope.currentPage = 1;

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));

    const Toast = Swal.mixin({
      toast: true,
      position: "top-right",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
    });

    // Kiểm tra trạng thái đăng nhập
    $scope.checkLogin = function () {
      if (userInfo) {
        $scope.isLogin = true;
        $scope.userName = userInfo.sub;
      }
    };
    $scope.checkLogin();

    // Lấy dữ liệu sản phẩm từ API
    $scope.getdataproduct = function (url, hasParams) {
      $http.get(url).then(
        function (response) {
          if (hasParams) {
            $scope.products = response.data.message.content || [];
          } else {
            $scope.products = response.data.message || [];
          }
        },
        function (error) {
          console.error("Error fetching products:", error);
        }
      );
    };

    $scope.getdataproducts = function () {
      $scope.getdataproduct(`http://160.30.21.47:1234/api/Product/page`, false);
    };

    $scope.loadProductsByFilter = function () {
      const params = $routeParams;

      if (params.type) {
        $scope.getdataproduct(
          `http://160.30.21.47:1234/api/Product/page/TypeMilk/${params.type}`,
          true
        );
      } else if (params.brand) {
        $scope.getdataproduct(
          `http://160.30.21.47:1234/api/Product/page/BrandMilk/${params.brand}`,
          true
        );
      } else if (params.target) {
        $scope.getdataproduct(
          `http://160.30.21.47:1234/api/Product/page/TargetUser/${params.target}`,
          true
        );
      } else {
        $scope.getdataproducts();
      }
    };

    // Gọi hàm load sản phẩm theo URL khi controller được khởi tạo
    $scope.loadProductsByFilter();

    // Điều hướng bộ lọc
    $scope.filterByType = function (typeId) {
      $location.path("/find").search({ type: typeId });
    };
    $scope.filterByBrand = function (brandId) {
      $location.path("/find").search({ brand: brandId });
    };
    $scope.filterByTargetUser = function (targetId) {
      $location.path("/find").search({ target: targetId });
    };

    // Quản lý giỏ hàng
    $scope.loadCartProducts = function () {
      $scope.cartProducts =
        JSON.parse(localStorage.getItem("lstProductOder")) || [];
      $scope.calculateTotalPrice();
    };

    $scope.calculateTotalPrice = function () {
      $scope.totalPrice = $scope.cartProducts.reduce((sum, product) => {
        return sum + product.quantity * product.productDetails.price;
      }, 0);
    };

    $scope.removeProduct = function (product) {
      const index = $scope.cartProducts.indexOf(product);
      if (index > -1) {
        $scope.cartProducts.splice(index, 1);
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.cartProducts)
        );
        $scope.calculateTotalPrice();
      }
    };

    $scope.loadCartProducts();

    // Lấy dữ liệu dropdown (Loại, Hãng, Đối tượng)
    $scope.getDropdownData = function () {
      $http.get("http://160.30.21.47:1234/api/Milktype/lst").then(
        (response) => ($scope.milktypes = response.data),
        (error) => console.error("Error fetching milk types:", error)
      );

      $http.get("http://160.30.21.47:1234/api/Milkbrand/lst").then(
        (response) => ($scope.milkbrands = response.data),
        (error) => console.error("Error fetching milk brands:", error)
      );

      $http.get("http://160.30.21.47:1234/api/Targetuser/lst").then(
        (response) => ($scope.targetusers = response.data),
        (error) => console.error("Error fetching target users:", error)
      );
    };

    $scope.getDropdownData();

    // Lấy danh sách banner
    $scope.getBanners = function () {
      $http.get("http://160.30.21.47:3000/api/data").then(
        (response) => {
          $scope.banner1 = response.data.filter((item) => item.banner === "1");
          $scope.banner2 = response.data.filter((item) => item.banner === "2");
        },
        (error) => console.error("Error fetching banners:", error)
      );
    };

    $scope.getBanners();

    // Lấy danh sách sản phẩm nổi bật và sản phẩm mới
    $scope.getBestSellers = function () {
      $http.get("http://160.30.21.47:1234/api/Product/lstbestseller").then(
        (response) => ($scope.bestsellers = response.data.content || []),
        (error) => console.error("Error fetching best sellers:", error)
      );
    };

    $scope.getNewProducts = function () {
      $http.get("http://160.30.21.47:1234/api/Product/lstnewproduct").then(
        (response) => ($scope.newproducts = response.data.content || []),
        (error) => console.error("Error fetching new products:", error)
      );
    };

    $scope.getBestSellers();
    $scope.getNewProducts();

    // Xem chi tiết sản phẩm
    $scope.viewDetail = function (product) {
      ProductService.clearProduct();
      ProductService.setProduct(product);
      console.log(product)
      const productUrl = product.productUrl; // Kiểm tra cả hai
      $location.path("/product-detail").search({ productURL: productUrl });
    };

    // Đếm số lượng sản phẩm trong giỏ hàng
    $scope.countProductOrders = function () {
      $scope.count = $scope.cartProducts.reduce(
        (count, product) => count + product.quantity,
        0
      );
    };

    $scope.countProductOrders();
  }
);
