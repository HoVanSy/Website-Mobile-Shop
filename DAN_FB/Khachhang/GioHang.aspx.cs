using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB
{
    public partial class GioHang : System.Web.UI.Page
    {
        #region Hằng số
        private const string TEN_SESSION_MA_GIAM_DA_AP_DUNG = "MaGiamDaApDung";
        private const string TEN_SESSION_TONG_TIEN_CUOI = "TongTienCuoi";
        private const string TEN_SESSION_TEN_DANG_NHAP = "Username";
        #endregion

        #region Thuộc tính
        private DataTable BangGioHang
        {
            get
            {
                if (DataClass.tbGioHang == null)
                {
                    DataClass.TaoBangGioHang();
                }
                return DataClass.tbGioHang;
            }
        }

        private bool GioHangTrong => BangGioHang == null || BangGioHang.Rows.Count == 0;

        private decimal SoTienGiamDaApDung
        {
            get
            {
                if (Session[TEN_SESSION_MA_GIAM_DA_AP_DUNG] != null &&
                    decimal.TryParse(Session[TEN_SESSION_MA_GIAM_DA_AP_DUNG].ToString(), out decimal soTienGiam))
                {
                    return soTienGiam;
                }
                return 0m;
            }
            set
            {
                Session[TEN_SESSION_MA_GIAM_DA_AP_DUNG] = value;
            }
        }
        #endregion

        #region Sự kiện Trang
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KhoiTaoTrang();
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            KiemTraVaLamSachDuLieuGioHang();
            base.OnPreRender(e);
        }
        #endregion

        #region Khởi tạo
        private void KhoiTaoTrang()
        {
            try
            {
                DataClass.TaoBangGioHang();
                TaiDuLieuGioHang();
                TinhVaHienThiTongTien();
            }
            catch (Exception ex)
            {
                GhiLoi("KhoiTaoTrang", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi khởi tạo trang. Vui lòng thử lại!");
            }
        }
        #endregion

        #region Quản lý dữ liệu Giỏ hàng
        private void TaiDuLieuGioHang()
        {
            try
            {
                GridView1.DataSource = BangGioHang;
                GridView1.DataBind();

                CapNhatHienThiGiaoDien();
                CapNhatSoLuongGioHangTrenMasterPage();
            }
            catch (Exception ex)
            {
                GhiLoi("TaiDuLieuGioHang", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi tải dữ liệu giỏ hàng.");
            }
        }

        private void CapNhatHienThiGiaoDien()
        {
            bool gioHangCoHang = !GioHangTrong;

            if (coupon_summary_section != null)
                coupon_summary_section.Visible = gioHangCoHang;

            if (cart_actions != null)
                cart_actions.Visible = gioHangCoHang;

            GridView1.Visible = gioHangCoHang;
        }

        private void CapNhatSoLuongGioHangTrenMasterPage()
        {
            // Triển khai nếu Master Page có chức năng hiển thị số lượng hàng trong giỏ
            // Ví dụ: ((Main)this.Master).CapNhatSoLuongGioHang(LaySoLuongSanPhamTrongGioHang());
        }

        private int LaySoLuongSanPhamTrongGioHang()
        {
            if (GioHangTrong) return 0;

            int tongSoSanPham = 0;
            foreach (DataRow dong in BangGioHang.Rows)
            {
                if (dong.RowState != DataRowState.Deleted &&
                    int.TryParse(dong["SoLuong"]?.ToString(), out int soLuong))
                {
                    tongSoSanPham += soLuong;
                }
            }
            return tongSoSanPham;
        }
        #endregion

        #region Tính toán
        private void TinhVaHienThiTongTien()
        {
            try
            {
                decimal tongPhu = TinhTongPhu();
                decimal soTienGiam = SoTienGiamDaApDung;
                decimal tongTienCuoi = Math.Max(0, tongPhu - soTienGiam);

                Session[TEN_SESSION_TONG_TIEN_CUOI] = tongTienCuoi;

                CapNhatNhanTongTien(tongPhu, soTienGiam, tongTienCuoi);
            }
            catch (Exception ex)
            {
                GhiLoi("TinhVaHienThiTongTien", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi tính tổng tiền.");
            }
        }

        private decimal TinhTongPhu()
        {
            decimal tongPhu = 0m;

            if (GioHangTrong) return tongPhu;

            foreach (DataRow dong in BangGioHang.Rows)
            {
                if (dong.RowState == DataRowState.Deleted) continue;

                if (decimal.TryParse(dong["TongTien"]?.ToString(), out decimal tongTienSanPham))
                {
                    tongPhu += tongTienSanPham;
                }
            }

            return tongPhu;
        }

        private void CapNhatNhanTongTien(decimal tongPhu, decimal soTienGiam, decimal tongTienCuoi)
        {
            string dinhDangTienTe = "{0:N0} VNĐ";

            if (lblSubtotal != null)
                lblSubtotal.Text = string.Format(dinhDangTienTe, tongPhu);

            if (lblDiscount != null)
                lblDiscount.Text = string.Format("-{0:N0} VNĐ", soTienGiam);

            if (lblGrandTotal != null)
                lblGrandTotal.Text = string.Format(dinhDangTienTe, tongTienCuoi);

            if (Tongtien != null)
                Tongtien.Text = string.Format(dinhDangTienTe, tongTienCuoi);
        }
        #endregion

        #region Sự kiện GridView
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int idSanPham = LayIdSanPhamTuGridView(e.RowIndex);
                if (idSanPham > 0)
                {
                    XoaSanPhamKhoiGioHang(idSanPham);
                    HienThiThongBaoThanhCong("Đã xóa sản phẩm khỏi giỏ hàng.");
                }
            }
            catch (Exception ex)
            {
                GhiLoi("GridView1_RowDeleting", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi xóa sản phẩm. Vui lòng thử lại!");
            }
            finally
            {
                LamMoiHienThiGioHang();
            }
        }

        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            try
            {
                GridView1.EditIndex = e.NewEditIndex;
                LamMoiHienThiGioHang();
            }
            catch (Exception ex)
            {
                GhiLoi("GridView1_RowEditing", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi chỉnh sửa sản phẩm.");
            }
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int idSanPham = LayIdSanPhamTuGridView(e.RowIndex);
                int soLuongMoi = LaySoLuongTuDongChinhSua(e.RowIndex);

                if (idSanPham > 0 && soLuongMoi > 0)
                {
                    CapNhatSoLuongSanPham(idSanPham, soLuongMoi);
                    HienThiThongBaoThanhCong("Đã cập nhật số lượng sản phẩm.");
                }
            }
            catch (Exception ex)
            {
                GhiLoi("GridView1_RowUpdating", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi cập nhật số lượng. Vui lòng thử lại!");
            }
            finally
            {
                GridView1.EditIndex = -1;
                LamMoiHienThiGioHang();
            }
        }

        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            LamMoiHienThiGioHang();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName.Contains("Qty"))
                {
                    XuLyLenhSoLuong(e.CommandName, e.CommandArgument.ToString());
                }
            }
            catch (Exception ex)
            {
                GhiLoi("GridView1_RowCommand", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi thay đổi số lượng. Vui lòng thử lại!");
            }
        }
        #endregion

        #region Thao tác Giỏ hàng
        private void XuLyLenhSoLuong(string tenLenh, string idSanPhamStr)
        {
            if (!int.TryParse(idSanPhamStr, out int idSanPham)) return;

            DataRow dongSanPham = TimSanPhamTrongGioHang(idSanPham);
            if (dongSanPham == null) return;

            int soLuongHienTai = LayGiaTriIntAnToan(dongSanPham["SoLuong"], 1);
            int soLuongMoi = soLuongHienTai;

            if (tenLenh.Contains("Decrease") && soLuongMoi > 1)
            {
                soLuongMoi--;
            }
            else if (tenLenh.Contains("Increase"))
            {
                soLuongMoi++;
            }

            CapNhatSoLuongSanPham(idSanPham, soLuongMoi);
            LamMoiHienThiGioHang();
        }

        private void CapNhatSoLuongSanPham(int idSanPham, int soLuongMoi)
        {
            if (soLuongMoi < 1) soLuongMoi = 1;

            DataRow dongSanPham = TimSanPhamTrongGioHang(idSanPham);
            if (dongSanPham == null) return;

            decimal gia = LayGiaTriDecimalAnToan(dongSanPham["Gia"], 0m);

            dongSanPham["SoLuong"] = soLuongMoi;
            dongSanPham["TongTien"] = gia * soLuongMoi;

            BangGioHang.AcceptChanges();
        }

        private void XoaSanPhamKhoiGioHang(int idSanPham)
        {
            DataRow[] cacDongCanXoa = BangGioHang.Select($"idSP = {idSanPham}");
            foreach (DataRow dong in cacDongCanXoa)
            {
                dong.Delete();
            }
            BangGioHang.AcceptChanges();
        }

        private DataRow TimSanPhamTrongGioHang(int idSanPham)
        {
            DataRow[] cacDong = BangGioHang.Select($"idSP = {idSanPham}");
            return cacDong.Length > 0 ? cacDong[0] : null;
        }
        #endregion

        #region Phương thức hỗ trợ
        private int LayIdSanPhamTuGridView(int chiMucDong)
        {
            if (GridView1.DataKeys[chiMucDong]?.Value != null &&
                int.TryParse(GridView1.DataKeys[chiMucDong].Value.ToString(), out int idSanPham))
            {
                return idSanPham;
            }
            return 0;
        }

        private int LaySoLuongTuDongChinhSua(int chiMucDong)
        {
            TextBox txtSoLuongChinhSua = (TextBox)GridView1.Rows[chiMucDong].FindControl("txtEditQuantity");

            if (txtSoLuongChinhSua != null && int.TryParse(txtSoLuongChinhSua.Text, out int soLuong))
            {
                return Math.Max(1, soLuong);
            }
            return 1;
        }

        private int LayGiaTriIntAnToan(object giaTri, int giaTriMacDinh)
        {
            if (giaTri != null && giaTri != DBNull.Value &&
                int.TryParse(giaTri.ToString(), out int ketQua))
            {
                return ketQua;
            }
            return giaTriMacDinh;
        }

        private decimal LayGiaTriDecimalAnToan(object giaTri, decimal giaTriMacDinh)
        {
            if (giaTri != null && giaTri != DBNull.Value &&
                decimal.TryParse(giaTri.ToString(), out decimal ketQua))
            {
                return ketQua;
            }
            return giaTriMacDinh;
        }

        private void LamMoiHienThiGioHang()
        {
            TaiDuLieuGioHang();
            TinhVaHienThiTongTien();
        }
        #endregion

        #region Sự kiện nút
        protected void Button2_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("WebForm1.aspx");
            }
            catch (Exception ex)
            {
                GhiLoi("Button2_Click", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi chuyển trang.");
            }
        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session[TEN_SESSION_TEN_DANG_NHAP] == null)
                {
                    HienThiThongBaoDangNhap();
                    return;
                }

                if (GioHangTrong)
                {
                    HienThiThongBaoLoi("Giỏ hàng của bạn đang trống. Vui lòng thêm sản phẩm để đặt hàng!");
                    return;
                }

                //Session[TEN_SESSION_TONG_TIEN_CUOI] = lblGrandTotal.Text;
                //Session["TongTienCuoi"] = grandTotal;


                Response.Redirect("XacNhanMuaHang.aspx");
            }
            catch (Exception ex)
            {
                GhiLoi("btnDatHang_Click", ex);
                HienThiThongBaoLoi("Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại!");
            }
        }

        private void HienThiThongBaoDangNhap()
        {
            string script = @"
                if(confirm('Bạn chưa đăng nhập. Bạn có muốn chuyển đến trang đăng nhập không?')) {
                    window.location='Login.aspx';
                }";
            ClientScript.RegisterStartupScript(this.GetType(), "CanhBaoDangNhap", script, true);
        }
        #endregion

        #region Quản lý mã khuyến mãi
        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            try
            {
                string maKhuyenMai = txtCouponCode.Text?.Trim();

                if (string.IsNullOrEmpty(maKhuyenMai))
                {
                    HienThiLoiKhuyenMai("Vui lòng nhập mã khuyến mãi.");
                    return;
                }

                var ketQuaKiemTra = KiemTraMaKhuyenMai(maKhuyenMai);

                if (ketQuaKiemTra.HopLe)
                {
                    SoTienGiamDaApDung = ketQuaKiemTra.SoTienGiam;
                    HienThiThongBaoKhuyenMaiThanhCong($"Áp dụng mã khuyến mãi thành công! Bạn được giảm {ketQuaKiemTra.SoTienGiam:N0} VNĐ.");
                }
                else
                {
                    SoTienGiamDaApDung = 0m;
                    HienThiLoiKhuyenMai(ketQuaKiemTra.ThongDiepLoi);
                }

                TinhVaHienThiTongTien();
            }
            catch (Exception ex)
            {
                GhiLoi("btnApplyCoupon_Click", ex);
                HienThiLoiKhuyenMai("Có lỗi xảy ra khi áp dụng mã khuyến mãi.");
            }
        }

        private KetQuaKiemTraMaKhuyenMai KiemTraMaKhuyenMai(string maKhuyenMai)
        {
            // Giả định DataClass có phương thức để lấy dữ liệu khuyến mãi từ DB
            // Ví dụ: DataTable dtKhuyenMai = DataClass.LayDuLieu("SELECT MaKM, GiaTriGiam, TrangThai FROM KhuyenMai WHERE MaKM = '" + maKhuyenMai + "'");
            // Thay thế bằng cách gọi DataClass của bạn để truy vấn database
            DataTable dtKhuyenMai = null;
            try
            {
                string cauLenhSQL = $"SELECT MaKM, TenKM, GiaTriGiam, TrangThai FROM KhuyenMai WHERE MaKM = N'{maKhuyenMai}' AND TrangThai = 1"; // Giả sử TrangThai = 1 là đang hoạt động
                dtKhuyenMai = DataClass.LayDuLieu(cauLenhSQL);
            }
            catch (Exception ex)
            {
                GhiLoi("KiemTraMaKhuyenMai - LayDuLieu", ex);
                return new KetQuaKiemTraMaKhuyenMai { HopLe = false, ThongDiepLoi = "Lỗi khi kiểm tra mã khuyến mãi từ database." };
            }


            if (dtKhuyenMai != null && dtKhuyenMai.Rows.Count > 0)
            {
                DataRow dongKhuyenMai = dtKhuyenMai.Rows[0];
                decimal giaTriGiam = LayGiaTriDecimalAnToan(dongKhuyenMai["GiaTriGiam"], 0m);

                // Bạn có thể thêm các kiểm tra khác ở đây, ví dụ: ngày hết hạn, số lượng sử dụng...
                // int trangThai = LayGiaTriIntAnToan(dongKhuyenMai["TrangThai"], 0);
                // if (trangThai == 0) return new KetQuaKiemTraMaKhuyenMai { HopLe = false, ThongDiepLoi = "Mã khuyến mãi đã hết hạn hoặc không hoạt động." };

                return new KetQuaKiemTraMaKhuyenMai
                {
                    HopLe = true,
                    SoTienGiam = giaTriGiam
                };
            }
            else
            {
                return new KetQuaKiemTraMaKhuyenMai
                {
                    HopLe = false,
                    ThongDiepLoi = "Mã khuyến mãi không hợp lệ hoặc không tồn tại."
                };
            }
        }

        private void HienThiThongBaoKhuyenMaiThanhCong(string thongDiep)
        {
            if (lblCouponMessage != null)
            {
                lblCouponMessage.Text = thongDiep;
                lblCouponMessage.CssClass = "coupon-message success";
            }
        }

        private void HienThiLoiKhuyenMai(string thongDiep)
        {
            if (lblCouponMessage != null)
            {
                lblCouponMessage.Text = thongDiep;
                lblCouponMessage.CssClass = "coupon-message error";
            }
        }
        #endregion

        #region Kiểm tra dữ liệu
        private void KiemTraVaLamSachDuLieuGioHang()
        {
            if (GioHangTrong) return;

            try
            {
                var cacDongCanXoa = new List<DataRow>();

                foreach (DataRow dong in BangGioHang.Rows)
                {
                    if (dong.RowState == DataRowState.Deleted) continue;

                    if (LaDongKhongHopLe(dong))
                    {
                        cacDongCanXoa.Add(dong);
                    }
                    else
                    {
                        LamSachDuLieuDong(dong);
                    }
                }

                // Xóa các dòng không hợp lệ
                foreach (var dong in cacDongCanXoa)
                {
                    dong.Delete();
                }

                if (cacDongCanXoa.Count > 0)
                {
                    BangGioHang.AcceptChanges();
                }
            }
            catch (Exception ex)
            {
                GhiLoi("KiemTraVaLamSachDuLieuGioHang", ex);
            }
        }

        private bool LaDongKhongHopLe(DataRow dong)
        {
            return dong["idSP"] == null || dong["idSP"] == DBNull.Value ||
                   dong["SoLuong"] == null || dong["SoLuong"] == DBNull.Value ||
                   dong["Gia"] == null || dong["Gia"] == DBNull.Value;
        }

        private void LamSachDuLieuDong(DataRow dong)
        {
            // Đảm bảo số lượng ít nhất là 1
            int soLuong = LayGiaTriIntAnToan(dong["SoLuong"], 1);
            if (soLuong < 1) soLuong = 1;
            dong["SoLuong"] = soLuong;

            // Tính lại tổng tiền
            decimal gia = LayGiaTriDecimalAnToan(dong["Gia"], 0m);
            dong["TongTien"] = gia * soLuong;
        }
        #endregion

        #region Xử lý lỗi và Ghi log
        private void GhiLoi(string tenPhuongThuc, Exception ex)
        {
            // Triển khai ghi log chi tiết hơn tại đây
            // Hiện tại chỉ ghi vào cửa sổ Debug
            System.Diagnostics.Debug.WriteLine($"Lỗi trong {tenPhuongThuc}: {ex.Message}");
        }

        private void HienThiThongBaoLoi(string thongDiep)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ThongBaoLoi",
                $"alert('{HttpUtility.JavaScriptStringEncode(thongDiep)}');", true);
        }

        private void HienThiThongBaoThanhCong(string thongDiep)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ThongBaoThanhCong",
                $"alert('{HttpUtility.JavaScriptStringEncode(thongDiep)}');", true);
        }
        #endregion
    }

    #region Lớp hỗ trợ
    public class KetQuaKiemTraMaKhuyenMai
    {
        public bool HopLe { get; set; }
        public decimal SoTienGiam { get; set; }
        public string ThongDiepLoi { get; set; }
    }
    #endregion
}