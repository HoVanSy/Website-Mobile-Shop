using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void BtnDangnhap_Click(object sender, EventArgs e)
        {
            string username = txtTaiKhoan.Text.Trim();
            string password = txtMatKhau.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM Users WHERE Username = @user AND Password = @pass";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@user", username);
                cmd.Parameters.AddWithValue("@pass", password);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    Session["Username"] = reader["Username"].ToString();
                    Session["role"] = reader["Role"].ToString(); 
                    if (Session["role"]?.ToString() == "admin")
                    {
                        Response.Redirect("~/Admin/BangDieuKhien.aspx");
                    } else
                    {
                        Response.Redirect("WebForm1.aspx");
                    }       
                }
                else
                {
                    lblMessage.Text = "Tài khoản hoặc mật khẩu sai.";
                }
                reader.Close();
                conn.Close();
            }
        }



        protected void TextBox2_TextChanged(object sender, EventArgs e)
        {

        }
    }
}