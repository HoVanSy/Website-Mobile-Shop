using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace DAN_FB
{
    public partial class XacNhanMuaHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["GioHang"] != null)
                {
                    GridViewXacNhan.DataSource = (DataTable)Session["GioHang"];
                    GridViewXacNhan.DataBind();
                    TinhTongTien();
                }
            }
        }

        private void TinhTongTien()
        {
            //int tong = 0;
            //DataTable dt = (DataTable)Session["GioHang"];
            //foreach (DataRow row in dt.Rows)
            //{
            //    tong += Convert.ToInt32(row["TongTien"]);
            //}
            //lblTongTien.Text = tong.ToString("N0") + "đ";

            lblTongTien.Text = Session["TongTienCuoi"]?.ToString() ?? "0đ";

        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction tran = conn.BeginTransaction();

                try
                {
                    // 1. Insert vào DonHang
                    string insertDonHang = @"INSERT INTO DonHang (TenKH, SDT, DiaChi, PTThanhToan, NgayDat, TongTien) 
                                             OUTPUT INSERTED.MaDH
                                             VALUES (@TenKH, @SDT, @DiaChi, @PTThanhToan, @NgayDat, @TongTien)";
                    SqlCommand cmd1 = new SqlCommand(insertDonHang, conn, tran);
                    cmd1.Parameters.AddWithValue("@TenKH", txtHoTen.Text.Trim());
                    cmd1.Parameters.AddWithValue("@SDT", txtSdt.Text.Trim());
                    cmd1.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                    cmd1.Parameters.AddWithValue("@PTThanhToan", rblPhuongThucThanhToan.SelectedValue);
                    cmd1.Parameters.AddWithValue("@NgayDat", DateTime.Now);

                    int tongTien = int.Parse(lblTongTien.Text.Replace("đ", "").Replace(".", "").Replace(",", "").Trim());
                    cmd1.Parameters.AddWithValue("@TongTien", tongTien);

                    int maDH = (int)cmd1.ExecuteScalar();

                    // 2. Insert từng dòng ChiTietDonHang
                    DataTable gioHang = (DataTable)Session["GioHang"];
                    foreach (DataRow row in gioHang.Rows)
                    {
                        string insertChiTiet = @"INSERT INTO ChiTietDonHang (MaDH, TenSP, Gia, SoLuong, ThanhTien)
                                                 VALUES (@MaDH, @TenSP, @Gia, @SoLuong, @ThanhTien)";
                        SqlCommand cmd2 = new SqlCommand(insertChiTiet, conn, tran);
                        cmd2.Parameters.AddWithValue("@MaDH", maDH);
                        cmd2.Parameters.AddWithValue("@TenSP", row["TenSP"]);
                        cmd2.Parameters.AddWithValue("@Gia", row["Gia"]);
                        cmd2.Parameters.AddWithValue("@SoLuong", row["SoLuong"]);
                        cmd2.Parameters.AddWithValue("@ThanhTien", row["TongTien"]);
                        cmd2.ExecuteNonQuery();
                    }

                    tran.Commit();
                    Session["GioHang"] = null;
                    Response.Write("<script>alert('Đặt hàng thành công!'); window.location='Camon.aspx';</script>");
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    litErrorMessages.Text = $"<div class='error-summary-box'><ul><li>{ex.Message}</li></ul></div>";
                }
            }
        }
    }
}
