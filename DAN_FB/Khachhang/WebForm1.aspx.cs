using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                LoadSanPham();
            }
        }
        void LoadSanPham()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = "SELECT * FROM SanPham";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Kiểm tra xem DataTable có dữ liệu không
                if (dt.Rows.Count > 0)
                {
                    dtlSanPham.DataSource = dt;
                    dtlSanPham.DataBind();
                }
                else
                {
                    // Nếu không có dữ liệu, xử lý theo ý muốn
                    Response.Write("Không có sản phẩm nào.");
                }
            }
        }
        protected void ListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedMaLoai = ListBox1.SelectedValue;

            string connectionString = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            string query = "SELECT * FROM SanPham WHERE MaLoai = @MaLoai";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaLoai", selectedMaLoai);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dtlSanPham.DataSource = dt;
                dtlSanPham.DataBind();
            }
        }
        protected void BtnXemngay_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewSP.aspx");
        }

    }
}