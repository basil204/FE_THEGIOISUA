app.service("InvoiceService", function ($http) {
    // Phương thức kiểm tra thông tin đầu vào
    const apiBase = "http://160.30.21.47:1234/api/";

    this.getInvoiceByCode = function (invoiceCode) {
        return $http.get(apiBase + 'Invoice/getInvoice/' + invoiceCode);
    };

    this.getInvoiceDetailById = function (invoiceId) {
        return $http.get(apiBase + 'Invoicedetail/getInvoiceDetailByUser/' + invoiceId);
    };

    this.getInvoiceLogById = function (invoiceId) {
        return $http.get(apiBase + 'InvoiceLog/getById/' + invoiceId);
    };
    this.validateInvoiceData = function ($scope) {
        // Kiểm tra số điện thoại
        if ($scope.strphoneNumber && $scope.strphoneNumber.length !== 10 || $scope.strphoneNumber == null) {
            return Swal.fire({
                icon: "error",
                title: "Có lỗi xảy ra",
                text: "Vui lòng nhập đúng số điện thoại!",
            });
        }

        // Kiểm tra tên người dùng
        if ($scope.fullname == null) {
            return Swal.fire({
                icon: "error",
                title: "Có lỗi xảy ra",
                text: "Vui lòng nhập đúng tên người dùng",
            });
        }

        // Kiểm tra email
        if ($scope.email == null) {
            return Swal.fire({
                icon: "error",
                title: "Có lỗi xảy ra",
                text: "Vui lòng nhập đúng email",
            });
        }

        // Kiểm tra phương thức thanh toán
        if (!$scope.selectedPaymentMethod) {
            return Swal.fire({
                icon: "error",
                title: "Có lỗi xảy ra",
                text: "Vui Lòng Chọn Phương Thức Thanh Toán",
            });
        }

        // Kiểm tra đơn vị vận chuyển
        if (!$scope.selectedShip) {
            return Swal.fire({
                icon: "error",
                title: "Có lỗi xảy ra",
                text: "Vui Lòng Chọn Đơn Vị Vận Chuyển",
            });
        }

        // Nếu tất cả điều kiện hợp lệ, trả về true
        return true;
    };
});
