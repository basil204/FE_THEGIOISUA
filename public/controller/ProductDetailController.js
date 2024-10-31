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
