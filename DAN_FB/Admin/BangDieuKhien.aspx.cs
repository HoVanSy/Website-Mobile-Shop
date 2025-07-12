using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB.Admin
{
    public partial class BangDieuKhien : System.Web.UI.Page
    {
        private string ConnectionString = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Chỉ tải dữ liệu khi trang được tải lần đầu (không phải postback)
            {
                // Gọi hàm để tải dữ liệu thống kê từ database
                TaiDuLieuThongKeDashboard();
                // Tải hoạt động gần đây nếu cần (có thể là một phương thức riêng)
                // TaiHoatDongGanDay();
            }

            // Bạn có thể thêm logic kiểm tra quyền truy cập ở đây
            // Ví dụ: if (!User.Identity.IsAuthenticated) Response.Redirect("Login.aspx");
        }
        private void TaiDuLieuThongKeDashboard()
        {
            try
            {
                // Lấy tổng số sản phẩm từ bảng SanPham
                int tongSanPham = GetCountFromDatabase("SELECT COUNT(*) FROM SanPham");
                lblTongSanPham.Text = tongSanPham.ToString();

                // Lấy tổng số đơn hàng từ bảng DonHang
                int tongDonHang = GetCountFromDatabase("SELECT COUNT(*) FROM DonHang");
                lblTongDonHang.Text = tongDonHang.ToString();

                // Lấy tổng số khách hàng từ bảng Users (giả sử cột Role phân biệt khách hàng)
                // Nếu UserID đại diện cho khách hàng, thì COUNT(*) FROM Users là đủ.
                // Nếu cần lọc Role (ví dụ chỉ đếm Role = 'User' hoặc 'Customer'), bạn có thể thêm WHERE:
                // int tongKhachHang = GetCountFromDatabase("SELECT COUNT(*) FROM Users WHERE Role = N'Customer'");
                int tongKhachHang = GetCountFromDatabase("SELECT COUNT(*) FROM Users");
                lblTongKhachHang.Text = tongKhachHang.ToString();

                // Lấy tổng doanh thu từ bảng DonHang
                // Giả định TongTien là tổng số tiền của đơn hàng đã hoàn thành
                decimal tongDoanhThu = GetSumFromDatabase("SELECT SUM(TongTien) FROM DonHang");
                // Định dạng tiền tệ VNĐ: Ví dụ 125.000.000 VNĐ
                lblTongDoanhThu.Text = string.Format("{0:N0} đ", tongDoanhThu);
            }
            catch (Exception ex)
            {
                // Xử lý lỗi khi không thể tải dữ liệu
                // Ghi log lỗi để debug trong môi trường phát triển
                System.Diagnostics.Debug.WriteLine("Lỗi khi tải dữ liệu thống kê: " + ex.Message);
                // Hiển thị lỗi trên giao diện (chỉ nên làm trong môi trường phát triển hoặc với thông báo thân thiện)
                // Response.Write("<script>alert('Lỗi khi tải dữ liệu thống kê: " + ex.Message.Replace("'", "\\'") + "');</script>");

                // Để lại giá trị mặc định "0" hoặc "0 VNĐ" hoặc hiển thị "Lỗi"
                lblTongSanPham.Text = "Lỗi";
                lblTongDonHang.Text = "Lỗi";
                lblTongKhachHang.Text = "Lỗi";
                lblTongDoanhThu.Text = "Lỗi";
            }
        }

        // --- HÀM HỖ TRỢ CHUNG ĐỂ LẤY SỐ LƯỢNG (COUNT) TỪ DATABASE ---
        private int GetCountFromDatabase(string query)
        {
            int count = 0;
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != DBNull.Value && result != null)
                        {
                            count = Convert.ToInt32(result);
                        }
                    }
                    catch (SqlException ex)
                    {
                        // Ghi log lỗi SQL chi tiết hơn
                        System.Diagnostics.Debug.WriteLine($"SQL Error in GetCountFromDatabase ({query}): {ex.Message}");
                        throw; // Ném lại lỗi để TaiDuLieuThongKeDashboard xử lý
                    }
                    catch (Exception ex)
                    {
                        // Ghi log các lỗi khác
                        System.Diagnostics.Debug.WriteLine($"General Error in GetCountFromDatabase ({query}): {ex.Message}");
                        throw;
                    }
                }
            }
            return count;
        }

        // --- HÀM HỖ TRỢ CHUNG ĐỂ LẤY TỔNG (SUM) TỪ DATABASE ---
        private decimal GetSumFromDatabase(string query)
        {
            decimal sum = 0M;
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != DBNull.Value && result != null)
                        {
                            sum = Convert.ToDecimal(result);
                        }
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"SQL Error in GetSumFromDatabase ({query}): {ex.Message}");
                        throw;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"General Error in GetSumFromDatabase ({query}): {ex.Message}");
                        throw;
                    }
                }
            }
            return sum;
        }
        protected void confirmLogoutLinkBtn_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("~/Khachhang/WebForm1.aspx");
        }
    }
}