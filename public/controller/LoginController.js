app.controller("LoginController", function ($scope, $http) {
  // Check login status
  $scope.isLoggedIn = !!localStorage.getItem("authToken");

  // Decode JWT token to retrieve user info
  function parseJwt(token) {
    const base64Url = token.split(".")[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(base64));
  }

  // Login function
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
            console.log(userInfo);
            localStorage.setItem("userInfo", JSON.stringify(userInfo));
            $scope.isLoggedIn = true; // Update login status

            // Check user role
            if (userInfo.role === "Admin") {
              Swal.fire({
                icon: "warning",
                title: "Thông báo",
                text: "Bạn là Admin và chỉ được phép truy cập trang admin.",
                confirmButtonText: "OK",
                timer: 3000,
              }).then(() => {
                window.location.href = "http://160.30.21.47:3001/"; // Redirect to admin page
              });
              return; // Exit function if user is Admin
            }
          }
          Swal.fire({
            icon: "success",
            title: "Thành công!",
            text: response.data.message || "Đăng nhập thành công!",
            confirmButtonText: "OK",
            timer: 3000,
          }).then(() => {
            window.location.href = "/home"; // Redirect to home page for non-admin users
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

  // Logout function
  $scope.logout = function () {
    Swal.fire({
      title: 'Are you sure?',
      text: "Bạn Có Muốn Đăng Xuất Không?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes',
      cancelButtonText: 'No',
    }).then((result) => {
      if (result.isConfirmed) {
        localStorage.removeItem("authToken"); // Remove token from localStorage
        localStorage.removeItem("userInfo"); // Remove user info
        $scope.isLoggedIn = false; // Update login status

        Swal.fire({
          icon: "info",
          title: "Đăng xuất thành công!",
          text: "Bạn đã đăng xuất khỏi tài khoản.",
          confirmButtonText: "OK",
          timer: 3000,
        }).then(() => {
          window.location.href = "/login"; // Redirect to login page
        });
      }
    });

  };
  $scope.changePassword = function () {
    const currentPassword = $scope.currentPassword;
    const newPassword = $scope.newPassword;
    const confirmNewPassword = $scope.confirmNewPassword;

    // Validate inputs
    if (!currentPassword || !newPassword || !confirmNewPassword) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Vui lòng điền đầy đủ thông tin.",
        confirmButtonText: "OK",
      });
      return;
    }

    if (newPassword !== confirmNewPassword) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Mật khẩu mới và xác nhận mật khẩu không khớp.",
        confirmButtonText: "OK",
      });
      return;
    }
    // Retrieve user ID from token and prepare the request
    const token = localStorage.getItem("authToken");
    const userInfo = parseJwt(token);
    const userId = userInfo.id; // assuming 'id' is part of token payload

    $http({
      method: "POST",
      url: "http://160.30.21.47:1234/api/user/change-password",
      headers: {
        Authorization: `Bearer ${token}`, // Set token in headers for authorization
      },
      params: {
        userId: userId,
        oldPassword: currentPassword,
        newPassword: newPassword,
      },
    }).then(
      function success(response) {
        Swal.fire({
          icon: "success",
          title: "Thành công!",
          text: "Mật khẩu đã được thay đổi thành công!",
          confirmButtonText: "OK",
          timer: 3000,
        });
        $("#changePassword").modal("hide"); // Hide modal after successful change
      },
      function error(response) {
        const errorMessage =
          response.data.error ||
          "Thay đổi mật khẩu thất bại. Vui lòng thử lại.";
        Swal.fire({
          icon: "error",
          title: "Lỗi!",
          text: errorMessage,
          confirmButtonText: "OK",
        });
      }
    );
  };
});
