app.controller("LoginController", function ($rootScope, $scope, $http) {
  // Check login status
  $scope.isLoggedIn = !!localStorage.getItem("authToken");

  // Decode JWT token to retrieve user info
  function parseJwt(token) {
    const base64Url = token.split(".")[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(base64));
  }
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
    $http({
      method: "POST",
      url: "http://160.30.21.47:1234/api/user/change-password",
      headers: {
        Authorization: `Bearer ${token}`, // Set token in headers for authorization
      },
      params: {
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
            const userInfo = parseJwt(token);
            $scope.isLoggedIn = true; // Update login status
            if (userInfo.role === "Customer") {
              Swal.fire({
                icon: "success",
                title: "Thành công!",
                text: response.data.message || "Đăng nhập thành công!",
                confirmButtonText: "OK",
                timer: 3000,
              }).then(() => {
                localStorage.setItem("authToken", token);
                localStorage.setItem("userInfo", JSON.stringify(userInfo));
                const redirectPath = localStorage.getItem("redirectAfterLogin");
                if (redirectPath) {
                  localStorage.removeItem("redirectAfterLogin"); // Clear the redirect path after use
                  window.location.href = redirectPath; // Redirect to the intended page
                } else {
                  window.location.href = "/home"; // Default to home page if no redirect path
                }
              });
            } else {
              Swal.fire({
                icon: "error",
                title: "Lỗi!",
                text: "Đăng nhập thất bại. Vui lòng thử lại.",
                confirmButtonText: "OK",
              });
            }
          }
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
        $rootScope.stompClient.disconnect();
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
});
