app.controller("LoginController", function ($scope, $http, socket) {
  $scope.isLoggedIn = !!localStorage.getItem("authToken");

  // Phân tích JWT token
  function parseJwt(token) {
    const base64Url = token.split(".")[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(base64));
  }
  $scope.connectUser = function (user) {
    socket.connect(user).then(function () {
      socket.sendMessage('/app/connect', { userId: user.id, role: user.role });
    });
  };
  // Đăng nhập
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



    $http.post("http://160.30.21.47:1234/api/user/authenticate", {
      username: $scope.user.username,
      password: $scope.user.password,
    }).then(
      function success(response) {
        if (response.status === 200) {
          const token = response.data.token;
          const userInfo = parseJwt(token);

          if (token) {
            localStorage.setItem("authToken", token);
            localStorage.setItem("userInfo", JSON.stringify(userInfo));
            $scope.isLoggedIn = true;

            // Kiểm tra quyền của người dùng
            if (userInfo.role === "Admin" || userInfo.role === "Staff") {
              Swal.fire({
                icon: "warning",
                title: "Thông báo",
                text: "Bạn là Admin và chỉ được phép truy cập trang admin.",
                confirmButtonText: "OK",
                timer: 3000,
              }).then(() => {
                window.location.href = "http://160.30.21.47:3004/"; // Redirect đến trang admin
              });
              return;
            }
          }

          // $scope.connectUser(userInfo); // Kết nối WebSocket sau khi đăng nhập thành công
          Swal.fire({
            icon: "success",
            title: "Thành công!",
            text: response.data.message || "Đăng nhập thành công!",
            confirmButtonText: "OK",
            timer: 3000,
          }).then(() => {
            const redirectPath = localStorage.getItem("redirectAfterLogin");
            if (redirectPath) {
              localStorage.removeItem("redirectAfterLogin");
              window.location.href = redirectPath; // Redirect đến trang sau khi đăng nhập
            } else {
              window.location.href = "/home"; // Redirect đến trang chủ
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
      },
      function error(response) {
        let errorMessage = response.status === 401
          ? response.data.error || "Sai tên đăng nhập hoặc mật khẩu. Vui lòng kiểm tra và thử lại."
          : "Đăng nhập thất bại. Vui lòng thử lại.";

        Swal.fire({
          icon: "error",
          title: "Lỗi!",
          text: errorMessage,
          confirmButtonText: "OK",
        });
      }
    );
  };

  // Ngắt kết nối WebSocket
  $scope.disconnectUser = function (user) {
    socket.disconnect(user);
  };

  // Đăng xuất
  $scope.logout = function () {
    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    if (!userInfo) return;

    Swal.fire({
      title: 'Are you sure?',
      text: "Bạn có muốn đăng xuất không?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes',
      cancelButtonText: 'No',
    }).then((result) => {
      if (result.isConfirmed) {
        $scope.disconnectUser(userInfo); // Ngắt kết nối WebSocket khi đăng xuất
        localStorage.removeItem("authToken");
        localStorage.removeItem("userInfo");
        $scope.isLoggedIn = false;
        Swal.fire({
          icon: "info",
          title: "Đăng xuất thành công!",
          text: "Bạn đã đăng xuất khỏi tài khoản.",
          confirmButtonText: "OK",
          timer: 3000,
        }).then(() => {
          window.location.href = "/login"; // Redirect đến trang đăng nhập
        });
      }
    });
  };
});
