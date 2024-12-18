app.service("PaymentService", function ($http) {
  this.processPayment = function (
    totalamount,
    invoicecode,
    successCallback,
    errorCallback
  ) {
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
                  if (
                    result.isConfirmed &&
                    typeof successCallback === "function"
                  ) {
                    successCallback();
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
              if (typeof errorCallback === "function") {
                errorCallback(error);
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
});
