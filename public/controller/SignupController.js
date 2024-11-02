app.controller("SignupController", function ($scope, $http) {
  $scope.user = {
    username: "",
    password: "",
    rePassword: "",
    fullname: "",
    email: "",
  };

  $scope.register = function () {
    // Kiểm tra các trường không được để trống
    if (
      !$scope.user.fullname ||
      !$scope.user.email ||
      !$scope.user.username ||
      !$scope.user.password ||
      !$scope.user.rePassword
    ) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Vui lòng điền đầy đủ thông tin.",
        confirmButtonText: "OK",
      });
      return; // Dừng việc gửi form nếu thông tin không đầy đủ
    }

    // Kiểm tra mật khẩu và xác nhận mật khẩu
    if ($scope.user.password !== $scope.user.rePassword) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Mật khẩu và xác nhận mật khẩu không trùng khớp. Vui lòng kiểm tra lại.",
        confirmButtonText: "OK",
      });
      return; // Dừng việc gửi form nếu không trùng khớp
    }

    // Kiểm tra độ dài mật khẩu
    if ($scope.user.password.length < 6) {
      Swal.fire({
        icon: "error",
        title: "Lỗi!",
        text: "Mật khẩu phải có ít nhất 6 ký tự.",
        confirmButtonText: "OK",
      });
      return; // Dừng việc gửi form nếu mật khẩu quá ngắn
    }

    // Nếu trùng khớp, tiếp tục với việc gọi API đăng ký
    $http({
      method: "POST",
      url: "http://localhost:1234/api/user/register",
      data: {
        username: $scope.user.username,
        password: $scope.user.password,
        fullname: $scope.user.fullname,
        email: $scope.user.email,
      },
    }).then(
      function success(response) {
        const successMessage = response.data.message || "Đăng ký thành công!";

        Swal.fire({
          icon: "success",
          title: "Thành công!",
          text: successMessage,
          confirmButtonText: "OK",
          timer: 3000,
        }).then(() => {
          window.location.href = "/login";
        });
      },
      function error(response) {
        const errorMessage = response.data.error || "Vui lòng thử lại.";

        Swal.fire({
          icon: "error",
          title: "Đăng ký thất bại!",
          text: errorMessage,
          confirmButtonText: "OK",
        });
      }
    );
  };
});
