var app = angular.module("myApp", ["ngRoute"]);

// Configure routes
app.config(function ($routeProvider, $locationProvider) {
  $routeProvider
    .when("/home", {
      templateUrl: "Pages/home.html",
      controller: "ProductListController",
    })
    .when("/product-detail", {
      templateUrl: "Pages/product-detail.html",
      controller: "ProductDetailController",
    })
    .when("/login", {
      templateUrl: "Pages/login.html",
      controller: "LoginController",
    })
    .when("/sign-up", {
      templateUrl: "Pages/sign-up.html",
      controller: "SignupController",
    })
    .when("/forgot", {
      templateUrl: "Pages/forgot.html",
      controller: "",
    })
    .when("/newpass/:token", {
      templateUrl: "Pages/newpass.html",
      controller: "",
    })
    .when("/cart", {
      templateUrl: "Pages/cart.html",
      controller: "ShoppingCartController",
    })
    .when("/checkout", {
      templateUrl: "Pages/checkout.html",
      controller: "ShoppingCartController",
      resolve: { auth: requireAuth }, // Require authentication
    })
    .when("/login/:token", {
      templateUrl: "Pages/login.html",
      controller: "VerifyController",
    })
    .when("/profile", {
      templateUrl: "Pages/profile.html",
      controller: "ShoppingCartController",
      resolve: { auth: requireAuth }, // Require authentication
    })
    .otherwise({
      redirectTo: "/home",
    });

  $locationProvider.html5Mode(true); // Enable HTML5 mode
});

// Auth Guard Function
function requireAuth($q, $location) {
  const authToken = localStorage.getItem("authToken");
  if (authToken) {
    return $q.resolve();
  } else {
    $location.path("/login");
    return $q.reject("Not Authenticated");
  }
}

// Inject the dependencies for requireAuth
requireAuth.$inject = ["$q", "$location"];

// Product Service
app.service("ProductService", function () {
  return {
    setProduct: function (product) {
      sessionStorage.setItem("currentProduct", JSON.stringify(product));
    },
    getProduct: function () {
      const product = sessionStorage.getItem("currentProduct");
      return product ? JSON.parse(product) : null;
    },
    clearProduct: function () {
      sessionStorage.removeItem("currentProduct");
    },
    countProductOrders: function () {
      const orderList =
        JSON.parse(localStorage.getItem("lstProductOder")) || [];
      return orderList.filter((order) => order.id).length;
    },
  };
});

// Login Controller
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
            localStorage.setItem("userInfo", JSON.stringify(userInfo));
            $scope.isLoggedIn = true; // Update login status
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

  // Logout function
  $scope.logout = function () {
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
  };
});
