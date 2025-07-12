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
    public partial class Camon : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] != null && Session["role"].ToString() == "admin")
            {
                LoadDanhSachMuaHang();
            } else
            {
                lblDSdamua.Visible = false;
                gvDanhSachMuaHang.Visible = false;
            }
        }
        private void LoadDanhSachMuaHang()
        {
            List<DonHang> danhSachDonHang = new List<DonHang>();

            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT MaDH, TenKH, NgayDat, TongTien FROM DonHang WHERE CAST(NgayDat AS DATE) = CAST(GETDATE() AS DATE)";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    DonHang donHang = new DonHang()
                    {
                        MaDH = reader["MaDH"].ToString(),
                        TenKH = reader["TenKH"].ToString(),
                        NgayDat = Convert.ToDateTime(reader["NgayDat"]),
                        TongTien = Convert.ToDecimal(reader["TongTien"])
                    };
                    danhSachDonHang.Add(donHang);
                }
                reader.Close();
            }

            // Gắn dữ liệu vào GridView
            gvDanhSachMuaHang.DataSource = danhSachDonHang;
            gvDanhSachMuaHang.DataBind();
        }

        public class DonHang
        {
            public string MaDH { get; set; }
            public string TenKH { get; set; }
            public DateTime NgayDat { get; set; }
            public decimal TongTien { get; set; }
        }
    }
}