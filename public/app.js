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

