app.service('SwalService', function () {
    this.showTerms = function () {
        return Swal.fire({
            title: "Điều Khoản và Điều Kiện",
            html: `
          <h6>Điều Khoản 1: Cung Cấp Thông Tin Chính Xác</h6>
          <p>
            Người dùng cam kết cung cấp thông tin đầy đủ và chính xác bao gồm họ tên, địa chỉ nhận hàng, số điện thoại và thông tin thanh toán. 
            Nếu thông tin không chính xác hoặc không đầy đủ, hệ thống có quyền từ chối xử lý đơn hàng.
          </p>
  
          <h6>Điều Khoản 2: Thanh Toán Và Xác Nhận</h6>
          <p>
            Hóa đơn sẽ chỉ được tạo sau khi người dùng hoàn tất thanh toán qua phương thức đã chọn. 
            Trong trường hợp thanh toán thất bại, đơn hàng sẽ không được xử lý và hệ thống sẽ thông báo qua email hoặc số điện thoại cung cấp.
          </p>
  
          <h6>Điều Khoản 3: Thời Gian Hiệu Lực Của Hóa Đơn</h6>
          <p>
            Hóa đơn có hiệu lực trong vòng 24 giờ kể từ khi được tạo. Sau thời gian này, nếu không có khiếu nại từ phía người dùng, hóa đơn sẽ được xem là hợp lệ và không thể chỉnh sửa hoặc hủy bỏ.
          </p>
  
          <h6>Điều Khoản 4: Trách Nhiệm Kiểm Tra Thông Tin</h6>
          <p>
            Người dùng chịu trách nhiệm kiểm tra thông tin đơn hàng, bao gồm sản phẩm, số lượng và tổng tiền trước khi xác nhận. 
            Hệ thống sẽ không chịu trách nhiệm đối với sai sót do người dùng nhập sai thông tin.
          </p>
  
          <label>
            <input type="checkbox" id="termsCheckbox">
            Tôi đã đọc và đồng ý với các Điều Khoản liên quan đến việc tạo và xử lý hóa đơn.
          </label>
        `,
            icon: "info",
            showCancelButton: true,
            confirmButtonText: "Chấp Nhận",
            cancelButtonText: "Đóng",
            preConfirm: function () {
                if (!document.getElementById("termsCheckbox").checked) {
                    Swal.showValidationMessage("Vui lòng đồng ý với điều khoản");
                    return false;
                }
                return true;
            },
        }).then(function (result) {
            return result.isConfirmed;
        });
    };
});
