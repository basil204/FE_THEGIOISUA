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
