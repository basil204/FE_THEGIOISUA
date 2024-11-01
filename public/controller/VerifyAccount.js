app.controller(
  "VerifyController",
  function ($scope, $routeParams, $http, $location) {
    // Function to verify the token
    $scope.verifyToken = function () {
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

      // Call the verification API
      $http({
        method: "GET",
        url: `http://160.30.21.47:1234/api/user/verify?token=${token}`,
      }).then(
        function success(response) {
          Swal.fire({
            icon: "success",
            title: "Thành công!",
            text: response.data.message || "Xác minh thành công!",
            confirmButtonText: "OK",
            timer: 3000,
          });
          setTimeout(() => {
            $location.path("/login"); // Redirect to login after 3 seconds
            $scope.$apply(); // Trigger Angular's digest cycle for navigation
          }, 3000);
        },
        function error(response) {
          Swal.fire({
            icon: "error",
            title: "Lỗi!",
            text: response.data.error || "Xác minh thất bại. Vui lòng thử lại.",
            confirmButtonText: "OK",
          });
        }
      );
    };

    // Automatically call verifyToken() on route load
    $scope.verifyToken();
  }
);
