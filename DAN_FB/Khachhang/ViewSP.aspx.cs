using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace DAN_FB
{
    public partial class ViewSP : System.Web.UI.Page
    {
        int SP_ID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    LoadProductDetail(id);
                }
            }
        }

        private void LoadProductDetail(string id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT MaSP, TenSP, Gia, HinhAnh FROM SanPham WHERE MaSP = @MaSP";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", id);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    Label4.Text = reader["MaSP"].ToString();
                    Label1.Text = reader["TenSP"].ToString();
                    Label3.Text = string.Format("{0:N0}", Convert.ToDecimal(reader["Gia"]));
                    Image1.ImageUrl = reader["HinhAnh"].ToString();
                }
                conn.Close();
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["Username"] == null) 
            {
                string script = "if(confirm('Bạn chưa đăng nhập. Bạn có muốn chuyển đến trang đăng nhập không?')) "
                                + "{ window.location='Login.aspx'; }";
                ClientScript.RegisterStartupScript(this.GetType(), "LoginAlert", script, true);
            } else
            {
                SP_ID = Convert.ToInt32(Label4.Text);
                int SL = Convert.ToInt32(txtSL.Text);
                if (SL <= 0) SL = 1;

                string strTenSP = Label1.Text;
                string dongia = Label3.Text.Replace(" ", "").Replace(",", "");
                decimal Gia = decimal.Parse(dongia);
                decimal TongTien = Gia * SL;

                // Tạo giỏ hàng nếu chưa có
                if (Session["GioHang"] == null)
                {
                    DataClass.tbGioHang = DataClass.TaoBangGioHang();
                }
                else
                {
                    DataClass.tbGioHang = Session["GioHang"] as DataTable;
                }

                bool Daco = false;
                foreach (DataRow row in DataClass.tbGioHang.Rows)
                {
                    if ((int)row["idSP"] == SP_ID)
                    {
                        row["SoLuong"] = (int)row["SoLuong"] + SL;
                        //row["TongTien"] = (decimal)row["SoLuong"] * (decimal)row["Gia"];
                        row["TongTien"] = Convert.ToInt32(row["SoLuong"]) * Convert.ToDecimal(row["Gia"]);
                        Daco = true;
                        break;
                    }
                }

                if (!Daco)
                {
                    DataClass.tbGioHang.Rows.Add(SP_ID, strTenSP, Gia, SL, TongTien);
                }

                Session["GioHang"] = DataClass.tbGioHang;
            }

        }

        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            // TODO: xử lý mua ngay
            if (Session["Username"] == null) 
            {
                string script = "if(confirm('Bạn chưa đăng nhập. Bạn có muốn chuyển đến trang đăng nhập không?')) "
                                + "{ window.location='Login.aspx'; }";
                ClientScript.RegisterStartupScript(this.GetType(), "LoginAlert", script, true);
            } else
            {
                if (DataClass.tbGioHang == null || DataClass.tbGioHang.Rows.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "alert('Bạn chưa thêm sản phẩm nào vào giỏ hàng!');", true);

                }
                else
                {
                    // Có sản phẩm trong giỏ
                    Response.Redirect("XacNhanMuaHang.aspx");
                }
            }
        }
    }
}
