using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB.Admin
{
    public partial class QuanLyDienThoai : System.Web.UI.Page
    {
        private string ConnectionString = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLoaiSanPham(); // Load product categories for the dropdown
                LoadProducts();    // Load products into the GridView
            }
        }

        // --- Phương thức tải dữ liệu loại sản phẩm lên DropDownList ---
        private void LoadLoaiSanPham()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                string query = "SELECT MaLoai, TenLoai FROM LoaiSanPham ORDER BY TenLoai";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        ddlMaLoai.DataSource = reader;
                        ddlMaLoai.DataValueField = "MaLoai";
                        ddlMaLoai.DataTextField = "TenLoai";
                        ddlMaLoai.DataBind();
                        reader.Close();

                        // Thêm một item mặc định (tùy chọn)
                        ddlMaLoai.Items.Insert(0, new ListItem("-- Chọn loại sản phẩm --", ""));
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"SQL Error in LoadLoaiSanPham: {ex.ToString()}");
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"General Error in LoadLoaiSanPham: {ex.ToString()}");
                    }
                }
            }
        }

        // --- Phương thức tải dữ liệu sản phẩm lên GridView ---
        private void LoadProducts(string searchTerm = "")
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                // Join with LoaiSanPham to get TenLoai
                string query = "SELECT sp.MaSP, sp.TenSP, sp.Gia, sp.HinhAnh, sp.MaLoai, lsp.TenLoai " +
                               "FROM SanPham sp JOIN LoaiSanPham lsp ON sp.MaLoai = lsp.MaLoai";

                // Thêm điều kiện tìm kiếm nếu có
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " WHERE sp.TenSP LIKE @SearchTerm OR lsp.TenLoai LIKE @SearchTerm"; // Search by TenSP or TenLoai
                }
                query += " ORDER BY sp.MaSP DESC"; // Sắp xếp để sản phẩm mới nhất lên đầu

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    }

                    try
                    {
                        conn.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvProducts.DataSource = dt;
                        gvProducts.DataBind();
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"SQL Error in LoadProducts: {ex.ToString()}");
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"General Error in LoadProducts: {ex.ToString()}");
                    }
                }
            }
        }

        // --- Xử lý sự kiện tìm kiếm sản phẩm ---
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts(txtSearch.Text.Trim());
        }

        // --- Xử lý sự kiện phân trang GridView ---
        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            LoadProducts(txtSearch.Text.Trim()); // Tải lại dữ liệu với trang mới và giữ nguyên từ khóa tìm kiếm
        }

        // --- Xử lý các lệnh từ GridView (Sửa, Xóa) ---
        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                int maSP = Convert.ToInt32(e.CommandArgument);
                EditProduct(maSP);
            }
            else if (e.CommandName == "DeleteProduct")
            {
                int maSP = Convert.ToInt32(e.CommandArgument);
                // Lưu MaSP vào HiddenField và hiển thị modal xác nhận xóa
                hfDeleteMaSP.Value = maSP.ToString();
                // Gọi JavaScript để hiển thị modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowDeleteModal", "showDeleteConfirmModal('" + maSP + "');", true);
            }
        }

        // --- Phương thức tải dữ liệu sản phẩm để chỉnh sửa ---
        private void EditProduct(int maSP)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                string query = "SELECT MaSP, TenSP, Gia, HinhAnh, MaLoai FROM SanPham WHERE MaSP = @MaSP";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MaSP", maSP);
                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            // Đổ dữ liệu vào các TextBox và DropDownList trong modal
                            hfMaSP.Value = reader["MaSP"].ToString();
                            txtTenSP.Text = reader["TenSP"].ToString();
                            txtGia.Text = reader["Gia"].ToString();
                            txtHinhAnh.Text = reader["HinhAnh"].ToString();

                            // Chọn giá trị đúng trong DropDownList
                            ddlMaLoai.SelectedValue = reader["MaLoai"].ToString();

                            // Gọi JavaScript để hiển thị modal và điền dữ liệu
                            // Đảm bảo các giá trị chuỗi được escape đúng cách cho JavaScript
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowEditModal",
                                $"showProductModal('{hfMaSP.Value}', '{txtTenSP.Text.Replace("'", "\\'")}', '{ddlMaLoai.SelectedValue}', '{txtGia.Text}', '{txtHinhAnh.Text.Replace("'", "\\'")}');", true);
                        }
                        reader.Close();
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"SQL Error in EditProduct: {ex.ToString()}");
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"General Error in EditProduct: {ex.ToString()}");
                    }
                }
            }
        }

        // --- Xử lý sự kiện click nút "Thêm mới" sản phẩm ---
        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            // Reset form fields and show modal for adding new product
            hfMaSP.Value = ""; // Đặt MaSP rỗng để biết là thêm mới
            txtTenSP.Text = "";
            txtGia.Text = "";
            txtHinhAnh.Text = "";
            ddlMaLoai.SelectedIndex = 0; // Reset dropdown to default "-- Chọn loại sản phẩm --"

            // Gọi JavaScript để hiển thị modal
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowAddModal", "showProductModal('', '', '', '', '');", true);
        }

        // --- Xử lý sự kiện click nút "Lưu" (Thêm/Chỉnh sửa) sản phẩm ---
        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            string tenSP = txtTenSP.Text.Trim();
            decimal gia;
            string hinhAnh = txtHinhAnh.Text.Trim();
            int maLoai;

            // Validate inputs
            if (!decimal.TryParse(txtGia.Text.Trim(), out gia))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "InvalidInput", "alert('Giá không hợp lệ.');", true);
                return;
            }
            if (!int.TryParse(ddlMaLoai.SelectedValue, out maLoai))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "InvalidInput", "alert('Vui lòng chọn loại sản phẩm.');", true);
                return;
            }
            if (string.IsNullOrEmpty(tenSP))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "InvalidInput", "alert('Tên sản phẩm không được để trống.');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                if (string.IsNullOrEmpty(hfMaSP.Value)) // Thêm mới
                {
                    cmd.CommandText = "INSERT INTO SanPham (TenSP, Gia, HinhAnh, MaLoai) VALUES (@TenSP, @Gia, @HinhAnh, @MaLoai)";
                }
                else // Chỉnh sửa
                {
                    cmd.CommandText = "UPDATE SanPham SET TenSP = @TenSP, Gia = @Gia, HinhAnh = @HinhAnh, MaLoai = @MaLoai WHERE MaSP = @MaSP";
                    cmd.Parameters.AddWithValue("@MaSP", Convert.ToInt32(hfMaSP.Value));
                }

                cmd.Parameters.AddWithValue("@TenSP", tenSP);
                cmd.Parameters.AddWithValue("@Gia", gia);
                cmd.Parameters.AddWithValue("@HinhAnh", hinhAnh);
                cmd.Parameters.AddWithValue("@MaLoai", maLoai);

                try
                {
                    cmd.ExecuteNonQuery();
                    LoadProducts(txtSearch.Text.Trim()); // Tải lại dữ liệu sau khi lưu
                    // Ẩn modal sau khi lưu thành công
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "HideProductModal", "document.getElementById('productModal').style.display='none';", true);
                }
                catch (SqlException ex)
                {
                    System.Diagnostics.Debug.WriteLine($"SQL Error in SaveProduct: {ex.ToString()}");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SaveError", "alert('Lỗi khi lưu sản phẩm: " + ex.Message.Replace("'", "\\'") + "');", true);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"General Error in SaveProduct: {ex.ToString()}");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SaveError", "alert('Đã xảy ra lỗi: " + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        // --- Xử lý sự kiện click nút "Xóa" trong modal xác nhận ---
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfDeleteMaSP.Value))
            {
                int maSP = Convert.ToInt32(hfDeleteMaSP.Value);
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    string query = "DELETE FROM SanPham WHERE MaSP = @MaSP";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaSP", maSP);
                        try
                        {
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            LoadProducts(txtSearch.Text.Trim()); // Tải lại dữ liệu sau khi xóa
                            // Ẩn modal xác nhận xóa
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideDeleteModal", "document.getElementById('deleteConfirmModal').style.display='none';", true);
                        }
                        catch (SqlException ex)
                        {
                            System.Diagnostics.Debug.WriteLine($"SQL Error in DeleteProduct: {ex.ToString()}");
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "DeleteError", "alert('Lỗi khi xóa sản phẩm: " + ex.Message.Replace("'", "\\'") + "');", true);
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Debug.WriteLine($"General Error in DeleteProduct: {ex.ToString()}");
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "DeleteError", "alert('Đã xảy ra lỗi: " + ex.Message.Replace("'", "\\'") + "');", true);
                        }
                    }
                }
            }
        }

        // --- Xử lý sự kiện đăng xuất (giữ nguyên từ trang Dashboard) ---
        protected void confirmLogoutLinkBtn_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            // FormsAuthentication.SignOut(); // Bỏ comment nếu bạn dùng FormsAuthentication
            Response.Redirect("Login.aspx"); // Thay thế bằng trang đăng nhập của bạn
        }
    }
}