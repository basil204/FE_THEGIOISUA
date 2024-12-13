app.controller(
  "ShoppingCartController",
  function ($scope, $location, $http, $rootScope) {
    // Khai báo biến
    const tokenAddress = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImEzYWYyMzZjY2YxNzhjMzMwMTliZWRiNmY0NzVhMWQxZDMzMzE1NmE0N2U1YWFiNDA2NmFmOTE2MDc0MDdlMWNiYTY3ZDc1YjFiZWU5MDUyIn0.eyJhdWQiOiI3NyIsImp0aSI6ImEzYWYyMzZjY2YxNzhjMzMwMTliZWRiNmY0NzVhMWQxZDMzMzE1NmE0N2U1YWFiNDA2NmFmOTE2MDc0MDdlMWNiYTY3ZDc1YjFiZWU5MDUyIiwiaWF0IjoxNzMzNzcxODgxLCJuYmYiOjE3MzM3NzE4ODEsImV4cCI6MjA0OTMwNDY4MSwic3ViIjoiMzc4MCIsInNjb3BlcyI6W119.LY_gpwvPCnemap1JkpzwW6625Vd-Q_K8kc3nmJudacMj2XXsSHj_mDN-IfxwrRJiCcFHxgVyywcEIbpXuucLLIzXxCDrRKxMm4B1t4vLsN5pWf3d82FMH8Bxbtd0xRgmYSNh-XKhz1cCmOYXAhpfzvjDjY28R0vI2pGvESrYZAvnoAhwLAg7WAkQ4V5tsj0QHn4lWYQXTHgwlPDODBylxM2WikJw-OXW4dEX3JGn1ns5yF55Kgz7-vI3FXMyLwJ2uBWg_jMtJPj4SjSotkhjZwsbDNJrttNHv7Xkkeow29XnjysD7obEnCqkcy3xlYdz30X5bNzsJP7gqOy3AKPxDQeTMTAV42iGsLWfLLlQTG3gXIhixoZChq9w35K_O5OCx7PiqFADduAxtuVge0gBLH6XIdz1QBr_yUqvszmyMI0IWWtcSprbf-s8PJ4FtyhLNKeN5fidmes-mpV4Pmonk_DsuVhdPazlkmv8IO-DUbvo6CsqHnikeV_v_xPrhIsOwnsC8ISeMNQOkT_fMKEZvQzgGrL56NnJ0Av-FPVXaNNAkf6uWILsg_Ye9gWKUgb_Acr_XfVHB4GzFdtXEmsbMOCS4fWv_CHOzBmCMjHp8aWaInIBfxGzdLRjnF3hToaV7_O02illQtZa7mXLHlUz6lRTcmaP73FH1Wm3xSf1qtQ"
    const config = {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        Authorization: `Bearer ${tokenAddress}`,
      },
    };
    $scope.userInfo = JSON.parse(localStorage.getItem("userInfo")) || null;
    $scope.lstProductOder =
      JSON.parse(localStorage.getItem("lstProductOder")) || [];
    const urlInvoice = "http://160.30.21.47:1234/api/Invoice/add";

    const apiUser = "http://160.30.21.47:1234/api/user/";
    const apiVoucher = "http://160.30.21.47:1234/api/Voucher/";
    const apitGetInvoiceByUser =
      "http://160.30.21.47:1234/api/Invoice/getInvoices/";

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
    $scope.vouchers = null;
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
    $scope.selectedVoucher = function (x) {
      $scope.vouchercode = x;
      $scope.checkvoucher()
    }
    $scope.loadVoucher = function () {
      $http.get(apiVoucher + "voucherActive")
        .then(function (response) {
          $scope.vouchers = response.data.Succes;
        })
        .catch(function (error) {
          console.error('Có lỗi khi tải thông tin voucher:', error.data);
        });
    }
    $scope.selectedShipping = function (amout) {
      $scope.totalamount = $scope.calculateTotal() - $scope.discountmoney + Number(amout);
    }
    $scope.removeSelectedProducts = function () {
      swal.fire({
        title: "Bạn có chắc chắn?",
        text: "Sản phẩm đã chọn sẽ bị xóa!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Xóa",
        cancelButtonText: "Hủy"
      }).then((result) => {
        if (result.isConfirmed) {
          $scope.lstProductOder = $scope.lstProductOder.filter(product => !product.selected);
          localStorage.setItem("lstProductOder", JSON.stringify($scope.lstProductOder));
          $scope.$apply();
        }
      });
    };

    $scope.selectAllProducts = function () {
      $scope.lstProductOder.forEach(product => {
        product.selected = true;
      });
      localStorage.setItem("lstProductOder", JSON.stringify($scope.lstProductOder));
    };
    $scope.unselectAllProducts = function () {
      $scope.lstProductOder.forEach(product => {
        product.selected = false;
      });
      localStorage.setItem("lstProductOder", JSON.stringify($scope.lstProductOder));
    };
    $scope.selectedProductBycart = function (index) {
      const selectedProduct = $scope.lstProductOder[index];
      if (selectedProduct.selected) {
        localStorage.setItem("lstProductOder", JSON.stringify($scope.lstProductOder));
      } else {
        localStorage.setItem("lstProductOder", JSON.stringify($scope.lstProductOder));
      }
    }
    $scope.removeAllProducts = function () {
      swal.fire({
        title: "Bạn có chắc chắn?",
        text: "Sản phẩm đã chọn sẽ bị xóa!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Xóa",
        cancelButtonText: "Hủy"
      }).then((result) => {
        if (result.isConfirmed) {
          $scope.lstProductOder = localStorage.removeItem("lstProductOder");
          $scope.lstProductOder = [];
          $scope.$apply();
        }
      });

    }
    $scope.getInvoiceDetailByUser = function (invoice) {
      window.location.href = "/invoicedetail/" + invoice.invoiceCode
    };
    $scope.getInvoicesByUser = function () {
      if ($scope.userInfo && $scope.userInfo.id) {
        $http
          .get(`${apitGetInvoiceByUser}${$scope.userInfo.id}`)
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
        console.warn("User info is not available."); // Thông báo khi $scope.userInfo chưa có
        return null;
      }
    };
    $scope.calculateTotal = function () {
      const selectedItems = $scope.lstProductOder.filter(function (item) {
        return item.selected === true;
      });
      let total = 0;
      selectedItems.forEach(function (item) {
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
    $scope.totalamount = $scope.calculateTotal();
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
              $scope.totalamount = $scope.calculateTotal() - $scope.discountmoney
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
      if ($scope.userInfo && $scope.userInfo.id) {
        // Kiểm tra $scope.userInfo và $scope.userInfo.id tồn tại
        return $http
          .get(apiUser + "profile/" + $scope.userInfo.id)
          .then(function (response) {
            $scope.userData = response.data; // Lưu dữ liệu vào $scope.userData
            $scope.email = $scope.userData.email
            return $scope.userData; // Trả về dữ liệu sau khi tải xong
          })
          .catch(function (error) {
            console.error("Error fetching user data:", error);
          });
      } else {
        console.warn("User info is not available."); // Thông báo khi $scope.userInfo chưa có
        return null;
      }
    };
    $scope.amountShip = function () {
      const data = {
        "shipment": {
          "address_from": {
            "district": "181810",// ngo quyen
            "city": "180000"//hai phong
          },
          "address_to": {
            "district": $scope.selectedQuan,
            "city": $scope.selectedTinh
          },
          "parcel": {
            "cod": $scope.calculateTotal(),
            "amount": $scope.calculateTotal(),
            "width": 10,
            "height": 10,
            "length": 10,
            "weight": 750
          }
        }
      }
      $http
        .post("https://api.goship.io/api/v2/rates", data, config)
        .then(function (response) {
          $scope.ships = response.data.data;
        })
        .catch(function (error) {
          console.error("API Error:", error);
        });
    }
    $scope.loadTinh = function () {
      $http
        .get("https://api.goship.io/api/v2/cities", config)
        .then(function (response) {
          $scope.tinhs = response.data.data;
        });
    };

    // Hàm xử lý địa chỉ
    $scope.loadQuan = function () {
      var idTinh = $scope.selectedTinh;
      if (idTinh) {
        $http
          .get("https://api.goship.io/api/v2/cities/" + idTinh + "/districts", config)
          .then(function (response) {
            $scope.quans = response.data.data;
          });
      }
    };
    $scope.addPhoneNumber = function () {
      const user = {
        id: $scope.userData.id,
        phonenumber: $scope.phonenumber,
      };

      $http
        .put(apiUser + "updatePhonerNumber", user)
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

    $scope.addFullName = function () {
      const user = {
        id: $scope.userData.id,
        fullname: $scope.fullname,
      };

      $http
        .put(apiUser + "updateFullName", user)
        .then(function (response) {
          if (response.status === 200) {
            $scope.user(); // Cập nhật lại thông tin người dùng
            Swal.fire({
              position: "center",
              icon: "success",
              title: "Cập nhật họ tên thành công",
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
    $scope.getAdressInput = function () {
      if (
        !$scope.getTinhName() ||
        !$scope.getQuanName()
      ) {
        Swal.fire({
          icon: "error",
          title: "Oops...",
          text: "Vui lòng chọn đầy đủ Địa Chỉ",
        });
        return;
      }

      $scope.newAddress =
        $scope.getTinhName().name +
        ", " +
        $scope.getQuanName().name;

      if ($scope.detailAddress !== "") {
        $scope.newAddress = $scope.newAddress + ", " + $scope.detailAddress;
      }

      return $scope.newAddress
    }
    $scope.addAdress = function () {
      const user = {
        id: $scope.userData.id,
        address: $scope.getAdressInput()
      };

      $http
        .put(apiUser + "updateAddress", user)
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
    $scope.updateQuantity = function (product, change) {
      if (product.quantity + change >= 1) {
        product.quantity += change; // Cập nhật số lượng
        $scope.updateTotal(product); // Cập nhật lại tổng sau khi thay đổi số lượng
      }
    };

    // Cập nhật tổng tiền khi số lượng thay đổi
    $scope.updateTotal = function (product) {
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
      var iaddress = $scope.getAdressInput()
      var iphoneNumber = "0" + $scope.phoneNumber;
      if (iphoneNumber.length != 10 || $scope.phoneNumber == null) {
        return Swal.fire({
          icon: "error",
          title: "Có lỗi sảy ra",
          text: "Vui lòng nhập đúng số điện thoại!",
        });
      }
      var iname = $scope.fullname
      if (iname == null) {
        return Swal.fire({
          icon: "error",
          title: "Có lỗi sảy ra",
          text: "Vui lòng nhập đúng tên người dùng",
        });
      }
      var iemail = $scope.email;
      if (iemail == null) {
        return Swal.fire({
          icon: "error",
          title: "Có lỗi sảy ra",
          text: "Vui lòng nhập đúng email",
        });
      }
      if (!$scope.selectedPaymentMethod) {
        return showAlert("Vui Lòng Chọn Phương Thức Thanh Toán!");
      }
      if (!$scope.selectedShip) {
        return showAlert("Vui Lòng Chọn Đơn Vị Vận Chuyển");
      }
      const invoiceDto = {
        invoiceCode: $scope.generateInvoiceCode(),
        nguoiNhanHang: iname,
        email: iemail,
        deliveryaddress: iaddress,
        phonenumber: iphoneNumber,
        paymentmethod: $scope.selectedPaymentMethod,
        voucherCode: $scope.voucher ? $scope.voucher.Vouchercode : null,
        sotienGiamGia: $scope.discountmoney || 0,
        sotienShip: $scope.selectedShip,
        tongTien: $scope.totalamount,
        invoiceDetails: $scope.lstProductOder
          .filter((x) => x.selected === true) // Lọc các sản phẩm được chọn
          .map((x) => ({
            quantity: x.quantity,
            price: x.productDetails.price,
            totalprice: x.quantity * x.productDetails.price,
            milkDetail: { id: x.id },
          })),
      };
      $scope.showTerms().then(function (isAgreed) {
        if (isAgreed) {
          $scope.sendMessage("/app/invoice", invoiceDto.invoiceCode)
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
                if ($scope.selectedPaymentMethod === "COD") {
                  $scope.sendMessage("/app/cod", invoiceDto.invoiceCode)
                }
                $scope.lstProductOde = localStorage.removeItem("lstProductOder");
                if ($scope.userInfo) {
                  window.location.href = "/invoicedetail/" + invoiceDto.invoiceCode
                } else {
                  window.location.href = "/login"
                }
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
        }
      });

    };

    // Hàm xử lý lỗi
    function handleError(error) {
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
    $scope.showTerms = function () {
      return Swal.fire({
        title: 'Điều Khoản và Điều Kiện',
        html: `
          <h6>Điều Khoản 1: Cung Cấp Thông Tin Chính Xác</h6>
          <p>
          Người dùng cam kết cung cấp thông tin đầy đủ và chính xác bao gồm họ tên, địa chỉ nhận hàng, số điện thoại và thông tin thanh toán. 
          Nếu thông tin không chính xác hoặc không đầy đủ, hệ thống có quyền từ chối xử lý đơn hàng.
          </p>

          <h6>Điều Khoản 2: Thanh Toán Và Xác Nhận</h6>
          <p>
          Hóa đơn sẽ chỉ được tạo sau khi người dùng hoàn tất thanh toán qua phương thức đã chọn. 
          Trong trường hợp thanh toán thất bại, đơn hàng sẽ không được xử lý và hệ thống sẽ thông báo qua email hoặc số điện thoại cung cấp.
          </p>

          <h6>Điều Khoản 3: Thời Gian Hiệu Lực Của Hóa Đơn</h6>
          <p>
          Hóa đơn có hiệu lực trong vòng 24 giờ kể từ khi được tạo. Sau thời gian này, nếu không có khiếu nại từ phía người dùng, hóa đơn sẽ được xem là hợp lệ và không thể chỉnh sửa hoặc hủy bỏ.
          </p>

          <h6>Điều Khoản 4: Trách Nhiệm Kiểm Tra Thông Tin</h6>
          <p>
          Người dùng chịu trách nhiệm kiểm tra thông tin đơn hàng, bao gồm sản phẩm, số lượng và tổng tiền trước khi xác nhận. 
          Hệ thống sẽ không chịu trách nhiệm đối với sai sót do người dùng nhập sai thông tin.
          </p>

          <label>
            <input type="checkbox" id="termsCheckbox">
            Tôi đã đọc và đồng ý với các Điều Khoản liên quan đến việc tạo và xử lý hóa đơn.
          </label>
        `,
        icon: 'info',
        showCancelButton: true,
        confirmButtonText: 'Chấp Nhận',
        cancelButtonText: 'Đóng',
        preConfirm: function () {
          if (!document.getElementById('termsCheckbox').checked) {
            Swal.showValidationMessage('Vui lòng đồng ý với điều khoản');
            return false;
          }
          return true;
        }
      }).then(function (result) {
        // Kết quả khi người dùng nhấn "Chấp Nhận"
        return result.isConfirmed;
      });
    };

    // Gọi hàm loadTinh khi khởi tạo controller
    $scope.loadTinh();
    $scope.user();
    $scope.loadVoucher();
    $scope.sendMessage = function (url, message) {
      if ($rootScope.stompClient && $rootScope.stompClient.connected) {
        $rootScope.stompClient.send(url, {}, JSON.stringify(message));
      } else {
        console.error("WebSocket is not connected.");
      }
    };
  }
);
