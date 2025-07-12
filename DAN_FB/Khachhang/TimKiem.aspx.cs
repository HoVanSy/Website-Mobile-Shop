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
    public partial class TimKiem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string keyword = Request.QueryString["keyword"];
                string loai = Request.QueryString["loai"];

                if (!string.IsNullOrEmpty(keyword))
                {
                    LoadSearchResults(keyword);
                    lblSearchInfo.Text = $"Kết quả tìm kiếm cho: \"{keyword}\"";
                }
                else if (!string.IsNullOrEmpty(loai))
                {
                    LoadProductsByCategory(loai);
                }
                else
                {
                    LoadAllProducts();
                    lblSearchInfo.Text = "Tất cả sản phẩm";
                }
            }
        }

        private void LoadSearchResults(string keyword)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM SanPham WHERE TenSP LIKE @keyword";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    dtlSanPham.DataSource = reader;
                    dtlSanPham.DataBind();
                    dtlSanPham.Visible = true;
                    pnlNoResults.Visible = false;
                }
                else
                {
                    dtlSanPham.Visible = false;
                    pnlNoResults.Visible = true;
                }
            }
        }

        private void LoadProductsByCategory(string maLoai)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT sp.*, l.TenLoai 
                              FROM SanPham sp 
                              INNER JOIN LoaiSanPham l ON sp.MaLoai = l.MaLoai 
                              WHERE sp.MaLoai = @MaLoai";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaLoai", maLoai);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    // Lấy tên loại từ record đầu tiên
                    if (reader.Read())
                    {
                        string tenLoai = reader["TenLoai"].ToString();
                        lblSearchInfo.Text = $"Sản phẩm thuộc loại: {tenLoai}";

                        // Reset reader về đầu
                        reader.Close();
                        reader = cmd.ExecuteReader();
                    }

                    dtlSanPham.DataSource = reader;
                    dtlSanPham.DataBind();
                    dtlSanPham.Visible = true;
                    pnlNoResults.Visible = false;
                }
                else
                {
                    dtlSanPham.Visible = false;
                    pnlNoResults.Visible = true;
                    lblSearchInfo.Text = "Không tìm thấy sản phẩm nào";
                }
            }
        }

        private void LoadAllProducts()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM SanPham";
                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                dtlSanPham.DataSource = reader;
                dtlSanPham.DataBind();
            }
        }
    }
}