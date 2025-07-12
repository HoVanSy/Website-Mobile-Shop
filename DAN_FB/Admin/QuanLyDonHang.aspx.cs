using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB.Admin
{
    public partial class QuanLyDonHang : System.Web.UI.Page
    {
        // Connection string (get from Web.config)
        private string connectionString = WebConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindOrders();
            }
        }

        private void BindOrders()
        {
            DataTable dt = new DataTable();
            string query = "SELECT MaDH, TenKH, NgayDat, TongTien, SDT, DiaChi, PTThanhToan FROM DonHang WHERE 1=1"; // Base query

            // Add search/filter conditions
            string searchKeyword = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchKeyword))
            {
                query += " AND (TenKH LIKE @SearchKeyword OR MaDH LIKE @SearchKeyword OR SDT LIKE @SearchKeyword)";
            }

            string statusFilter = ddlStatus.SelectedValue;
            // IMPORTANT: You need a 'TrangThai' (Status) column in your DonHang table for this to work.
            // If you don't have it, remove or adjust this part.
            // For demonstration, let's assume 'TrangThai' exists.
            // if (!string.IsNullOrEmpty(statusFilter))
            // {
            //     query += " AND TrangThai = @StatusFilter";
            // }

            DateTime dateFrom;
            DateTime dateTo;
            if (DateTime.TryParse(txtDateFrom.Text, out dateFrom))
            {
                query += " AND NgayDat >= @DateFrom";
            }
            if (DateTime.TryParse(txtDateTo.Text, out dateTo))
            {
                query += " AND NgayDat <= @DateTo";
            }

            query += " ORDER BY NgayDat DESC"; // Order by date, newest first

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(searchKeyword))
                    {
                        cmd.Parameters.AddWithValue("@SearchKeyword", "%" + searchKeyword + "%");
                    }
                    // if (!string.IsNullOrEmpty(statusFilter))
                    // {
                    //     cmd.Parameters.AddWithValue("@StatusFilter", statusFilter);
                    // }
                    if (DateTime.TryParse(txtDateFrom.Text, out dateFrom))
                    {
                        cmd.Parameters.AddWithValue("@DateFrom", dateFrom);
                    }
                    if (DateTime.TryParse(txtDateTo.Text, out dateTo))
                    {
                        // Set the time to end of day for accurate filtering
                        cmd.Parameters.AddWithValue("@DateTo", dateTo.AddDays(1).AddSeconds(-1));
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    try
                    {
                        con.Open();
                        da.Fill(dt);
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (e.g., to ELMAH, or a file)
                        // Display a user-friendly error message
                        Response.Write("<script>alert('Lỗi tải dữ liệu đơn hàng: " + ex.Message + "');</script>");
                    }
                }
            }

            gvOrders.DataSource = dt;
            gvOrders.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvOrders.PageIndex = 0; // Reset page index when searching
            BindOrders();
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvOrders.PageIndex = 0; // Reset page index when filtering by status
            BindOrders();
        }

        protected void btnFilterDate_Click(object sender, EventArgs e)
        {
            gvOrders.PageIndex = 0; // Reset page index when filtering by date
            BindOrders();
        }


        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            BindOrders(); // Re-bind data for the new page
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string orderId = e.CommandArgument.ToString();

            switch (e.CommandName)
            {
                case "ViewDetails":
                    // Redirect to a page that shows detailed information about the order
                    Response.Redirect($"ChiTietDonHang.aspx?MaDH={orderId}");
                    break;
                case "EditOrder":
                    // Redirect to an edit page, or open a modal for editing
                    Response.Redirect($"SuaDonHang.aspx?MaDH={orderId}");
                    break;
                case "DeleteOrder":
                    DeleteOrder(orderId);
                    BindOrders(); // Re-bind grid after deletion
                    break;
            }
        }

        private void DeleteOrder(string orderId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // First, delete related order details
                string deleteDetailsQuery = "DELETE FROM ChiTietDonHang WHERE MaDH = @MaDH";
                // Then, delete the order itself
                string deleteOrderQuery = "DELETE FROM DonHang WHERE MaDH = @MaDH";

                SqlTransaction transaction = null;
                try
                {
                    con.Open();
                    transaction = con.BeginTransaction();

                    using (SqlCommand cmdDetails = new SqlCommand(deleteDetailsQuery, con, transaction))
                    {
                        cmdDetails.Parameters.AddWithValue("@MaDH", orderId);
                        cmdDetails.ExecuteNonQuery();
                    }

                    using (SqlCommand cmdOrder = new SqlCommand(deleteOrderQuery, con, transaction))
                    {
                        cmdOrder.Parameters.AddWithValue("@MaDH", orderId);
                        int rowsAffected = cmdOrder.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            transaction.Commit();
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đơn hàng đã được xóa thành công!');", true);
                        }
                        else
                        {
                            transaction.Rollback();
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Không tìm thấy đơn hàng để xóa.');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    if (transaction != null)
                    {
                        transaction.Rollback();
                    }
                    // Log the exception
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Lỗi xóa đơn hàng: " + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        // Uncomment if you need an "Add New Order" button
        // protected void btnAddOrder_Click(object sender, EventArgs e)
        // {
        //     Response.Redirect("ThemDonHangMoi.aspx"); // Or navigate to a form for adding new orders
        // }
    }
}