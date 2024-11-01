app.controller("LoginController", function ($scope, $http) {
  // Kiểm tra trạng thái đăng nhập
  $scope.isLoggedIn = !!localStorage.getItem("authToken");

  // Hàm để giải mã token JWT và lấy thông tin người dùng
  function parseJwt(token) {
    const base64Url = token.split(".")[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(base64));
  }

  // Hàm đăng nhập
  $scope.login = function () {
    if (!$scope.user.username || !$scope.user.password) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Vui lòng điền đầy đủ thông tin đăng nhập.",
        confirmButtonText: "OK",
      });
      return;
    }

    $http({
      method: "POST",
      url: "http://160.30.21.47:1234/api/user/authenticate",
      data: {
        username: $scope.user.username,
        password: $scope.user.password,
      },
    }).then(
      function success(response) {
        if (response.status === 200) {
          const token = response.data.token;
          if (token) {
            localStorage.setItem("authToken", token);
            const userInfo = parseJwt(token);
            localStorage.setItem("userInfo", JSON.stringify(userInfo));
            $scope.isLoggedIn = true; // Cập nhật trạng thái đăng nhập
          }

          Swal.fire({
            icon: "success",
            title: "Thành công!",
            text: response.data.message || "Đăng nhập thành công!",
            confirmButtonText: "OK",
            timer: 3000,
          }).then(() => {
            window.location.href = "/home";
          });
        } else {
          Swal.fire({
            icon: "error",
            title: "Lỗi!",
            text: "Đăng nhập thất bại. Vui lòng thử lại.",
            confirmButtonText: "OK",
          });
        }
      },
      function error(response) {
        let errorMessage = "Đăng nhập thất bại. Vui lòng thử lại.";
        if (response.status === 401) {
          errorMessage =
            response.data.error ||
            "Sai tên đăng nhập hoặc mật khẩu. Vui lòng kiểm tra và thử lại.";
        }

        Swal.fire({
          icon: "error",
          title: "Lỗi!",
          text: errorMessage,
          confirmButtonText: "OK",
        });
      }
    );
  };

  // Hàm đăng xuất
  $scope.logout = function () {
    localStorage.removeItem("authToken"); // Xóa token khỏi localStorage
    localStorage.removeItem("userInfo"); // Xóa thông tin người dùng
    $scope.isLoggedIn = false; // Cập nhật trạng thái đăng nhập

    Swal.fire({
      icon: "info",
      title: "Đăng xuất thành công!",
      text: "Bạn đã đăng xuất khỏi tài khoản.",
      confirmButtonText: "OK",
      timer: 3000,
    }).then(() => {
      window.location.href = "/login"; // Chuyển hướng về trang đăng nhập
    });
  };
});
