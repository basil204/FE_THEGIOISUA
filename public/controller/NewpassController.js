app.controller(
  "NewpassController",
  function ($scope, $routeParams, $http, $location) {
    // Function to reset the password
    $scope.resetPassword = function () {
      const token = $routeParams.token;

      if (!token) {
        Swal.fire({
          icon: "error",
          title: "Lỗi!",
          text: "Không tìm thấy token. Vui lòng kiểm tra lại.",
          confirmButtonText: "OK",
        });
        return;
      }

      if ($scope.newPassword !== $scope.confirmPassword) {
        Swal.fire({
          icon: "error",
          title: "Lỗi!",
          text: "Mật khẩu không khớp. Vui lòng nhập lại.",
          confirmButtonText: "OK",
        });
        return;
      }

      // Call the reset password API
      $http({
        method: "POST",
        url: "http://localhost:1234/api/user/reset-password",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        data: $.param({
          token: token,
          newPassword: $scope.newPassword,
        }),
      }).then(
        function success(response) {
          Swal.fire({
            icon: "success",
            title: "Thành công!",
            text:
              response.data.message || "Mật khẩu đã được đặt lại thành công!",
            confirmButtonText: "OK",
            timer: 3000,
          });
          setTimeout(() => {
            $location.path("/login"); // Redirect to login after success
            $scope.$apply();
          }, 3000);
        },
        function error(response) {
          Swal.fire({
            icon: "error",
            title: "Lỗi!",
            text:
              response.data.error ||
              "Đặt lại mật khẩu thất bại. Vui lòng thử lại.",
            confirmButtonText: "OK",
          });
        }
      );
    };
  }
);
