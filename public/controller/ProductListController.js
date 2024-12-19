app.controller(
  "ProductListController",
  function ($scope, $http, $location, ProductService) {
    // Initialization
    $scope.currentPage = 0;
    $scope.pageSize = 6;
    $scope.isLogin = false;
    $scope.userName = "My Account";
    $scope.cartProducts = [];
    $scope.totalPrice = 0;

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    const Toast = Swal.mixin({
      toast: true,
      position: "top-right",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
    });

    // Check login status
    $scope.checkLogin = function () {
      if (userInfo) {
        $scope.isLogin = true;
        $scope.userName = userInfo.sub;
      }
    };

    $scope.checkLogin();

    // Fetch products data
    $scope.getProducts = function (url) {
      $http.get(url).then(
        function (response) {
          $scope.products = response.data.message.content;
        },
        function (error) {
          console.error("Error fetching products:", error);
        }
      );
    };

    // Load cart products and calculate total price
    $scope.loadCartProducts = function () {
      $scope.cartProducts =
        JSON.parse(localStorage.getItem("lstProductOder")) || [];
      $scope.totalPrice = $scope.cartProducts.reduce(
        (sum, product) => sum + product.quantity * product.productDetails.price,
        0
      );
    };

    $scope.loadCartProducts();

    // Remove product from cart
    $scope.removeProduct = function (product) {
      const index = $scope.cartProducts.indexOf(product);
      if (index > -1) {
        $scope.cartProducts.splice(index, 1);
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.cartProducts)
        );
        $scope.totalPrice = $scope.cartProducts.reduce(
          (sum, product) =>
            sum + product.quantity * product.productDetails.price,
          0
        );
      }
    };

    // Fetch initial data
    $scope.getDropdownData = function () {
      $http.get("http://160.30.21.47:1234/api/Milktype/lst").then(
        function (response) {
          $scope.milktypes = response.data;
        },
        function (error) {
          console.error("Error fetching milk types:", error);
        }
      );

      $http.get("http://160.30.21.47:1234/api/Milkbrand/lst").then(
        function (response) {
          $scope.milkbrands = response.data;
        },
        function (error) {
          console.error("Error fetching milk brands:", error);
        }
      );

      $http.get("http://160.30.21.47:1234/api/Targetuser/lst").then(
        function (response) {
          $scope.targetusers = response.data;
        },
        function (error) {
          console.error("Error fetching target users:", error);
        }
      );
    };

    $scope.getDropdownData();

    // Fetch banner data
    $scope.getBanners = function () {
      $http.get("http://160.30.21.47:3000/api/data").then(
        function (response) {
          $scope.banner1 = response.data.filter((item) => item.banner === "1");
          $scope.banner2 = response.data.filter((item) => item.banner === "2");
        },
        function (error) {
          console.error("Error fetching banners:", error);
        }
      );
    };

    $scope.getBanners();

    // Fetch product lists
    $scope.getBestSellers = function () {
      $http.get("http://160.30.21.47:1234/api/Product/lstbestseller").then(
        function (response) {
          $scope.bestsellers = response.data.content;
        },
        function (error) {
          console.error("Error fetching best sellers:", error);
        }
      );
    };

    $scope.getNewProducts = function () {
      $http.get("http://160.30.21.47:1234/api/Product/lstnewproduct").then(
        function (response) {
          $scope.newproducts = response.data.content;
        },
        function (error) {
          console.error("Error fetching new products:", error);
        }
      );
    };

    $scope.getBestSellers();
    $scope.getNewProducts();

    // Pagination controls
    $scope.changePage = function (page) {
      $scope.currentPage = page;
      $scope.loadPagedProducts();
    };

    $scope.loadPagedProducts = function () {
      $http
        .get(
          `http://160.30.21.47:1234/api/Product/page?page=${$scope.currentPage}&size=${$scope.pageSize}`
        )
        .then(
          function (response) {
            $scope.products = response.data.message.content;
            $scope.pageInfo = response.data.message.page;
          },
          function (error) {
            console.error("Error fetching products:", error);
          }
        );
    };
    $scope.nextPage = function () {
      if ($scope.currentPage < $scope.pageInfo.totalPages - 1) {
        $scope.currentPage++;
        $scope.loadPagedProducts();
      }
    };

    $scope.previousPage = function () {
      if ($scope.currentPage > 0) {
        $scope.currentPage--;
        $scope.loadPagedProducts();
      }
    };

    $scope.goToFirstPage = function () {
      $scope.currentPage = 0;
      $scope.loadPagedProducts();
    };

    $scope.goToLastPage = function () {
      $scope.currentPage = $scope.pageInfo.totalPages - 1;
      $scope.loadPagedProducts();
    };
    $scope.loadPagedProducts();

    // Filter products by type, brand, or target user
    $scope.applyFilters = function () {
      const params = $location.search();
      let url = "http://160.30.21.47:1234/api/Product/page";

      if (params.type) {
        url = `${url}/TypeMilk/${params.type}`;
      } else if (params.brand) {
        url = `${url}/BrandMilk/${params.brand}`;
      } else if (params.target) {
        url = `${url}/TargetUser/${params.target}`;
      } else if (params.key) {
        url = `${url}/getPageProductWithSearch/${params.key}`;
      }

      $scope.getProducts(url);
    };

    $scope.applyFilters();

    // View product details
    $scope.viewDetail = function (product) {
      ProductService.clearProduct();
      ProductService.setProduct(product);
      const productUrl = product.productURL || product.productUrl; // Kiểm tra cả hai
      $location.path("/product-detail").search({ productURL: productUrl });
    };

    // Count ordered products
    $scope.countProductOrders = function () {
      $scope.count = ProductService.countProductOrders();
    };

    $scope.countProductOrders();
  }
);
