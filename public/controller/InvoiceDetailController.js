app.controller("InvoiceDetailController", function ($scope, $http, $routeParams) {
    const invoiceCode = $routeParams.invoiceCode;
    $scope.invoice = null;
    if (!invoiceCode) {
        return
    }
    const apiInvoiceDetail =
        "http://160.30.21.47:1234/api/Invoicedetail/getInvoiceDetailByUser/";
    const cancelInvoice = "http://160.30.21.47:1234/api/Invoice/cancel/";
    const getInvoiceByInvoiceCode = "http://160.30.21.47:1234/api/Invoice/getInvoice/";
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
    $scope.getInvoice = function () {
        if (invoiceCode != null) {
            $http
                .get(getInvoiceByInvoiceCode + invoiceCode)
                .then(function (response) {
                    $scope.invoice = response.data.message;
                    $scope.getInvoiceDetail();
                    if ($scope.invoice.trangThai == 337) {
                        $scope.payment($scope.invoice.tongTien, invoiceCode)
                    }
                })
                .catch(function (error) {
                    console.error("Error fetching invoice details:", error);
                });
        }

    }
    $scope.getInvoiceDetail = function () {
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

    $scope.payment = function (totalamount, invoicecode) {
        let remainingTime = 600; // 10 phút

        Swal.fire({
            position: "center",
            icon: "success",
            html: `
              <p>Quý khách có thể thanh toán qua mã QR bên dưới:</p>
              <img src="https://api.vietqr.io/image/970422-0338739954-PmsPdTu.jpg?accountName=NGUYEN%20LIEN%20MANH&amount=${totalamount}&addInfo=${invoicecode}"
                   alt="QR Code" style="width: 200px; height: 200px; margin-top: 10px;">
            `,
            showConfirmButton: false,
            footer: `<p>Thời gian chờ: <span id="countdown">${Math.floor(
                remainingTime / 60
            )} phút ${remainingTime % 60} giây</span></p>`,
            didOpen: () => {
                const countdownElement = document.getElementById("countdown");
                const countdownInterval = setInterval(() => {
                    remainingTime--;
                    countdownElement.textContent = `${Math.floor(
                        remainingTime / 60
                    )} phút ${remainingTime % 60} giây`;
                    if (remainingTime <= 0) {
                        clearInterval(countdownInterval);
                        clearInterval(paymentCheckInterval);
                        Swal.close();
                    }
                }, 1000);

                const paymentCheckInterval = setInterval(() => {
                    $http
                        .post("http://160.30.21.47:1234/api/payment/transactionHistory", {
                            creditAmount: totalamount,
                            description: invoicecode,
                        })
                        .then((response) => {
                            if (response.status === 200) {
                                clearInterval(countdownInterval);
                                clearInterval(paymentCheckInterval);
                                Swal.fire({
                                    position: "center",
                                    icon: "success",
                                    title: "Hóa đơn đã được thanh toán thành công!",
                                    showConfirmButton: true,
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.location.href = "/profile";
                                    }
                                });
                            }
                        })
                        .catch((error) => {
                            if (error.status === 404) {
                                console.error("Không tìm thấy giao dịch, thử lại sau.");
                            } else {
                                console.error(
                                    "Lỗi khác khi kiểm tra trạng thái thanh toán:",
                                    error
                                );
                            }
                        });
                }, 5000);

                // Lưu lại các interval để dừng sau này
                Swal.intervalIds = { countdownInterval, paymentCheckInterval };
            },
            willClose: () => {
                // Nếu Swal bị đóng bởi người dùng
                if (Swal.intervalIds) {
                    clearInterval(Swal.intervalIds.countdownInterval);
                    clearInterval(Swal.intervalIds.paymentCheckInterval);
                }
            },
        });
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
                        window.location.href = "/home"
                    })
                    .catch(function (error) {
                        console.error("Error fetching invoice details:", error);
                    });
            }
        });
    };
    $scope.getInvoice();

});