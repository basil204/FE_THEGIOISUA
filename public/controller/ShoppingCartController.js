app.controller(
  "ShoppingCartController",
  function (
    $scope,
    $http,
    $rootScope,
    PaymentService,
    AddressService,
    LocationService,
    ShipService,
    SwalService,
    StatusService,
    InvoiceService
  ) {
    $scope.userInfo = JSON.parse(localStorage.getItem("userInfo")) || null;
    let addresssplit = null;
    $scope.lstProductOder =
      JSON.parse(localStorage.getItem("lstProductOder")) || [];
    const urlInvoice = "http://160.30.21.47:1234/api/Invoice/add";
    const apiUser = "http://160.30.21.47:1234/api/user/";
    const apiVoucher = "http://160.30.21.47:1234/api/Voucher/";
    const apitGetInvoiceByUser =
      "http://160.30.21.47:1234/api/Invoice/getInvoicespage/";
    $scope.getStatus = function (statusCode) {
      return StatusService.getStatus(statusCode);
    };
    $scope.selectedVoucher = function (x) {
      $scope.vouchercode = x;
      $scope.checkvoucher();
    };
    $scope.loadVoucher = function () {
      $http
        .get(apiVoucher + "voucherActive")
        .then(function (response) {
          $scope.vouchers = response.data.Succes;
        })
        .catch(function (error) {
          console.error("Có lỗi khi tải thông tin voucher:", error.data);
        });
    };
    $scope.selectedShipping = function (isSelected) {
      idrate = isSelected.id;
    };
    $scope.removeSelectedProducts = function () {
      swal
        .fire({
          title: "Bạn có chắc chắn?",
          text: "Sản phẩm đã chọn sẽ bị xóa!",
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: "Xóa",
          cancelButtonText: "Hủy",
        })
        .then((result) => {
          if (result.isConfirmed) {
            $scope.lstProductOder = $scope.lstProductOder.filter(
              (product) => !product.selected
            );
            localStorage.setItem(
              "lstProductOder",
              JSON.stringify($scope.lstProductOder)
            );
            $scope.$apply();
          }
        });
    };

    $scope.selectAllProducts = function () {
      $scope.lstProductOder.forEach((product) => {
        product.selected = true;
      });
      localStorage.setItem(
        "lstProductOder",
        JSON.stringify($scope.lstProductOder)
      );
    };
    $scope.unselectAllProducts = function () {
      $scope.lstProductOder.forEach((product) => {
        product.selected = false;
      });
      localStorage.setItem(
        "lstProductOder",
        JSON.stringify($scope.lstProductOder)
      );
    };
    $scope.selectedProductBycart = function (index) {
      const selectedProduct = $scope.lstProductOder[index];
      if (selectedProduct.selected) {
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.lstProductOder)
        );
      } else {
        localStorage.setItem(
          "lstProductOder",
          JSON.stringify($scope.lstProductOder)
        );
      }
    };
    $scope.removeAllProducts = function () {
      swal
        .fire({
          title: "Bạn có chắc chắn?",
          text: "Sản phẩm đã chọn sẽ bị xóa!",
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: "Xóa",
          cancelButtonText: "Hủy",
        })
        .then((result) => {
          if (result.isConfirmed) {
            $scope.lstProductOder = localStorage.removeItem("lstProductOder");
            $scope.lstProductOder = [];
            $scope.$apply();
          }
        });
    };
    $scope.getInvoiceDetailByUser = function (invoice) {
      window.location.href = "/invoicedetail/" + invoice.invoiceCode;
    };
    $scope.currentPage = 0;
    $scope.pageSize = 5;
    function formatDate(date) {
      const d = new Date(date); // Convert to Date object
      const year = d.getFullYear();
      const month = ("0" + (d.getMonth() + 1)).slice(-2); // Add leading 0 for months < 10
      const day = ("0" + d.getDate()).slice(-2); // Add leading 0 for days < 10
      const hours = ("0" + d.getHours()).slice(-2); // Add leading 0 for hours < 10
      const minutes = ("0" + d.getMinutes()).slice(-2); // Add leading 0 for minutes < 10
      const seconds = ("0" + d.getSeconds()).slice(-2); // Add leading 0 for seconds < 10

      return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}`;
    }
    $scope.searchInvoices = function () {
      $scope.getInvoicesByUser(true); // Gọi hàm với resetPage = true để đặt lại trang về 0 khi tìm kiếm mới.
    };
    $scope.getInvoicesByUser = function (resetPage = false) {
      // Đảm bảo $scope.search luôn là một đối tượng
      $scope.search = $scope.search || {};

      // Kiểm tra nếu có yêu cầu reset currentPage về 0
      if (resetPage) {
        $scope.currentPage = 0; // Đặt lại trang hiện tại về 0 nếu có yêu cầu
      }
      let queryParams = [];

      // Kiểm tra nếu startDate có giá trị, nếu có thì thêm vào queryParams
      if ($scope.search.startDate) {
        queryParams.push(`startDate=${formatDate($scope.search.startDate)}`);
      }
      if ($scope.search.trangThai) {
        queryParams.push(`trangThai=${$scope.search.trangThai}`);
      }

      // Tạo query string từ mảng queryParams
      let queryString = queryParams.join("&");

      // Kiểm tra xem userInfo có hợp lệ không
      if ($scope.userInfo && $scope.userInfo.id) {
        // Thực hiện HTTP GET, thêm page và size vào queryString
        $http
          .get(
            `${apitGetInvoiceByUser}${$scope.userInfo.id}?${queryString}&page=${$scope.currentPage}&size=${$scope.pageSize}`
          )
          .then((response) => {
            if (response.status === 200) {
              console.log(response);
              $scope.userInvoices = response.data.data.content; // Lưu danh sách hóa đơn vào scope để hiển thị
              $scope.pageInfo = response.data.data.page; // Lưu thông tin trang vào scope
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

    $scope.nextPage = function () {
      if ($scope.currentPage < $scope.pageInfo.totalPages - 1) {
        $scope.currentPage++;
        // Check if searchInvoices is being used, otherwise call getInvoices

        $scope.getInvoicesByUser();
      }
    };

    $scope.previousPage = function () {
      if ($scope.currentPage > 0) {
        $scope.currentPage--;
        // Check if searchInvoices is being used, otherwise call getInvoices
        $scope.getInvoicesByUser();
      }
    };

    $scope.goToFirstPage = function () {
      $scope.currentPage = 0;
      $scope.getInvoices();
    };

    $scope.goToLastPage = function () {
      $scope.currentPage = $scope.pageInfo.totalPages - 1;
      // Check if searchInvoices is being used, otherwise call getInvoices
      $scope.getInvoicesByUser();
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
        $http
          .get(apiUser + "profile/" + $scope.userInfo.id)
          .then(function (response) {
            $scope.userData = response.data; // Lưu dữ liệu vào $scope.userData
            $scope.email = $scope.userData.email;
            $scope.fullname = $scope.userData.fullName;
            $scope.phoneNumber = Number($scope.userData.phoneNumber);
            $scope.phonenumber = Number($scope.userData.phoneNumber);
            addresssplit = AddressService.splitAddress($scope.userData.address);
            $scope.selectedTinh = $scope.tinhs.find(
              (tinh) => tinh.name === addresssplit[0]
            ).id;
            $scope.loadQuan();
          })
          .catch(function (error) {
            console.error("Error fetching user data:", error);
          });
      } else {
        console.warn("User info is not available."); // Thông báo khi $scope.userInfo chưa có
      }
    };

    $scope.amountShip = function () {
      const data = {
        shipment: {
          address_from: {
            district: "181810", // ngo quyen
            city: "180000", //hai phong
          },
          address_to: {
            district: $scope.selectedQuan,
            city: $scope.selectedTinh,
          },
          parcel: {
            cod: $scope.calculateTotal(),
            amount: $scope.calculateTotal(),
            width: 20,
            height: 20,
            length: 20,
            weight: 500,
          },
        },
      };
      ShipService.calculateShipping(data)
        .then(function (response) {
          $scope.ships = response.data.data;
        })
        .catch(function (error) {
          console.error("API Error:", error);
        });
    };
    $scope.loadTinh = function () {
      LocationService.getCities()
        .then(function (response) {
          $scope.tinhs = response.data.data;
          $scope.user();
        })
        .catch(function (error) {
          console.error("Error loading cities:", error);
        });
    };

    // Hàm xử lý địa chỉ
    $scope.loadQuan = function () {
      var idTinh = $scope.selectedTinh;
      if (idTinh) {
        LocationService.getDistricts(idTinh)
          .then(function (response) {
            $scope.quans = response.data.data;
            if (addresssplit) {
              $scope.selectedQuan = $scope.quans.find(
                (quan) => quan.name === addresssplit[1]
              ).id;
              $scope.loadPhuong();
            }
          })
          .catch(function (error) {
            console.error("Error loading districts:", error);
          });
      }
    };
    $scope.loadPhuong = function () {
      var idQuan = $scope.selectedQuan;
      if (idQuan) {
        LocationService.getWards(idQuan)
          .then(function (response) {
            $scope.phuongs = response.data.data;
            if (addresssplit) {
              $scope.selectedPhuong = $scope.phuongs.find(
                (phuong) => phuong.name === addresssplit[2]
              ).id;
              $scope.detailAddress = addresssplit[3];
              $scope.amountShip();
            }
          })
          .catch(function (error) {
            console.error("Error loading wards:", error);
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
          if (error.data && error.status === 400) {
            // Nếu có lỗi và trả về status là "error", hiển thị thông báo lỗi cụ thể
            const errorMessage = error.data.errors;

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
          if (error.data && error.status === 400) {
            // Nếu có lỗi và trả về status là "error", hiển thị thông báo lỗi cụ thể
            const errorMessage = error.data.errors;

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
        !$scope.getQuanName() ||
        !$scope.getPhuongName() ||
        !$scope.detailAddress
      ) {
        Swal.fire({
          icon: "error",
          title: "Oops...",
          text: "Vui lòng chọn đầy đủ Địa Chỉ",
        });
        return;
      }

      return AddressService.concatAddress(
        $scope.getTinhName(),
        $scope.getQuanName(),
        $scope.getPhuongName(),
        $scope.detailAddress
      );
    };
    $scope.addAdress = function () {
      const user = {
        id: $scope.userData.id,
        address: $scope.getAdressInput(),
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
          if (error.data && error.status === 400) {
            // Nếu có lỗi và trả về status là "error", hiển thị thông báo lỗi cụ thể
            const errorMessage = error.data.errors;

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
      return LocationService.findById($scope.tinhs, $scope.selectedTinh);
    };

    $scope.getQuanName = function () {
      return LocationService.findById($scope.quans, $scope.selectedQuan);
    };
    $scope.getPhuongName = function () {
      return LocationService.findById($scope.phuongs, $scope.selectedPhuong);
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
      if (!$scope.fullname || $scope.fullname.trim().length === 0) {
        Swal.fire({
          icon: "error",
          title: "Lỗi",
          text: "Tên Người nhận không được để trống",
          confirmButtonText: "Đóng",
          confirmButtonColor: "#d33",
        });
        return;
      }

      // Kiểm tra độ dài của tên (tối thiểu 5 ký tự và tối đa 100 ký tự)
      if (
        $scope.fullname.trim().length < 5 ||
        $scope.fullname.trim().length > 100
      ) {
        Swal.fire({
          icon: "error",
          title: "Lỗi",
          text: "Tên Người nhận phải có độ dài từ 5 đến 100 ký tự",
          confirmButtonText: "Đóng",
          confirmButtonColor: "#d33",
        });
        return;
      }
      const nameRegex = /^[A-Za-zÀ-ỹà-ỹ\s]+$/u;
      if (!nameRegex.test($scope.fullname.trim())) {
        Swal.fire({
          icon: "error",
          title: "Lỗi",
          text: "Tên Người nhận chỉ được chứa ký tự chữ cái và dấu cách",
          confirmButtonText: "Đóng",
          confirmButtonColor: "#d33",
        });
        return;
      }
      if (!$scope.phoneNumber || !/^\d{9,11}$/.test($scope.phoneNumber)) {
        Swal.fire({
          icon: "error",
          title: "Lỗi",
          text: "Số điện thoại phải 10 chữ số và không được để trống",
          confirmButtonText: "Đóng",
          confirmButtonColor: "#d33",
        });
        return;
      }

      // Validate email (nếu email là bắt buộc)
      if ($scope.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test($scope.email)) {
        Swal.fire({
          icon: "error",
          title: "Lỗi",
          text: "Email không đúng định dạng",
          confirmButtonText: "Đóng",
          confirmButtonColor: "#d33",
        });
        return;
      }
      const selectedProducts = $scope.lstProductOder.filter(
        (x) => x.selected === true
      );
      if (selectedProducts.length === 0) {
        Swal.fire({
          icon: "error",
          title: "Lỗi",
          text: "Vui lòng chọn ít nhất một sản phẩm để đặt hàng",
          confirmButtonText: "Đóng",
          confirmButtonColor: "#d33",
        });
        return;
      }
      $scope.strphoneNumber = "0" + $scope.phoneNumber;
      const validationResult = InvoiceService.validateInvoiceData($scope);
      if (validationResult) {
        const invoiceDto = {
          invoiceCode: $scope.generateInvoiceCode(),
          nguoiNhanHang: $scope.fullname,
          email: $scope.email,
          deliveryaddress: $scope.getAdressInput(),
          phonenumber: $scope.strphoneNumber,
          paymentmethod: $scope.selectedPaymentMethod,
          voucherCode: $scope.voucher ? $scope.voucher.Vouchercode : null,
          sotienGiamGia: $scope.discountmoney || 0,
          sotienShip: $scope.selectedShip.total_fee,
          tongTien:
            ($scope.calculateTotal() || 0) -
            ($scope.discountmoney || 0) +
            ($scope.selectedShip.total_fee || 0),
          invoiceDetails: $scope.lstProductOder
            .filter((x) => x.selected === true) // Lọc các sản phẩm được chọn
            .map((x) => ({
              quantity: x.quantity,
              price: x.productDetails.price,
              totalprice: x.quantity * x.productDetails.price,
              milkDetail: { id: x.id },
            })),
        };
        SwalService.showTerms().then(function (isAgreed) {
          if (isAgreed) {
            $http.post(urlInvoice, invoiceDto).then((response) => {
              $scope.sendMessage("/app/invoice", invoiceDto.invoiceCode);
              $scope.lstProductOde = localStorage.removeItem("lstProductOder");
              if ($scope.selectedPaymentMethod === "COD") {
                $scope.sendMessage("/app/cod", invoiceDto.invoiceCode);
                if ($scope.userInfo) {
                  window.location.href =
                    "/invoicedetail/" + invoiceDto.invoiceCode;
                } else {
                  window.location.href = "/home";
                }
              } else {
                $scope
                  .creaetOdership(
                    invoiceDto.invoiceCode,
                    invoiceDto.nguoiNhanHang,
                    invoiceDto.phonenumber,
                    invoiceDto.deliveryaddress
                  )
                  .then(function (data) {
                    $scope.payment(invoiceDto.tongTien, invoiceDto.invoiceCode);
                  })
                  .catch(function (error) {
                    Swal.fire({
                      icon: "error",
                      title: "Đặt Hàng Thất Bại",
                      text: error.data,
                    });
                  });
              }
            });
          }
        });
      }
    };

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
    $scope.loadTinh();
    $scope.loadVoucher();
    $scope.sendMessage = function (url, message) {
      if ($rootScope.stompClient && $rootScope.stompClient.connected) {
        $rootScope.stompClient.send(url, {}, JSON.stringify(message));
      } else {
        console.error("WebSocket is not connected.");
      }
    };
    $scope.creaetOdership = function (invoiceCode, name, phone, address) {
      data = {
        shipment: {
          rate: idrate, // Giá vận chuyển
          order_id: invoiceCode, // Mã đơn hàng
          address_from: {
            // Địa chỉ người gửi (cố định)
            name: "SUA FPOLY",
            phone: "0909090909",
            street: "271 Lê Thánh Tông",
            ward: "1097",
            district: "181810", // ngo quyen
            city: "180000", //hai phong
          },
          address_to: {
            // Địa chỉ người nhận (động)
            name: name,
            phone: phone,
            street: address,
            district: $scope.selectedQuan,
            ward: $scope.selectedPhuong,
            city: $scope.selectedTinh,
          },
          parcel: {
            // Chi tiết gói hàng
            cod: $scope.calculateTotal() || 0, // Tổng tiền hàng
            amount: $scope.calculateTotal() || 0, // Giá trị đơn hàng
            weight: "500", // Trọng lượng (gram)
            width: "20", // Chiều rộng (cm)
            height: "20", // Chiều cao (cm)
            length: "20", // Chiều dài (cm)
            metadata: "Hàng nặng, cẩn thận khi vận chuyển.", // Ghi chú
          },
        },
      };
      return ShipService.createShipment(data);
    };
    $scope.payment = function (totalamount, invoicecode) {
      PaymentService.processPayment(
        totalamount,
        invoicecode,
        function () {
          // Thành công
          window.location.href = "/home";
        },
        function (error) {
          // Xử lý lỗi nếu cần
          console.error("Lỗi khi thanh toán:", error);
        }
      );
    };
  }
);
