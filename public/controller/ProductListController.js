app.controller(
  "ProductListController",
  function ($scope, $http, $location, ProductService) {
    // Function to fetch products based on the provided URL
    $scope.isLogin = false; // Giá trị mặc định
    $scope.userName = "My Account";
    $scope.checkLogin = function () {
      const userInfo = JSON.parse(localStorage.getItem("userInfo"));
      if (userInfo != null) {
        $scope.isLogin = true;
        $scope.userName = userInfo.sub;
      }
    };
    $scope.getdataproduct = function (url) {
      $http.get(url).then(
        function (response) {
          $scope.products = response.data.message.content;
        },
        function (error) {
          console.error("Error fetching products:", error);
        }
      );
    };
    $scope.cartProducts =
      JSON.parse(localStorage.getItem("lstProductOder")) || [];

    // Calculate total price
    $scope.totalPrice = $scope.cartProducts.reduce(function (sum, product) {
      return sum + product.quantity * product.productDetails.price;
    }, 0);

    // Function to remove a product from the cart
    $scope.removeProduct = function (product) {
      const index = $scope.cartProducts.indexOf(product);
      if (index > -1) {
        $scope.cartProducts.splice(index, 1);
        // Update localStorage after removing the product
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.cartProducts)
        );

        // Recalculate total price
        $scope.totalPrice = $scope.cartProducts.reduce(function (sum, product) {
          return sum + product.quantity * product.productDetails.price;
        }, 0);
      }
    };
    // Fetch list of milk types
    $scope.getMilktaste = function () {
      $http.get("http://160.30.21.47:1234/api/Milktype/lst").then(
        function (response) {
          $scope.milktypes = response.data;
        },
        function (error) {
          console.error("Error fetching milk types:", error);
        }
      );
    };

    // Fetch list of milk brands
    $scope.getMilkbrands = function () {
      $http.get("http://160.30.21.47:1234/api/Milkbrand/lst").then(
        function (response) {
          $scope.milkbrands = response.data;
        },
        function (error) {
          console.error("Error fetching milk brands:", error);
        }
      );
    };

    // Fetch list of target users
    $scope.getTargetusers = function () {
      $http.get("http://160.30.21.47:1234/api/Targetuser/lst").then(
        function (response) {
          $scope.targetusers = response.data;
        },
        function (error) {
          console.error("Error fetching target users:", error);
        }
      );
    };

    // Filtering functions with routing to products page
    $scope.filterByType = function (typeId) {
      $location.path("/home").search({ type: typeId });
    };

    $scope.filterByBrand = function (brandId) {
      $location.path("/home").search({ brand: brandId });
    };

    $scope.filterByTargetUser = function (targetUserId) {
      $location.path("/home").search({ target: targetUserId });
    };

    // Fetch initial data for dropdowns
    $scope.getMilktaste();
    $scope.getTargetusers();
    $scope.getMilkbrands();

    // Check URL parameters and filter products accordingly
    $scope.checkFilter = function () {
      var params = $location.search();
      if (params.type) {
        $scope.getdataproduct(
          `http://160.30.21.47:1234/api/Product/page/TypeMilk/${params.type}`
        );
      } else if (params.brand) {
        $scope.getdataproduct(
          `http://160.30.21.47:1234/api/Product/page/BrandMilk/${params.brand}`
        );
      } else if (params.target) {
        $scope.getdataproduct(
          `http://160.30.21.47:1234/api/Product/page/TargetUser/${params.target}`
        );
      } else {
        $scope.getdataproduct("http://160.30.21.47:1234/api/Product/page");
      }
    };
    $scope.viewDetail = function (product) {
      // Lưu sản phẩm vào ProductService
      ProductService.clearProduct();
      ProductService.setProduct(product);

      // Điều hướng đến trang chi tiết sản phẩm với chỉ url
      $location
        .path("/product-detail")
        .search({ productURL: product.productURL });
    };
    $scope.countProductOrders = function () {
      $scope.count = ProductService.countProductOrders();
    };

    // Call checkFilter when the controller is initialized
    $scope.checkFilter();
    $scope.countProductOrders();
  }
);
