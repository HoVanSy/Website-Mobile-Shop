using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnDangky_Click(object sender, EventArgs e)
        {
            string username = txtTaiKhoan.Text.Trim();
            string password = txtMatKhau.Text.Trim();
            string email = txtemail.Text.Trim();
            string hoten = txthoten.Text.Trim();
            DateTime ngaysinh;
            string sdt = txtsdt.Text.Trim();
            string confirm = txtConfirm.Text.Trim();
            string emailPattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";

            if (!Regex.IsMatch(email, emailPattern))
            {
                lblMessage.Text = "Email không hợp lệ!";
                return;
            }
            if (confirm != password)
            {
                lblMessage.Text = "Mật khẩu không khớp!";
                return;
            }
            bool isValidDate = DateTime.TryParseExact(
                txtngaysinh.Text.Trim(),"dd/MM/yyyy",
                System.Globalization.CultureInfo.InvariantCulture,
                System.Globalization.DateTimeStyles.None,
                out ngaysinh
            );

            if (!isValidDate)
            {
                lblMessage.Text = "Ngày sinh không hợp lệ! (dd/MM/yyyy)";
                return;
            }
            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string checkUserQuery = "SELECT COUNT(*) FROM Users WHERE Username = @username";
                SqlCommand checkUserCmd = new SqlCommand(checkUserQuery, conn);
                checkUserCmd.Parameters.AddWithValue("@Username", username);

                int count = (int)checkUserCmd.ExecuteScalar();
                if (count > 0)
                {
                    lblMessage.Text = "Tài khoản đã tồn tại!";
                    return;
                }
                string insertQuery = "INSERT INTO Users (Username, Password, email, hoten, ngaysinh, sdt, ngay_tao_tk) " +
                    "VALUES (@username, @password, @Email, @Hoten, @Ngaysinh, @Sdt, GETDATE())";
                SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                insertCmd.Parameters.AddWithValue("@username", username);
                insertCmd.Parameters.AddWithValue("@password", password);
                insertCmd.Parameters.AddWithValue("@Email", email);
                insertCmd.Parameters.AddWithValue("@Hoten", hoten);
                insertCmd.Parameters.AddWithValue("@Ngaysinh", ngaysinh); 
                insertCmd.Parameters.AddWithValue("@Sdt", sdt);

                int rows = insertCmd.ExecuteNonQuery();
                if (rows > 0)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "Đăng ký thành công!";
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    lblMessage.Text = "Đăng ký thất bại!";
                }
            }
        }
    }
}