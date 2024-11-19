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
  $httpProvider.interceptors.push("AuthInterceptor");
});

// Auth Guard Function
// Auth Guard Function with redirect
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

// Inject the dependencies for requireAuth
requireAuth.$inject = ["$q", "$location", "$route"];

// HTTP Interceptor for Authorization
app.factory("AuthInterceptor", function ($q, $window) {
  return {
    request: function (config) {
      const token = $window.localStorage.getItem("authToken");
      const protectedUrls = [
        "http://160.30.21.47:1234/api/Invoice/add",
        "http://160.30.21.47:1234/api/Userinvoice/add",
        "http://160.30.21.47:1234/api/Invoicedetail/add",
        "http://160.30.21.47:1234/api/payment/transactionHistory",
        "http://160.30.21.47:1234/api/Voucher/voucercode",
        "http://160.30.21.47:1234/api/Invoice/getInvoices/",
        "http://160.30.21.47:1234/api/Invoicedetail/getInvoiceDetailByUser/",
        "http://160.30.21.47:1234/api/Invoice/cancel/",
      ];

      if (token && protectedUrls.some((url) => config.url.includes(url))) {
        config.headers["Authorization"] = "Bearer " + token;
      }
      return config;
    },
  };
});
// app
//   .factory("httpInterceptor", function ($q) {
//     return {
//       request: function (config) {
//         console.log("Request:", config);
//         return config;
//       },
//       response: function (response) {
//         console.log("Response:", response);
//         return response;
//       },
//       responseError: function (rejection) {
//         console.error("Response Error:", rejection);
//         return $q.reject(rejection);
//       },
//     };
//   })
//   .config(function ($httpProvider) {
//     $httpProvider.interceptors.push("httpInterceptor");
//   });
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
