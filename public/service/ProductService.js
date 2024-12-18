app.service("ProductService", function ($http) {
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
