app.controller("LogController", function ($scope, $http, socket) {
    const token = localStorage.getItem("authToken");
    $scope.systemLogs = [];
    $scope.page = {
        size: 10, // Số lượng bản ghi mỗi trang
        number: 0, // Trang hiện tại (bắt đầu từ 0)
        totalElements: 0,
        totalPages: 0
    };

    // Function to fetch logs
    $scope.getLogs = function (pageNumber = 0) {
        const url = `http://160.30.21.47:1234/api/Log/getlog?page=${pageNumber}&size=${$scope.page.size}`;

        $http.get(url, {
            headers: { 'Authorization': `Bearer ${token}` }
        }).then(function (response) {
            const data = response.data;
            console.log("System logs:", data);
            $scope.systemLogs = data.content;
            $scope.page = data.page; // Cập nhật thông tin phân trang
        }).catch(function (error) {
            console.error("Error fetching logs:", error);
        });
    };

    // Function to change page
    $scope.changePage = function (newPage) {
        if (newPage >= 0 && newPage < $scope.page.totalPages) {
            $scope.getLogs(newPage); // Gọi lại hàm getLogs với trang mới
        }
    };

    // Load first page on initialization
    $scope.getLogs(0); // Khởi tạo với trang đầu tiên
});
// Compare this snippet from public/controller/OrderController.js: