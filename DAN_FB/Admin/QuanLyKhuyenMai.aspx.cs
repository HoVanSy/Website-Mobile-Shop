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
    public partial class QuanLyKhuyenMai : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPromotions();
            }
        }

        // Load all promotions into GridView
        private void LoadPromotions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            MaKM,
                            TenKM,
                            GiaTriGiam,
                            CASE 
                                WHEN TrangThai = 1 THEN N'Áp dụng'
                                ELSE N'Không áp dụng'
                            END as TrangThai,
                            TrangThai as TrangThaiValue
                        FROM KhuyenMai 
                        ORDER BY MaKM DESC";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvKhuyenMai.DataSource = dt;
                        gvKhuyenMai.DataBind();
                        pnlNoPromotions.Visible = false;
                    }
                    else
                    {
                        gvKhuyenMai.DataSource = null;
                        gvKhuyenMai.DataBind();
                        pnlNoPromotions.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Lỗi khi tải dữ liệu khuyến mãi: " + ex.Message);
            }
        }

        // Search promotions
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            MaKM,
                            TenKM,
                            GiaTriGiam,
                            CASE 
                                WHEN TrangThai = 1 THEN N'Áp dụng'
                                ELSE N'Không áp dụng'
                            END as TrangThai,
                            TrangThai as TrangThaiValue
                        FROM KhuyenMai 
                        WHERE (@SearchTerm = '' OR MaKM LIKE '%' + @SearchTerm + '%' OR TenKM LIKE N'%' + @SearchTerm + '%')
                        ORDER BY MaKM DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SearchTerm", searchTerm);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvKhuyenMai.DataSource = dt;
                        gvKhuyenMai.DataBind();
                        pnlNoPromotions.Visible = false;
                    }
                    else
                    {
                        gvKhuyenMai.DataSource = null;
                        gvKhuyenMai.DataBind();
                        pnlNoPromotions.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Lỗi khi tìm kiếm khuyến mãi: " + ex.Message);
            }
        }

        // Add new promotion button click
        protected void btnAddPromotion_Click(object sender, EventArgs e)
        {
            ClearPromotionForm();
            ShowPromotionModal("", "", "", "1", true);
        }

        // GridView row command (Edit/Delete)
        protected void gvKhuyenMai_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string maKM = e.CommandArgument.ToString();

            if (e.CommandName == "EditPromotion")
            {
                LoadPromotionForEdit(maKM);
            }
            else if (e.CommandName == "DeletePromotion")
            {
                ShowDeleteConfirmModal(maKM);
            }
        }

        // Load promotion data for editing
        private void LoadPromotionForEdit(string maKM)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT MaKM, TenKM, GiaTriGiam, TrangThai FROM KhuyenMai WHERE MaKM = @MaKM";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaKM", maKM);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string tenKM = reader["TenKM"].ToString();
                        string giaTriGiam = reader["GiaTriGiam"].ToString();
                        string trangThai = reader["TrangThai"].ToString();

                        ShowPromotionModal(maKM, tenKM, giaTriGiam, trangThai, false);
                    }
                    else
                    {
                        ShowErrorMessage("Không tìm thấy khuyến mãi để chỉnh sửa.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Lỗi khi tải thông tin khuyến mãi: " + ex.Message);
            }
        }

        // Save promotion (Add or Update)
        protected void btnSavePromotion_Click(object sender, EventArgs e)
        {
            try
            {
                string maKM = txtMaKM.Text.Trim();
                string tenKM = txtTenKM.Text.Trim();
                string giaTriGiamStr = txtGiaTriGiam.Text.Trim();
                string trangThai = ddlTrangThai.SelectedValue;
                string originalMaKM = hfMaKM.Value;

                // Validation
                if (string.IsNullOrEmpty(maKM) || string.IsNullOrEmpty(tenKM) || string.IsNullOrEmpty(giaTriGiamStr))
                {
                    ShowErrorMessage("Vui lòng nhập đầy đủ thông tin bắt buộc.");
                    return;
                }

                if (!decimal.TryParse(giaTriGiamStr, out decimal giaTriGiam))
                {
                    ShowErrorMessage("Giá trị giảm phải là một số hợp lệ.");
                    return;
                }

                if (giaTriGiam < 0)
                {
                    ShowErrorMessage("Giá trị giảm phải từ 0 đến 100%.");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    if (string.IsNullOrEmpty(originalMaKM)) // Add new
                    {
                        // Check if MaKM already exists
                        string checkQuery = "SELECT COUNT(*) FROM KhuyenMai WHERE MaKM = @MaKM";
                        SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                        checkCmd.Parameters.AddWithValue("@MaKM", maKM);
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count > 0)
                        {
                            ShowErrorMessage("Mã khuyến mãi đã tồn tại. Vui lòng chọn mã khác.");
                            return;
                        }

                        // Insert new promotion
                        string insertQuery = @"
                            INSERT INTO KhuyenMai (MaKM, TenKM, GiaTriGiam, TrangThai) 
                            VALUES (@MaKM, @TenKM, @GiaTriGiam, @TrangThai)";

                        SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                        insertCmd.Parameters.AddWithValue("@MaKM", maKM);
                        insertCmd.Parameters.AddWithValue("@TenKM", tenKM);
                        insertCmd.Parameters.AddWithValue("@GiaTriGiam", giaTriGiam);
                        insertCmd.Parameters.AddWithValue("@TrangThai", Convert.ToInt32(trangThai));

                        int result = insertCmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            ShowSuccessMessage("Thêm khuyến mãi thành công!");
                            ClearPromotionForm();
                            LoadPromotions();
                            HidePromotionModal();
                        }
                        else
                        {
                            ShowErrorMessage("Không thể thêm khuyến mãi. Vui lòng thử lại.");
                        }
                    }
                    else // Update existing
                    {
                        // Check if new MaKM already exists (if changed)
                        if (maKM != originalMaKM)
                        {
                            string checkQuery = "SELECT COUNT(*) FROM KhuyenMai WHERE MaKM = @MaKM";
                            SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                            checkCmd.Parameters.AddWithValue("@MaKM", maKM);
                            int count = (int)checkCmd.ExecuteScalar();

                            if (count > 0)
                            {
                                ShowErrorMessage("Mã khuyến mãi đã tồn tại. Vui lòng chọn mã khác.");
                                return;
                            }
                        }

                        // Update promotion
                        string updateQuery = @"
                            UPDATE KhuyenMai 
                            SET TenKM = @TenKM, GiaTriGiam = @GiaTriGiam, TrangThai = @TrangThai 
                            WHERE MaKM = @OriginalMaKM";

                        SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                        updateCmd.Parameters.AddWithValue("@TenKM", tenKM);
                        updateCmd.Parameters.AddWithValue("@GiaTriGiam", giaTriGiam);
                        updateCmd.Parameters.AddWithValue("@TrangThai", Convert.ToInt32(trangThai));
                        updateCmd.Parameters.AddWithValue("@OriginalMaKM", originalMaKM);

                        int result = updateCmd.ExecuteNonQuery();

                        if (result > 0)
                        {
                            ShowSuccessMessage("Cập nhật khuyến mãi thành công!");
                            ClearPromotionForm();
                            LoadPromotions();
                            HidePromotionModal();
                        }
                        else
                        {
                            ShowErrorMessage("Không thể cập nhật khuyến mãi. Vui lòng thử lại.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Lỗi khi lưu khuyến mãi: " + ex.Message);
            }
        }

        // Confirm delete promotion
        protected void btnConfirmDeletePromotion_Click(object sender, EventArgs e)
        {
            string maKM = hfDeleteMaKM.Value;

            if (string.IsNullOrEmpty(maKM))
            {
                ShowErrorMessage("Không xác định được khuyến mãi cần xóa.");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if promotion is being used in any orders
                    string checkQuery = @"
                        SELECT COUNT(*) FROM HoaDon WHERE MaKM = @MaKM
                        UNION ALL
                        SELECT COUNT(*) FROM ChiTietHoaDon WHERE MaKM = @MaKM";

                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@MaKM", maKM);

                    conn.Open();
                    SqlDataReader reader = checkCmd.ExecuteReader();
                    bool isUsed = false;

                    while (reader.Read())
                    {
                        if (reader.GetInt32(0) > 0)
                        {
                            isUsed = true;
                            break;
                        }
                    }
                    reader.Close();

                    if (isUsed)
                    {
                        ShowErrorMessage("Không thể xóa khuyến mãi này vì đã được sử dụng trong các đơn hàng.");
                        HideDeleteConfirmModal();
                        return;
                    }

                    // Delete promotion
                    string deleteQuery = "DELETE FROM KhuyenMai WHERE MaKM = @MaKM";
                    SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn);
                    deleteCmd.Parameters.AddWithValue("@MaKM", maKM);

                    int result = deleteCmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        ShowSuccessMessage("Xóa khuyến mãi thành công!");
                        LoadPromotions();
                        HideDeleteConfirmModal();
                    }
                    else
                    {
                        ShowErrorMessage("Không thể xóa khuyến mãi. Vui lòng thử lại.");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Lỗi khi xóa khuyến mãi: " + ex.Message);
            }
        }

        // GridView pagination
        protected void gvKhuyenMai_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvKhuyenMai.PageIndex = e.NewPageIndex;

            // Check if search is active
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                btnSearch_Click(sender, e);
            }
            else
            {
                LoadPromotions();
            }
        }

        // Helper methods
        private void ClearPromotionForm()
        {
            txtMaKM.Text = "";
            txtTenKM.Text = "";
            txtGiaTriGiam.Text = "";
            ddlTrangThai.SelectedValue = "1";
            hfMaKM.Value = "";
        }

        private void ShowPromotionModal(string maKM, string tenKM, string giaTriGiam, string trangThai, bool isNew)
        {
            txtMaKM.Text = maKM;
            txtTenKM.Text = tenKM;
            txtGiaTriGiam.Text = giaTriGiam;
            ddlTrangThai.SelectedValue = trangThai;
            hfMaKM.Value = isNew ? "" : maKM;

            string script = $@"
                setTimeout(function() {{
                    showPromotionModal('{maKM}', '{tenKM}', '{giaTriGiam}', '{trangThai}', '{isNew.ToString().ToLower()}');
                }}, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "ShowPromotionModal", script, true);
        }

        private void HidePromotionModal()
        {
            string script = @"
                setTimeout(function() {
                    hidePromotionModal();
                }, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "HidePromotionModal", script, true);
        }

        private void ShowDeleteConfirmModal(string maKM)
        {
            hfDeleteMaKM.Value = maKM;

            string script = $@"
                setTimeout(function() {{
                    showDeleteConfirmModalPromotion('{maKM}');
                }}, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "ShowDeleteConfirmModal", script, true);
        }

        private void HideDeleteConfirmModal()
        {
            string script = @"
                setTimeout(function() {
                    hideDeleteConfirmModalPromotion();
                }, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "HideDeleteConfirmModal", script, true);
        }

        private void ShowSuccessMessage(string message)
        {
            string script = $@"
                setTimeout(function() {{
                    alert('{message}');
                }}, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", script, true);
        }

        private void ShowErrorMessage(string message)
        {
            string script = $@"
                setTimeout(function() {{
                    alert('{message}');
                }}, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "ErrorMessage", script, true);
        }
    }
}