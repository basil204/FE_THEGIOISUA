app.controller(
  "InvoiceDetailController",
  function ($scope, $http, $routeParams, PaymentService, StatusService) {
    const invoiceCode = $routeParams.invoiceCode;
    const apiInvoiceDetailByInvoiceID =
      "http://160.30.21.47:1234/api/Invoicedetail/getInvoiceDetailByUser/";
    const cancelInvoice = "http://160.30.21.47:1234/api/Invoice/cancel/";
    const getInvoiceByInvoiceCode =
      "http://160.30.21.47:1234/api/Invoice/getInvoice/";
    const getInvoiceLogByInvoiceID =
      "http://160.30.21.47:1234/api/InvoiceLog/getById/";
    $scope.invoiceLogs = null;
    // Hàm lấy trạng thái từ mã trạng thái
    $scope.getStatus = function (statusCode) {
      return StatusService.getStatus(statusCode);
    };
    $scope.getInvoice = function () {
      if (invoiceCode != null) {
        $http
          .get(getInvoiceByInvoiceCode + invoiceCode)
          .then(function (response) {
            $scope.invoice = response.data.message;
            $scope.getInvoiceDetail();
            $scope.getInvoiceLog();
            if ($scope.invoice.trangThai == 337) {
              $scope.payment($scope.invoice.tongTien, invoiceCode);
            }
          })
          .catch(function (error) {
            console.error("Error fetching invoice details:", error);
          });
      }
    };
    $scope.getInvoiceDetail = function () {
      if ($scope.invoice != null) {
        $http
          .get(apiInvoiceDetailByInvoiceID + $scope.invoice.invoiceID)
          .then(function (response) {
            $scope.invoiceDetails = response.data.message;
          })
          .catch(function (error) {
            console.error("Error fetching invoice details:", error);
          });
      }
    };
    $scope.getInvoiceLog = function () {
      if ($scope.invoice != null) {
        $http
          .get(getInvoiceLogByInvoiceID + $scope.invoice.invoiceID)
          .then(function (response) {
            $scope.invoiceLogs = response.data.message;
          })
          .catch(function (error) {
            console.error("Error fetching invoice details:", error);
          });
      }
    };
    $scope.getStepData = function (status) {
      if ($scope.invoiceLogs) {
        const log = $scope.invoiceLogs.find((log) => log.status === status);
        return log ? log.created_at : null;
      }
    };
    $scope.payment = function (totalamount, invoicecode) {
      PaymentService.processPayment(
        totalamount,
        invoicecode,
        function () {
          // Thành công
          window.location.href = "/profile";
        },
        function (error) {
          // Xử lý lỗi nếu cần
          console.error("Lỗi khi thanh toán:", error);
        }
      );
    };

    $scope.cancelInvoice = function (idinvoice) {
      Swal.fire({
        title: "Xác nhận!",
        text: "Bạn có chắc muốn tiếp tục?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Đồng ý",
        cancelButtonText: "Hủy",
      }).then((result) => {
        if (result.isConfirmed) {
          $http
            .get(cancelInvoice + idinvoice)
            .then(function (response) {
              Swal.fire("Thành công!", "Hủy Thành Công", "success");
              window.location.href = "/home";
            })
            .catch(function (error) {
              console.error("Error fetching invoice details:", error);
            });
        }
      });
    };
    $scope.getInvoice();
  }
);
