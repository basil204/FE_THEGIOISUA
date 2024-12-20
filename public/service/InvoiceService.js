app.service("InvoiceService", function ($http) {
  // Phương thức kiểm tra thông tin đầu vào
  const apiBase = "http://160.30.21.47:1234/api/";

  this.getInvoiceByCode = function (invoiceCode) {
    return $http.get(apiBase + "Invoice/getInvoice/" + invoiceCode);
  };

  this.getInvoiceDetailById = function (invoiceId) {
    return $http.get(
      apiBase + "Invoicedetail/getInvoiceDetailByUser/" + invoiceId
    );
  };

  this.getInvoiceLogById = function (invoiceId) {
    return $http.get(apiBase + "InvoiceLog/getById/" + invoiceId);
  };
  this.validateInvoiceData = function ($scope) {
    if ($scope.phoneNumber == null || $scope.phoneNumber.length !== 9) {
      Swal.fire({
        icon: "error",
        title: "Có lỗi xảy ra",
        text: "Vui lòng nhập đúng số điện thoại!",
      });
    } else if ($scope.strphoneNumber == null || $scope.strphoneNumber.length !== 10) {
      Swal.fire({
        icon: "error",
        title: "Có lỗi xảy ra",
        text: "Vui lòng nhập đúng số điện thoại!",
      });
    } else if ($scope.fullname == null) {
      Swal.fire({
        icon: "error",
        title: "Có lỗi xảy ra",
        text: "Vui lòng nhập đúng tên người dùng",
      });
    } else if ($scope.email == null) {
      Swal.fire({
        icon: "error",
        title: "Có lỗi xảy ra",
        text: "Vui lòng nhập đúng email",
      });
    } else if (!$scope.selectedPaymentMethod) {
      Swal.fire({
        icon: "error",
        title: "Có lỗi xảy ra",
        text: "Vui Lòng Chọn Phương Thức Thanh Toán",
      });
    } else if (!$scope.selectedShip) {
      Swal.fire({
        icon: "error",
        title: "Có lỗi xảy ra",
        text: "Vui Lòng Chọn Đơn Vị Vận Chuyển",
      });
    } else {
      // Nếu tất cả điều kiện hợp lệ
      return true;
    }

    // Nếu bất kỳ điều kiện nào không hợp lệ, trả về false
    return false;
  };

});
