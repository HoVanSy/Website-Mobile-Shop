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
    public partial class QuanLyKhachHang : System.Web.UI.Page
    {
        private string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGridView();
                BindRoles(); // Tải danh sách vai trò cho modal
            }
        }

        #region Data Binding Helpers

        private void BindGridView(string searchTerm = "")
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                // ĐIỀU CHỈNH: Bỏ JOIN với bảng Roles, lấy trực tiếp cột 'Role' từ bảng Users.
                string query = @"SELECT UserID, hoten, Username, email, sdt, ngay_tao_tk, ngaysinh, Role
                                 FROM Users";

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " WHERE hoten LIKE @searchTerm OR Username LIKE @searchTerm OR email LIKE @searchTerm OR sdt LIKE @searchTerm";
                }

                query += " ORDER BY UserID DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        cmd.Parameters.AddWithValue("@searchTerm", "%" + searchTerm + "%");
                    }

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        // Đổi tên cột 'Role' thành 'RoleName' trong DataTable để GridView không bị lỗi
                        // nếu bạn vẫn giữ DataField="RoleName" trong ASPX.
                        // Hoặc bạn có thể đổi DataField trong ASPX thành "Role".
                        // Ở đây, tôi sẽ đổi tên cột trong code cho an toàn.
                        if (dt.Columns.Contains("Role"))
                        {
                            dt.Columns["Role"].ColumnName = "RoleName";
                        }

                        if (dt.Rows.Count > 0)
                        {
                            gvKhachHang.DataSource = dt;
                            gvKhachHang.DataBind();
                            gvKhachHang.Visible = true;
                            pnlNoCustomers.Visible = false;
                        }
                        else
                        {
                            gvKhachHang.Visible = false;
                            pnlNoCustomers.Visible = true;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Tải danh sách vai trò vào DropDownList trong modal.
        /// </summary>
        private void BindRoles()
        {
            // ĐIỀU CHỈNH: Vì không có bảng Roles riêng, chúng ta sẽ tạo danh sách vai trò cố định.
            ddlRole.Items.Clear();
            ddlRole.Items.Add(new ListItem("Admin", "Admin"));
            ddlRole.Items.Add(new ListItem("Khách hàng", "Khách hàng"));
            // Thêm các vai trò khác nếu có
        }
        #endregion

        #region GridView Events

        protected void gvKhachHang_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvKhachHang.PageIndex = e.NewPageIndex;
            BindGridView(txtSearch.Text.Trim());
        }

        protected void gvKhachHang_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCustomer")
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    // ĐIỀU CHỈNH: Lấy cột 'Role' thay vì 'RoleID'
                    string query = "SELECT UserID, hoten, Username, email, sdt, ngaysinh, Role FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string hoTen = reader["hoten"].ToString();
                                string username = reader["Username"].ToString();
                                string email = reader["email"].ToString();
                                string sdt = reader["sdt"].ToString();
                                string ngaySinh = reader["ngaysinh"] != DBNull.Value ? Convert.ToDateTime(reader["ngaysinh"]).ToString("yyyy-MM-dd") : "";
                                // ĐIỀU CHỈNH: Lấy giá trị chuỗi của vai trò
                                string role = reader["Role"].ToString();

                                // ĐIỀU CHỈNH: Truyền chuỗi 'role' vào hàm JavaScript
                                string script = $"showCustomerModal('{userID}', '{hoTen}', '{username}', '{email}', '{sdt}', '{ngaySinh}', '{role}', 'false');";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "EditModal", script, true);
                            }
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteCustomer")
            {
                hfDeleteUserID.Value = userID.ToString();
                string script = $"showDeleteConfirmModalCustomer('{userID}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "DeleteConfirmModal", script, true);
            }
        }

        #endregion

        #region Toolbar Button Events

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvKhachHang.PageIndex = 0;
            BindGridView(txtSearch.Text.Trim());
        }

        protected void btnAddCustomer_Click(object sender, EventArgs e)
        {
            // ĐIỀU CHỈNH: Truyền giá trị mặc định cho vai trò là "Khách hàng"
            string script = "showCustomerModal('0', '', '', '', '', '', 'Khách hàng', 'true');";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "AddModal", script, true);
        }

        #endregion

        #region Modal Button Events

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(hfUserID.Value);
            string hoTen = txtHoTen.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string sdt = txtSDT.Text.Trim();
            DateTime? ngaySinh = string.IsNullOrEmpty(txtNgaySinh.Text) ? (DateTime?)null : DateTime.Parse(txtNgaySinh.Text);
            // ĐIỀU CHỈNH: Lấy vai trò là một chuỗi từ DropDownList
            string role = ddlRole.SelectedValue;

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                SqlCommand cmd;
                if (userID == 0) // Thêm mới
                {
                    // ĐIỀU CHỈNH: Thêm vào cột 'Role' thay vì 'RoleID'
                    string query = @"INSERT INTO Users (hoten, Username, email, password, sdt, ngaysinh, Role, ngay_tao_tk) 
                                     VALUES (@hoten, @Username, @email, @password, @sdt, @ngaysinh, @Role, GETDATE())";
                    cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@password", password);
                }
                else // Cập nhật
                {
                    string query;
                    if (!string.IsNullOrEmpty(password))
                    {
                        // ĐIỀU CHỈNH: Cập nhật cột 'Role'
                        query = @"UPDATE Users SET hoten=@hoten, email=@email, sdt=@sdt, ngaysinh=@ngaysinh, Role=@Role, password=@password 
                                  WHERE UserID=@UserID";
                        cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@password", password);
                    }
                    else
                    {
                        // ĐIỀU CHỈNH: Cập nhật cột 'Role'
                        query = @"UPDATE Users SET hoten=@hoten, email=@email, sdt=@sdt, ngaysinh=@ngaysinh, Role=@Role
                                  WHERE UserID=@UserID";
                        cmd = new SqlCommand(query, con);
                    }
                    cmd.Parameters.AddWithValue("@UserID", userID);
                }

                cmd.Parameters.AddWithValue("@hoten", hoTen);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@sdt", string.IsNullOrEmpty(sdt) ? (object)DBNull.Value : sdt);
                cmd.Parameters.AddWithValue("@ngaysinh", ngaySinh.HasValue ? (object)ngaySinh.Value : DBNull.Value);
                // ĐIỀU CHỈNH: Thêm tham số @Role
                cmd.Parameters.AddWithValue("@Role", role);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            BindGridView();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "hideCustomerModal();", true);
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            int userID = Convert.ToInt32(hfDeleteUserID.Value);
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "DELETE FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindGridView();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideDeleteModal", "hideDeleteConfirmModalCustomer();", true);
        }

        #endregion
    }
}