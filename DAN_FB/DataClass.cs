using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace DAN_FB
{
    public static class DataClass
    {

        public static DataTable tbGioHang = new DataTable();

        public static SqlConnection conn;
        private static void OpenDB()
        {
            string conStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            conn = new SqlConnection(conStr);
            conn.Open();
        }

        public static SqlDataReader GetRecord(string sql)
        {
            OpenDB();
            SqlDataReader r = null;
            try
            {
                SqlCommand cmd = new SqlCommand(sql, conn)
                {
                    CommandType = CommandType.Text
                };
                r = cmd.ExecuteReader();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                CloseDB();
            }
            return r;
        }
        private static void CloseDB()
        {
            if (conn.State == ConnectionState.Open)
                conn.Close();
        }
        public static DataTable LayDuLieu(string sql)
        {
            OpenDB();
            SqlDataAdapter adapter = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            try
            {
                adapter.Fill(dt);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                CloseDB();
            }
            return dt;
        }
        public static DataTable TaoBangGioHang()
        {
            DataTable tb = new DataTable();
            tb.Columns.Add("idSP", typeof(int));
            tb.Columns.Add("TenSP", typeof(string));
            tb.Columns.Add("Gia", typeof(decimal));
            tb.Columns.Add("SoLuong", typeof(int));
            tb.Columns.Add("TongTien", typeof(decimal));
            return tb;
        }

    }
}