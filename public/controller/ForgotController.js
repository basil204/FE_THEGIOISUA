app.controller("ForgotController", function ($scope, $http, socket) {
  // Function to send forgot password request
  const userInfo = JSON.parse(localStorage.getItem("userInfo"));
  if (userInfo) {
    socket.connect(userInfo);
  }
  $scope.sendForgotPassword = function () {
    if (!$scope.email) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Vui lòng nhập địa chỉ email.",
        confirmButtonText: "OK",
      });
      return;
    }

    // Call the forgot password API
    $http({
      method: "POST",
      url: "http://160.30.21.47:1234/api/user/forgot-password",
      data: { email: $scope.email },
    }).then(
      function success(response) {
        Swal.fire({
          icon: "success",
          title: "Thành công!",
          text:
            response.data.message || "Email đã được gửi để đặt lại mật khẩu!",
          confirmButtonText: "OK",
          timer: 3000,
        });
      },
      function error(response) {
        Swal.fire({
          icon: "error",
          title: "Lỗi!",
          text:
            response.data.error || "Gửi yêu cầu thất bại. Vui lòng thử lại.",
          confirmButtonText: "OK",
        });
      }
    );
  };
});
