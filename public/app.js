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
      controller: "",
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
    .when("/profile", {
      templateUrl: "Pages/profile.html",
      controller: "ShoppingCartController",
    })
    .otherwise({
      redirectTo: "/home",
    });
  $locationProvider.html5Mode(true); // Bật html5 mode
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
});

// Controller for handling product details
