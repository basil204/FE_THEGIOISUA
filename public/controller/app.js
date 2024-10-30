var app = angular.module("myApp", ["ngRoute"]);

// Configure routes
app.config(function ($routeProvider) {
  $routeProvider
    .when("/home", {
      templateUrl: "Pages/home.html",
      controller: "ProductListController",
    })
    .when("/product-detail", {
      templateUrl: "Pages/product-detail.html",
      controller: "ProductDetailController",
    })
    .when("/login", {
      templateUrl: "Pages/login.html",
      controller: "",
    })
    .when("/sign-up", {
      templateUrl: "Pages/sign-up.html",
      controller: "",
    })
    .when("/cart", {
      templateUrl: "Pages/cart.html",
      controller: "ShoppingCartController",
    })
    .when("/profile", {
      templateUrl: "Pages/profile.html",
      controller: "ShoppingCartController",
    })
    .otherwise({
      redirectTo: "/home",
    });
});
app.service("ProductService", function () {
  return {
    setProduct: function (product) {
      sessionStorage.setItem("currentProduct", JSON.stringify(product));
    },
    getProduct: function () {
      const product = sessionStorage.getItem("currentProduct");
      return product ? JSON.parse(product) : null;
    },
    clearProduct: function () {
      sessionStorage.removeItem("currentProduct");
    },
    countProductOrders: function () {
      const orderList =
        JSON.parse(localStorage.getItem("lstProductOder")) || [];
      return orderList.filter((order) => order.id).length;
    },
  };
});

app.controller(
  "ProductListController",
  function ($scope, $http, $location, ProductService) {
    // Function to fetch products based on the provided URL
    $scope.getdataproduct = function (url) {
      $http.get(url).then(
        function (response) {
          $scope.products = response.data.message.content;
          console.log(response);
        },
        function (error) {
          console.error("Error fetching products:", error);
        }
      );
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

// Controller for handling product details
app.controller(
  "ProductDetailController",
  function ($scope, $location, $http, ProductService) {
    // Lấy sản phẩm từ ProductService
    const product = ProductService.getProduct(); // Lấy sản phẩm từ ProductService

    if (product) {
      // Kiểm tra nếu sản phẩm tồn tại
      $scope.product = product; // Gán sản phẩm cho scope
      // Biến trạng thái và chi tiết sản phẩm
      $scope.statusMilkDetail = "";
      $scope.priceMilkDetail = null;
      $scope.stockquantityMilkDetail = null;
      $scope.flavors = [];
      $scope.usageCapacities = [];
      $scope.packagingUnits = [];
      $scope.lstProductOder = [];
      $scope.productDetails = [];
      // Hàm gọi API lấy dữ liệu chi tiết sản phẩm
      function fetchMilkDetail() {
        const params = {
          packagingunitID: $scope.selectedPackagingUnit,
          milktasteID: $scope.selectedFlavor,
          productID: product.productID, // Sử dụng id từ sản phẩm
          usagecapacityID: $scope.selectedUsageCapacity,
        };

        const queryString = new URLSearchParams(params).toString();
        const jwtToken =
          "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjIiLCJzdWIiOiJoaWV1Iiwicm9sZSI6IkFkbWluIiwiaWF0IjoxNzI5OTUzMjAwLCJleHAiOjE3Mjk5ODkyMDB9.Ki0ODiX6lg5krb7E6t3N91ay4o064PfK0t7ZjCWQVcs";

        return $http({
          method: "GET",
          url: `http://160.30.21.47:1234/api/Milkdetail/getMilkDetail?${queryString}`,
          headers: {
            Authorization: `Bearer ${jwtToken}`,
          },
        })
          .then(function (response) {
            if (
              response.status === 200 &&
              response.data &&
              response.data.status !== "error" &&
              response.data.errors !== "Danh Sách Trống"
            ) {
              $scope.productDetails = response.data.message;
              $scope.priceMilkDetail = $scope.productDetails.price;
              $scope.stockquantityMilkDetail =
                $scope.productDetails.stockquantity;
              $scope.statusMilkDetail = "Còn Hàng";
            } else {
              $scope.productDetails = [];
              $scope.priceMilkDetail = 0;
              $scope.stockquantityMilkDetail = 0;
              $scope.statusMilkDetail = "Hết Hàng";
            }
          })
          .catch(function (error) {
            $scope.productDetails = [];
            $scope.priceMilkDetail = 0;
            $scope.stockquantityMilkDetail = 0;
            $scope.statusMilkDetail = "Hết Hàng";
          });
      }

      // Lấy dữ liệu các danh mục cần thiết và chi tiết sản phẩm
      Promise.all([
        $http.get("http://160.30.21.47:1234/api/Milktaste/lst"),
        $http.get("http://160.30.21.47:1234/api/Usagecapacity/lst"),
        $http.get("http://160.30.21.47:1234/api/Packagingunit/lst"),
      ]).then(function (responses) {
        $scope.flavors = responses[0].data;
        if ($scope.flavors.length > 0)
          $scope.selectedFlavor = $scope.flavors[0].id;

        $scope.usageCapacities = responses[1].data;
        if ($scope.usageCapacities.length > 0)
          $scope.selectedUsageCapacity = $scope.usageCapacities[0].id;

        $scope.packagingUnits = responses[2].data;
        if ($scope.packagingUnits.length > 0)
          $scope.selectedPackagingUnit = $scope.packagingUnits[0].id;

        return fetchMilkDetail();
      });

      // Hàm xử lý thay đổi chọn đơn vị đóng gói
      $scope.onPackagingUnitChange = function () {
        fetchMilkDetail();
      };

      $scope.oderProduct = function (IDProductDetail, stockquantityMilkDetail) {
        if (
          !stockquantityMilkDetail ||
          $scope.productDetails.stockquantity < stockquantityMilkDetail
        ) {
          Swal.fire({
            icon: "error",
            title: "Đặt Hàng Thất Bại",
            text: "Vui lòng nhập đúng số lượng!",
            footer:
              "Số Lượng Còn Lại: " + ($scope.productDetails.stockquantity || 0),
          });

          return;
        }
        // localStorage.removeItem("lstProductOder")
        let lstProductOder =
          JSON.parse(localStorage.getItem("lstProductOder")) || [];

        // Tạo một đối tượng sản phẩm để thêm vào danh sách đặt hàng
        const detailProduct = {
          id: IDProductDetail,
          productDetails: $scope.productDetails,
          quantity: stockquantityMilkDetail,
        };

        const existingProductIndex = lstProductOder.findIndex(
          (item) => item.id === IDProductDetail
        );

        if (existingProductIndex !== -1) {
          // Nếu sản phẩm đã tồn tại, chỉ cập nhật số lượng
          lstProductOder[existingProductIndex].quantity +=
            stockquantityMilkDetail;
        } else {
          // Nếu sản phẩm chưa tồn tại, thêm mới vào danh sách
          lstProductOder.push(detailProduct);
        }

        // Lưu lại danh sách vào localStorage
        localStorage.setItem("lstProductOder", JSON.stringify(lstProductOder));
        Swal.fire({
          position: "center", // Đặt vị trí thông báo ở giữa
          icon: "success",
          title: "Sản phẩm đã được thêm vào giỏ hàng!",
          showConfirmButton: false,
          timer: 1500,
        });
        // Kiểm tra và hiển thị danh sách đặt hàng
        console.log(
          "Danh sách đặt hàng:",
          JSON.stringify(lstProductOder, null, 2)
        );
      };
    } else {
      console.error("Không có sản phẩm để lấy thông tin.");
      // Xử lý khi không có sản phẩm, có thể điều hướng lại hoặc thông báo cho người dùng
      $location.path("/product-list").search({}); // Điều hướng về trang danh sách sản phẩm nếu không có sản phẩm
    }
  }
);

app.controller("ShoppingCartController", function ($scope, $location) {
  // Tải danh sách đặt hàng từ localStorage
  $scope.lstProductOder =
    JSON.parse(localStorage.getItem("lstProductOder")) || [];
  // console.log($scope.lstProductOder)
  // Hàm tính tổng tiền
  $scope.calculateTotal = function () {
    let total = 0;
    $scope.lstProductOder.forEach(function (item) {
      // Kiểm tra xem price và quantity có phải là số không
      const price = Number(item.productDetails.price); // Giả sử price nằm trong productDetails
      const quantity = Number(item.quantity); // quantity đã được thêm vào đối tượng detailProduct
      // Nếu giá trị là số, thì tính toán tổng
      if (!isNaN(price) && !isNaN(quantity)) {
        total += price * quantity; // Thực hiện phép nhân
      } else {
        console.error("Giá hoặc số lượng không hợp lệ:", item);
      }
    });
    return total;
  };

  // Cập nhật tổng tiền khi số lượng thay đổi
  $scope.updateTotal = function (product) {
    if (product.quantity > product.productDetails.stockquantity) {
      Swal.fire({
        icon: "error",
        title: "Đặt Hàng Thất Bại",
        text: "Vui lòng nhập đúng số lượng!",
        footer: "Số Lượng Còn Lại: " + product.productDetails.stockquantity,
      });
      return;
    }
    // Logic xử lý tổng tiền nếu cần
    localStorage.setItem(
      "lstProductOder",
      JSON.stringify($scope.lstProductOder)
    ); // Cập nhật localStorage
  };
  $scope.countProductOrders = function () {
    $scope.count = ProductService.countProductOrders();
  };
  // Xóa sản phẩm khỏi danh sách
  $scope.removeProduct = function (index) {
    Swal.fire({
      title: "Bạn có chắc chắn muốn xóa sản phẩm này?",
      text: "Hành động này không thể hoàn tác!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Vâng, xóa nó!",
      cancelButtonText: "Hủy bỏ",
    }).then((result) => {
      if (result.isConfirmed) {
        // Nếu người dùng xác nhận
        $scope.lstProductOder.splice(index, 1); // Xóa sản phẩm khỏi mảng
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.lstProductOder)
        );

        // Thông báo khi đã xóa thành công
        Swal.fire({
          icon: "success",
          title: "Đã xóa!",
          text: "Sản phẩm đã được xóa thành công.",
          timer: 1500,
          showConfirmButton: false,
        }).then(() => {
          // Sau khi thông báo thành công, cập nhật lại view
          $scope.$apply(); // Cập nhật lại view
        });
      }
    });
  };
});
