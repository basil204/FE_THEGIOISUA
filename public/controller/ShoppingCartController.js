app.controller("ShoppingCartController", function ($scope, $location, $http) {
  // Tải danh sách đặt hàng từ localStorage
  $scope.lstProductOder =
    JSON.parse(localStorage.getItem("lstProductOder")) || [];
  const authToken = localStorage.getItem("authToken");
  const userInfo = JSON.parse(localStorage.getItem("userInfo"));
  const urlInvoice = 'http://localhost:1234/api/Invoice/add';
  const urlUserInvoice = 'http://localhost:1234/api/Userinvoice/add';
  $scope.selectedPaymentMethod = "";
  console.log($scope.lstProductOder)
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
  $scope.buttonThanhToan = function () {
    if ($scope.lstProductOder.length < 1) {
      window.location.href = "/home";
    } else {
      window.location.href = "/checkout";
    }
  }

  $scope.createInvoice = function () {
    // Khởi tạo hóa đơn
    $scope.invoice = {
      voucher: null,
      discountamount: 0,
      totalamount: $scope.calculateTotal()
    };
    console.log("Total Amount:", $scope.invoice.totalamount);
    // Kiểm tra phương thức thanh toán
    if (!$scope.selectedPaymentMethod) {
      showAlert("Vui Lòng Chọn Phương Thức Thanh Toán!", "error");
      return;
    }
    if ($scope.selectedPaymentMethod === "COD") {
      showAlert("Chức năng Hiện Chưa Khả Dụng!", "error");
      return;
    }

    // Dữ liệu cần gửi cho API
    const data = {
      invoice: $scope.invoice,
      paymentOption: $scope.selectedPaymentMethod
    };

    // Gọi API để thêm hóa đơn
    $http.post(urlInvoice, data)
      .then(function (response) {
        $scope.idInvoice = response.data.message;
        createUserInvoice($scope.idInvoice);
      })
      .catch(function (error) {
        handleError(error);
      });
  };

  // Hàm tạo đối tượng userinvoice và gọi API
  function createUserInvoice(invoiceId) {
    const userInvoiceData = {
      user: {
        id: userInfo.id
      },
      invoice: {
        id: invoiceId
      }
    };

    $http.post(urlUserInvoice, userInvoiceData)
      .then(function (response) {
        console.log(response.data);
      })
      .catch(function (error) {
        handleError(error);
      });
  }

  // Hàm xử lý lỗi
  function handleError(error) {
    console.log("Lỗi khi thêm hóa đơn:", error);
    if (error.data && error.data.errors) {
      $scope.errors = error.data.errors; // Lỗi chi tiết từ server
    } else {
      $scope.errorMessage = error.data.error || "Lỗi không xác định"; // Lỗi tổng quát
    }
  }

  // Hàm hiển thị thông báo
  function showAlert(message, icon) {
    Swal.fire({
      icon: icon,
      title: "Oops...",
      text: message,
    });
  }

  // Theo dõi biến này khi người dùng thay đổi lựa chọn
  $scope.$watch('selectedPaymentMethod', function (newValue) {
    $scope.selectedPaymentMethod = newValue
  });
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
