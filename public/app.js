var app = angular.module("myApp", ["ngRoute"]);

// Configure routes
app.config(function ($routeProvider, $locationProvider, $httpProvider) {
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
      controller: "ForgotController",
    })
    .when("/newpass/:token", {
      templateUrl: "Pages/newpass.html",
      controller: "NewpassController",
    })
    .when("/cart", {
      templateUrl: "Pages/cart.html",
      controller: "ShoppingCartController",
    })
    .when("/invoicedetail/:invoiceCode", {
      templateUrl: "Pages/detail.html",
      controller: "InvoiceDetailController",
    })
    .when("/checkout", {
      templateUrl: "Pages/checkout.html",
      controller: "ShoppingCartController",
      // resolve: { auth: requireAuth }, // Require authentication
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
  $httpProvider.interceptors.push("AuthInterceptor");
})
function requireAuth($q, $location, $route) {
  const authToken = localStorage.getItem("authToken");
  if (authToken) {
    return $q.resolve();
  } else {
    // Save the path user tried to access
    localStorage.setItem("redirectAfterLogin", $location.path());
    $location.path("/login");
    return $q.reject("Not Authenticated");
  }
}
app.config(function ($httpProvider) {
  $httpProvider.interceptors.push('loadingInterceptor');
});

// Inject the dependencies for requireAuth
requireAuth.$inject = ["$q", "$location", "$route"];

// HTTP Interceptor for Authorization
app.factory("AuthInterceptor", function ($q, $window) {
  return {
    request: function (config) {
      const token = $window.localStorage.getItem("authToken");
      const protectedUrls = [
        "http://160.30.21.47:1234/api/Invoice/getInvoices/",
        "http://160.30.21.47:1234/api/Invoicedetail/getInvoiceDetailByUser/",
        "http://160.30.21.47:1234/api/Invoice/cancel/",
        "http://160.30.21.47:1234/api/user/profile/",
        "http://160.30.21.47:1234/api/user/updatePhonerNumber",
        "http://160.30.21.47:1234/api/user/updateFullName",
        "http://160.30.21.47:1234/api/user/updateAddress",
        "http://160.30.21.47:1234/api/Invoice/getInvoice/",
        "http://160.30.21.47:1234/api/Invoice/getInvoicespage/",
      ];

      if (token && protectedUrls.some((url) => config.url.includes(url))) {
        config.headers["Authorization"] = "Bearer " + token;
      }
      return config;
    },
  };
});

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
})
app.factory('loadingInterceptor', function ($q, $rootScope) {
  let activeRequests = 0;

  function setLoadingStatus(isLoading) {
    $rootScope.isLoading = isLoading; // Thay đổi trạng thái toàn cục
  }

  return {
    request: function (config) {
      activeRequests++;
      setLoadingStatus(true);
      return config;
    },
    response: function (response) {
      activeRequests--;
      if (activeRequests === 0) {
        setLoadingStatus(false);
      }
      return response;
    },
    responseError: function (rejection) {
      activeRequests--;
      if (activeRequests === 0) {
        setLoadingStatus(false);
      }
      return $q.reject(rejection);
    }
  };
});
app.run(function ($rootScope, $http, $location) {
  let socket = null;
  let stompClient = null;
  let isConnected = false;
  const Toast = Swal.mixin({
    toast: true,
    position: "top-right",
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true,
  });
  // Kết nối WebSocket tự động khi ứng dụng được khởi tạo
  function connectWebSocket() {
    if (isConnected) {
      return; // Nếu đã kết nối rồi thì không cần kết nối lại
    }

    const token = localStorage.getItem("authToken"); // Lấy token từ localStorage
    const socketUrl = `http://160.30.21.47:1234/api/ws?token=${encodeURIComponent(token)}`;

    socket = new SockJS(socketUrl); // Tạo kết nối SockJS
    stompClient = Stomp.over(socket); // Tạo đối tượng Stomp client

    stompClient.connect({}, function (frame) {
      isConnected = true;
      console.log("WebSocket connected: " + frame);

      // Đăng ký các subscriptions tại đây
      stompClient.subscribe("/topic/messages", function (message) {
        console.log("Received message: ", message.body);
        // Xử lý thông điệp ở đây (ví dụ: hiển thị Toast)
        Toast.fire({
          icon: 'info',
          title: `Hóa đơn #${message.body} đã được đặt!`
        });
      });

    }, function (error) {
      console.error("Error: " + error);
    });

    // Gắn stompClient vào $rootScope để sử dụng ở các controller khác
    $rootScope.stompClient = stompClient;
  }

  // Ngắt kết nối WebSocket
  function disconnectWebSocket() {
    if (stompClient) {
      stompClient.disconnect();
      isConnected = false;
      console.log("WebSocket disconnected");
    }
  }

  // Kết nối WebSocket khi ứng dụng được khởi tạo
  connectWebSocket();

  // Đảm bảo ngắt kết nối WebSocket khi ứng dụng bị hủy
  $rootScope.$on('$destroy', function () {
    disconnectWebSocket();
  });
});


