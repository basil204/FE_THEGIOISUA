app.controller("ShoppingCartController", function ($scope, $location, $http) {
  // Khai báo biến
  $scope.lstProductOder =
    JSON.parse(localStorage.getItem("lstProductOder")) || [];
  const userInfo = JSON.parse(localStorage.getItem("userInfo"));
  const urlInvoice = "http://160.30.21.47:1234/api/Invoice/add";
  const urlUserInvoice = "http://160.30.21.47:1234/api/Userinvoice/add";
  const urlInvoiceDetail = "http://160.30.21.47:1234/api/Invoicedetail/add";
  let remainingTime = 15 * 60;
  $scope.deliveryAddress =
    JSON.parse(localStorage.getItem("deliveryAddress")) || [];
  $scope.selectedPaymentMethod = "";
  $scope.newAddress = null;
  $scope.tinhs = [];
  $scope.quans = [];
  $scope.phuongs = [];
  $scope.detailAddress = "";
  $scope.selectedAddressId = 1; // Chọn mặc định địa chỉ đầu tiên

  // Hàm khởi tạo
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

  $scope.getAddressById = function (id) {
    return $scope.deliveryAddress.find(function (address) {
      return address.id === id;
    });
  };

  $scope.removeAddress = function (id) {
    // Kiểm tra xem id có được truyền vào không
    if (id === undefined) {
      console.error("Không tìm thấy id để xóa.");
      return;
    }

    Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Yes, delete it!",
    }).then((result) => {
      if (result.isConfirmed) {
        // Xóa phần tử với id khớp trong mảng deliveryAddress
        $scope.deliveryAddress = $scope.deliveryAddress.filter(function (
          address
        ) {
          return address.id !== id;
        });

        // Cập nhật lại localStorage với mảng đã được xóa phần tử
        localStorage.setItem(
          "deliveryAddress",
          JSON.stringify($scope.deliveryAddress)
        );

        // Thông báo xóa thành công
        Swal.fire({
          title: "Deleted!",
          text: "Your address has been deleted.",
          icon: "success",
        });

        // Cập nhật giao diện
        $scope.$apply();
      }
    });
  };

  $scope.addAdress = async function () {
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
    try {
      const user = await $scope.getUserById(userInfo.id);
      const lastAddress =
        $scope.deliveryAddress[$scope.deliveryAddress.length - 1];
      const newId = lastAddress ? lastAddress.id + 1 : 1; // Nếu không có phần tử nào, khởi tạo ID bằng 1
      const newData = {
        id: newId,
        address: $scope.newAddress,
        phonenumber: $scope.phonenumber,
        userName: user.fullName,
      };
      $scope.deliveryAddress.push(newData);
      $scope.$applyAsync();
      localStorage.setItem(
        "deliveryAddress",
        JSON.stringify($scope.deliveryAddress)
      );
      Swal.fire({
        position: "center",
        icon: "success",
        title: "Thêm Địa Chỉ Thành Công",
        showConfirmButton: false,
        timer: 1500,
      });
      $scope.detailAddress = ""; // Xóa ô nhập địa chỉ
      $scope.phonenumber = ""; // Xóa ô nhập số điện thoại
      $scope.$applyAsync();
    } catch (error) {
      console.error("Lỗi khi lấy thông tin người dùng:", error);
    }
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

  // Hàm tính toán tổng tiền
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
    localStorage.setItem(
      "lstProductOder",
      JSON.stringify($scope.lstProductOder)
    );
  };

  // Hàm xử lý người dùng
  $scope.getUserById = function (userId) {
    const apiUrl = `http://160.30.21.47:1234/api/user/${userId}`;
    return $http
      .get(apiUrl)
      .then(function (response) {
        $scope.user = response.data;
        return $scope.user;
      })
      .catch(function (error) {
        console.error("Lỗi khi lấy thông tin người dùng:", error);
      });
  };

  $scope.AddInvoiceDetail = function (invoiceDetail) {
    // Gọi API để thêm InvoiceDetail vào hệ thống
    return $http
      .post(urlInvoiceDetail, invoiceDetail) // Trả về promise để có thể tiếp tục xử lý
      .then(function (response) {
        return response.data; // Trả lại dữ liệu nếu cần
      })
      .catch(function (error) {
        console.error(error);
        throw error; // Ném lỗi nếu có
      });
  };

  $scope.checkInvoicePaymentStatus = function (totalAmount, invoicecode) {
    // Tạo dữ liệu cần gửi
    const data = {
      creditAmount: totalAmount,
      description: invoicecode,
    };

    // Thiết lập thời gian đếm ngược (15 phút)
    let remainingTime = 900; // 15 phút = 900 giây

    // Cập nhật đồng hồ đếm ngược mỗi giây
    const countdownId = setInterval(function () {
      remainingTime--;

      // Chuyển đổi thời gian còn lại thành phút và giây
      const minutes = Math.floor(remainingTime / 60);
      const seconds = remainingTime % 60;

      // Hiển thị đồng hồ đếm ngược trong console
      console.log(`Thời gian còn lại: ${minutes} phút ${seconds} giây`);

      // Nếu hết thời gian thì dừng đồng hồ
      if (remainingTime <= 0) {
        clearInterval(countdownId); // Dừng đồng hồ đếm ngược
        clearInterval(intervalId); // Dừng kiểm tra thanh toán
        console.log("Đã hết thời gian kiểm tra sau 15 phút");
      }
    }, 1000); // Cập nhật mỗi giây

    // Hàm kiểm tra thanh toán, được gọi mỗi 10 giây
    const intervalId = setInterval(function () {
      $http
        .post(`http://160.30.21.47:1234/api/payment/transactionHistory`, data)
        .then(function (response) {
          console.log(response); // In ra phản hồi trong console
          if (response.status === 200) {
            // Nếu phản hồi cũng cần kiểm tra nội dung
            clearInterval(intervalId); // Dừng kiểm tra khi đã thanh toán
            clearInterval(countdownId); // Dừng đồng hồ đếm ngược khi thanh toán thành công
            Swal.fire({
              position: "center",
              icon: "success",
              title: "Hóa đơn đã được thanh toán thành công!",
              showConfirmButton: true,
            }).then((result) => {
              if (result.isConfirmed) {
                // Khi nhấn OK, tải lại trang
                location.reload();
              }
            });
          }
        })
        .catch(function (error) {
          if (error.status === 404) {
            console.log(error.data);
          }
          console.error("Lỗi khi kiểm tra trạng thái thanh toán:");
        });
    }, 10000); // Kiểm tra mỗi 10 giây
  };

  $scope.createInvoice = function () {
    const address = $scope.getAddressById($scope.selectedAddressId);
    if (!address) {
      Swal.fire({
        position: "center",
        icon: "error",
        title: "Vui Lòng Thêm Địa Chỉ Giao Hàng",
        showConfirmButton: true,
      });
      return;
    }

    // Tạo đối tượng hóa đơn
    $scope.invoice = {
      voucher: null,
      discountamount: 0,
      invoicecode: $scope.generateInvoiceCode(), // Generate random invoice code
      totalamount: $scope.calculateTotal(),
      phonenumber: address.phonenumber,
      deliveryaddress: address.address,
      paymentmethod: $scope.selectedPaymentMethod,
    };

    if (!$scope.selectedPaymentMethod) {
      showAlert("Vui Lòng Chọn Phương Thức Thanh Toán!", "error");
      return;
    }

    if ($scope.selectedPaymentMethod === "COD") {
      showAlert("Chức năng Hiện Chưa Khả Dụng!", "error");
      return;
    }

    // Gửi yêu cầu POST để tạo hóa đơn
    $http
      .post(urlInvoice, $scope.invoice)
      .then(function (response) {
        $scope.idInvoice = response.data.message;
        return createUserInvoice($scope.idInvoice); // Trả về promise từ createUserInvoice
      })
      .then(function () {
        if (!$scope.lstProductOder || $scope.lstProductOder.length === 0) {
          throw new Error("Không có sản phẩm nào để tạo chi tiết hóa đơn.");
        }

        // Tạo tất cả các chi tiết hóa đơn
        const invoiceDetailsPromises = $scope.lstProductOder.map(function (x) {
          var invoiceDetail = {
            quantity: x.quantity,
            price: x.productDetails.price,
            totalprice: x.quantity * x.productDetails.price,
            invoice: {
              id: $scope.idInvoice,
            },
            milkDetail: {
              id: x.id,
            },
          };
          return $scope.AddInvoiceDetail(invoiceDetail); // Trả về promise
        });

        // Thực hiện tất cả các yêu cầu đồng thời
        return Promise.all(invoiceDetailsPromises);
      })
      .then(function () {
        // Nếu không có lỗi, hiển thị thông báo thành công
        Swal.fire({
          position: "center",
          icon: "success",
          title: "Hóa đơn đã được tạo thành công",
          html: `
                    <p>Quý khách có thể thanh toán qua mã QR bên dưới:</p>
                    <img src="https://api.vietqr.io/image/970422-0338739954-PmsPdTu.jpg?accountName=NGUYEN%20LIEN%20MANH&amount=${$scope.invoice.totalamount}&addInfo=${$scope.invoice.invoicecode}" 
                         alt="QR Code" 
                         style="width: 200px; height: 200px; margin-top: 10px;">`,
          showConfirmButton: true,
        }).then(() => {
          // Bắt đầu kiểm tra trạng thái thanh toán
          $scope.checkInvoicePaymentStatus(
            $scope.invoice.totalamount,
            $scope.invoice.invoicecode
          );
        });
      })
      .catch(function (error) {
        // Nếu có lỗi, dừng quá trình tạo hóa đơn
        Swal.fire({
          position: "center",
          icon: "error",
          title:
            "Yêu cầu không hợp lệ: " +
            (error.data ? error.data.error : error.message),
          showConfirmButton: true,
        });
        console.log(error.data || error);
      });
  };

  // Hàm tạo UserInvoice
  function createUserInvoice(invoiceId) {
    const userInvoiceData = {
      user: {
        id: userInfo.id,
      },
      invoice: {
        id: invoiceId,
      },
    };

    return $http
      .post(urlUserInvoice, userInvoiceData)
      .then(function (response) {
        return response.data; // Trả lại dữ liệu nếu cần
      })
      .catch(function (error) {
        console.error("Error when creating user invoice:", error);
        throw error; // Ném lỗi nếu có
      });
  }

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
});
