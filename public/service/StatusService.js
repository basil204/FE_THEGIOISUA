app.service('StatusService', function () {
    // Bản đồ trạng thái
    const statusMap = {
        0: "Không hoạt động",
        1: "Hoạt động",
        336: "Huỷ Đơn",
        913: "Hoàn thành",
        901: "Chờ lấy hàng",
        903: "Đã lấy hàng",
        904: "Giao hàng",
        301: "Chờ Duyệt Đơn",
        337: "Chưa Thanh Toán",
        338: "Đơn Chờ",
        305: "Thanh toán thành công",
    };

    // Hàm lấy trạng thái từ mã trạng thái
    this.getStatus = function (statusCode) {
        return statusMap[statusCode] || "Không xác định";
    };
});
