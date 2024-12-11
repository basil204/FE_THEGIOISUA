app.controller("InvoiceDetailController", function ($scope, $http, socket) {
    const apiInvoiceDetail =
        "http://160.30.21.47:1234/api/Invoicedetail/getInvoiceDetailByUser/";
    $scope.invoice = JSON.parse(localStorage.getItem("invoice")) || null;
    $scope.statusMap = {
        0: "Không hoạt động",
        1: "Hoạt động",
        336: "Huỷ Đơn",
        913: "Hoàn thành",
        901: "Chờ lấy hàng",
        903: "Đã lấy hàng",
        904: "Giao hàng",
        301: "Chờ Duyệt Đơn",
        337: "Chưa Thanh Toán",
        338: "Đơn Chờ",
        305: "Thanh toán thành công"
    };
    // Hàm lấy trạng thái từ mã trạng thái
    $scope.getStatus = function (statusCode) {
        return $scope.statusMap[statusCode] || "Không xác định";
    };
    $scope.invoiceDetail = function () {
        if ($scope.invoice != null) {
            $http
                .get(apiInvoiceDetail + $scope.invoice.invoiceID)
                .then(function (response) {
                    $scope.invoiceDetails = response.data.message;
                })
                .catch(function (error) {
                    console.error("Error fetching invoice details:", error);
                });
        }

    }
    $scope.invoiceDetail();
});