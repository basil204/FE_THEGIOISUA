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
      resolve: { auth: requireAuth },
    })
    .when("/login/:token", {
      templateUrl: "Pages/login.html",
      controller: "VerifyController",
    })
    .when("/thanhtoan", {
      templateUrl: "Pages/thanhtoan.html",
      controller: "PaymentController",
    })
    .when("/profile", {
      templateUrl: "Pages/profile.html",
      controller: "ShoppingCartController",
      resolve: { auth: requireAuth },
    })
    .otherwise({
      redirectTo: "/home",
    });

  $locationProvider.html5Mode(true);
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
app.controller("PaymentController", function ($scope, $timeout, $location) {
  // Initialize image URL from API
  $scope.paymentImage =
    "https://api.vietqr.io/image/970436-9338739954-3kXSs3C.jpg?accountName=NGUYEN%20LIEN%20MANH&amount=0&addInfo=demo";

  // Redirect to home after 15 seconds
  $timeout(function () {
    $location.path("/home"); // Update path to your homepage URL
  }, 15000); // 15000 milliseconds = 15 seconds
});
