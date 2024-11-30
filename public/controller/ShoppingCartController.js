app.controller("ShoppingCartController", function ($scope, $location, $http, socket) {
  // Khai báo biến
  const token = localStorage.getItem("authToken");

  const config = {
    headers: {
      Authorization: `Bearer ${token}`,
    }
  }
  $scope.lstProductOder =
    JSON.parse(localStorage.getItem("lstProductOder")) || []
  const urlInvoice = "http://160.30.21.47:1234/api/Invoice/add";
  const cancelInvoice = "http://160.30.21.47:1234/api/Invoice/cancel/";
  const apiUser = "http://160.30.21.47:1234/api/user/";
  const apiVoucher = "http://160.30.21.47:1234/api/Voucher/";
  const apitGetInvoiceByUser = "http://160.30.21.47:1234/api/Invoice/getInvoices/";
  const apiInvoiceDetail =
    "http://160.30.21.47:1234/api/Invoicedetail/getInvoiceDetailByUser/";
  $scope.selectedPaymentMethod = "";
  $scope.newAddress = null;
  $scope.tinhs = [];
  $scope.quans = [];
  $scope.phuongs = [];
  $scope.detailAddress = "";
  $scope.userData = null; // Khởi tạo biến để lưu dữ liệu người dùng
  $scope.discountmoney = 0;
  $scope.voucher = null;
  $scope.userInvoices = null;
  $scope.invoiceDetails = [];
  $scope.invoice = null;
  // Hàm tính toán tổng tiền
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
            location.reload();
          })
          .catch(function (error) {
            console.error("Error fetching invoice details:", error);
          });
      }
    });
  };
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
            console.log("Đã hết thời gian kiểm tra sau 10 phút");
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
                console.log("Không tìm thấy giao dịch, thử lại sau.");
              } else {
                console.error(
                  "Lỗi khác khi kiểm tra trạng thái thanh toán:",
                  error
                );
              }
            });
        }, 5000);
      },
    });
  };
  $scope.getInvoiceDetailByUser = function (invoice) {
    $scope.invoice = invoice;
    $http
      .get(apiInvoiceDetail + invoice.invoiceID)
      .then(function (response) {
        $scope.invoiceDetails = response.data.message;
      })
      .catch(function (error) {
        console.error("Error fetching invoice details:", error);
      });
    // console.log($scope.invoice);
  };
  $scope.getInvoicesByUser = function () {
    if (userInfo && userInfo.id) {
      $http
        .get(`${apitGetInvoiceByUser}${userInfo.id}`)
        .then((response) => {
          if (response.status === 200) {
            $scope.userInvoices = response.data.message; // Lưu danh sách hóa đơn vào scope để hiển thị
          } else {
            console.error("Không thể lấy danh sách hóa đơn.");
          }
        })
        .catch((error) => {
          console.error("Lỗi khi lấy hóa đơn:", error);
        });
    } else {
      console.warn("User info is not available."); // Thông báo khi userInfo chưa có
      return null;
    }
  };
  $scope.calculateTotal = function () {
    let total = 0;
    $scope.lstProductOder.forEach(function (item) {
      const price = Number(item.productDetails.price);
      const quantity = Number(item.quantity);
      if (!isNaN(price) && !isNaN(quantity)) {
        total += price * quantity;
      } else {
        console.error("Giá hoặc số lượng không hợp lệ:", item);
      }
    });
    return total;
  };
  $scope.totalamount = $scope.calculateTotal() - $scope.discountmoney;
  $scope.checkvoucher = function () {
    if ($scope.vouchercode) {
      const params = {
        vouchercode: $scope.vouchercode,
        total: $scope.calculateTotal(),
      };

      $http
        .get(apiVoucher + "voucercode", { params: params })
        .then(function (response) {
          if (response.status === 200) {
            $scope.voucher = response.data;
            $scope.discountmoney = response.data.discountAmount; // Lưu dữ liệu voucher vào biến
            $scope.totalamount = $scope.calculateTotal() - $scope.discountmoney;
          }
        })
        .catch(function (error) {
          console.error("Error fetching voucher code:", error.data);
          Swal.fire({
            icon: "error",
            title: "Lỗi",
            text: "Không thể lấy mã voucher, vui lòng thử lại sau.",
            footer: error.data.error,
          });
        });
    }
  };

  $scope.user = function () {
    if (userInfo && userInfo.id) {
      // Kiểm tra userInfo và userInfo.id tồn tại
      return $http
        .get(apiUser + "profile/" + userInfo.id)
        .then(function (response) {
          $scope.userData = response.data; // Lưu dữ liệu vào $scope.userData
          return $scope.userData; // Trả về dữ liệu sau khi tải xong
        })
        .catch(function (error) {
          console.error("Error fetching user data:", error);
        });
    } else {
      console.warn("User info is not available."); // Thông báo khi userInfo chưa có
      return null;
    }
  };

  $scope.loadTinh = function () {
    $http
      .get("https://esgoo.net/api-tinhthanh/1/0.htm")
      .then(function (response) {
        if (response.data.error === 0) {
          $scope.tinhs = response.data.data;
        }
      });
  };

  // Hàm xử lý địa chỉ
  $scope.loadQuan = function () {
    var idTinh = $scope.selectedTinh;
    $scope.quans = [];
    $scope.phuongs = [];
    if (idTinh) {
      $http
        .get("https://esgoo.net/api-tinhthanh/2/" + idTinh + ".htm")
        .then(function (response) {
          if (response.data.error === 0) {
            $scope.quans = response.data.data;
          }
        });
    }
  };

  $scope.loadPhuong = function () {
    var idQuan = $scope.selectedQuan;
    $scope.phuongs = [];
    if (idQuan) {
      $http
        .get("https://esgoo.net/api-tinhthanh/3/" + idQuan + ".htm")
        .then(function (response) {
          if (response.data.error === 0) {
            $scope.phuongs = response.data.data;
          }
        });
    }
  };
  $scope.addPhoneNumber = function () {
    const user = {
      id: $scope.userData.id,
      phonenumber: $scope.phonenumber,
    };

    $http
      .put(apiUser + "updatePhonerNumber", user, config)
      .then(function (response) {
        if (response.status === 200) {
          $scope.user(); // Cập nhật lại thông tin người dùng
          Swal.fire({
            position: "center",
            icon: "success",
            title: "Cập nhật số điện thoại thành công",
            showConfirmButton: false,
            timer: 1500,
          });
        }
      })
      .catch(function (error) {
        if (error.data && error.data.status === "error") {
          // Nếu có lỗi và trả về status là "error", hiển thị thông báo lỗi cụ thể
          const errorMessage = error.data.errors
            .map((err) => `${err.field}: ${err.message}`)
            .join("\n");

          Swal.fire({
            icon: "error",
            title: "Lỗi cập nhật",
            text: errorMessage,
          });
        } else {
          console.error("Error updating user:", error.message);
        }
      });
  };

  $scope.addAdress = function () {
    if (
      !$scope.getTinhName() ||
      !$scope.getQuanName() ||
      !$scope.getPhuongName()
    ) {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: "Vui lòng chọn đầy đủ Địa Chỉ",
      });
      return;
    }
    $scope.newAddress =
      $scope.getTinhName().full_name +
      ", " +
      $scope.getQuanName().full_name +
      ", " +
      $scope.getPhuongName().full_name;
    if ($scope.detailAddress !== "") {
      $scope.newAddress = $scope.newAddress + ", " + $scope.detailAddress;
    }
    const user = {
      id: $scope.userData.id,
      address: $scope.newAddress,
    };
    $http
      .put(apiUser + "updateAddress", user, config)
      .then(function (response) {
        if (response.status === 200) {
          $scope.user(); // Cập nhật lại thông tin người dùng
          Swal.fire({
            position: "center",
            icon: "success",
            title: "Cập nhật địa chỉ thành công",
            showConfirmButton: false,
            timer: 1500,
          });
        }
      })
      .catch(function (error) {
        if (error.data && error.data.status === "error") {
          // Nếu có lỗi và trả về status là "error", hiển thị thông báo lỗi cụ thể
          const errorMessage = error.data.errors
            .map((err) => `${err.field}: ${err.message}`)
            .join("\n");

          Swal.fire({
            icon: "error",
            title: "Lỗi cập nhật",
            text: errorMessage,
          });
        } else {
          console.error("Error updating user:", error.message);
        }
      });
    $scope.detailAddress = ""; // Xóa ô nhập địa chỉ
    $scope.phonenumber = ""; // Xóa ô nhập số điện thoại
  };

  // Hàm lấy tên địa chỉ
  $scope.getTinhName = function () {
    return $scope.tinhs.find((tinh) => tinh.id === $scope.selectedTinh);
  };

  $scope.getQuanName = function () {
    return $scope.quans.find((quan) => quan.id === $scope.selectedQuan);
  };

  $scope.getPhuongName = function () {
    return $scope.phuongs.find((phuong) => phuong.id === $scope.selectedPhuong);
  };

  // Hàm tạo mã hóa đơn ngẫu nhiên
  $scope.generateInvoiceCode = function () {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let invoiceCode = "HD"; // Start with "HD"
    let usedCharacters = new Set(); // To keep track of used characters

    while (invoiceCode.length < 10) {
      // 2 (for "HD") + 8 random characters
      const randomIndex = Math.floor(Math.random() * characters.length);
      const randomChar = characters.charAt(randomIndex);

      // Check if the character is already used
      if (!usedCharacters.has(randomChar)) {
        usedCharacters.add(randomChar); // Mark character as used
        invoiceCode += randomChar; // Append to invoice code
      }
    }
    return invoiceCode;
  };

  // Cập nhật tổng tiền khi số lượng thay đổi
  $scope.updateTotal = function (product) {
    console.log(product.quantity);
    if (
      product.quantity > product.productDetails.stockquantity ||
      product.quantity < 1
    ) {
      Swal.fire({
        icon: "error",
        title: "Đặt Hàng Thất Bại",
        text: "Vui lòng nhập đúng số lượng!",
        footer: "Số Lượng Còn Lại: " + product.productDetails.stockquantity,
      });
      product.quantity = 1;
      return;
    }
    localStorage.setItem(
      "lstProductOder",
      JSON.stringify($scope.lstProductOder)
    );
  };

  $scope.createInvoiceAndDetails = function () {
    const address = $scope.userData.address;
    const phoneNumber = $scope.userData.phoneNumber;
    if (!address || !phoneNumber) {
      return Swal.fire({
        position: "center",
        icon: "error",
        title: "Vui Lòng Thêm Địa Chỉ Giao Hàng",
        showConfirmButton: true,
      });
    }
    if (!$scope.selectedPaymentMethod) {
      return showAlert("Vui Lòng Chọn Phương Thức Thanh Toán!");
    }

    // if ($scope.selectedPaymentMethod === "COD") {
    //   return showAlert("Chức năng Hiện Chưa Khả Dụng!");
    // }
    const invoiceDto = {
      invoiceCode: $scope.generateInvoiceCode(),
      deliveryaddress: address,
      phonenumber: phoneNumber,
      paymentmethod: $scope.selectedPaymentMethod,
      voucherCode: $scope.voucher ? $scope.voucher.Vouchercode : null,
      sotienGiamGia: $scope.discountmoney || 0,
      tongTien: $scope.totalamount,
      invoiceDetails: $scope.lstProductOder.map((x) => ({
        quantity: x.quantity,
        price: x.productDetails.price,
        totalprice: x.quantity * x.productDetails.price,
        milkDetail: { id: x.id },
      })),
      nguoiTao: {
        id: $scope.userData.id,
      },
    };

    $http
      .post(urlInvoice, invoiceDto)
      .then((response) => {
        Swal.fire({
          position: "center",
          icon: "success",
          title: "Hóa đơn được Tạo Thành Công",
          showConfirmButton: false,
          timer: 1500,
        }).then(() => {
          console.log(invoiceDto);
          $scope.payment(invoiceDto.tongTien, invoiceDto.invoiceCode);
        });
      })
      .catch((error) => {
        Swal.fire({
          position: "center",
          icon: "error",
          title:
            "Yêu cầu không hợp lệ: " +
            (error.data ? error.data.error : error.message),
          showConfirmButton: true,
        });
        console.error("Error:", error.data || error);
      });
  };

  // Hàm xử lý lỗi
  function handleError(error) {
    console.log("Lỗi khi thêm hóa đơn:", error);
    if (error.data && error.data.errors) {
      $scope.errors = error.data.errors;
    } else {
      $scope.errorMessage = error.data.error || "Lỗi không xác định";
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

  // Hàm xử lý thanh toán
  $scope.buttonThanhToan = function () {
    if ($scope.lstProductOder.length < 1) {
      window.location.href = "/home";
    } else {
      window.location.href = "/checkout";
    }
  };

  // Hàm xóa sản phẩm khỏi danh sách
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
        $scope.lstProductOder.splice(index, 1);
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.lstProductOder)
        );
        Swal.fire({
          icon: "success",
          title: "Đã xóa!",
          text: "Sản phẩm đã được xóa thành công.",
          timer: 1500,
          showConfirmButton: false,
        }).then(() => {
          $scope.$apply();
        });
      }
    });
  };

  // Theo dõi thay đổi của phương thức thanh toán
  $scope.$watch("selectedPaymentMethod", function (newValue) {
    $scope.selectedPaymentMethod = newValue;
  });

  // Gọi hàm loadTinh khi khởi tạo controller
  $scope.loadTinh();
  $scope.user();
});
