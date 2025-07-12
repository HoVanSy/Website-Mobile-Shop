using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace DAN_FB
{
    public class DonHangDB
    {
        public static int ThemDonHang(string tenKH, DateTime ngayDat, decimal tongTien)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO DonHang (TenKH, NgayDat, TongTien) OUTPUT INSERTED.MaDH VALUES (@tenKH, @ngayDat, @tongTien)", conn);
                cmd.Parameters.AddWithValue("@tenKH", tenKH);
                cmd.Parameters.AddWithValue("@ngayDat", ngayDat);
                cmd.Parameters.AddWithValue("@tongTien", tongTien);
                return (int)cmd.ExecuteScalar(); // Trả về MaDH mới
            }
        }

        public static void ThemChiTiet(int maDH, string tenSP, decimal gia, int soLuong, decimal thanhTien)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO ChiTietDonHang (MaDH, TenSP, Gia, SoLuong, ThanhTien) VALUES (@maDH, @tenSP, @gia, @soLuong, @thanhTien)", conn);
                cmd.Parameters.AddWithValue("@maDH", maDH);
                cmd.Parameters.AddWithValue("@tenSP", tenSP);
                cmd.Parameters.AddWithValue("@gia", gia);
                cmd.Parameters.AddWithValue("@soLuong", soLuong);
                cmd.Parameters.AddWithValue("@thanhTien", thanhTien);
                cmd.ExecuteNonQuery();
            }
        }
    }
}