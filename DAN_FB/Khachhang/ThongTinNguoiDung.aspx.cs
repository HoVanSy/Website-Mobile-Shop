using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DAN_FB
{
    public partial class ThongTinNguoiDung : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] != null)
                {
                    tk2.Visible = false;
                    lblUsername.Text = Session["Username"].ToString();
                    lblRole.Text = Session["role"]?.ToString();
                    if (Session["role"] != null && Session["role"].ToString().ToLower() == "admin")
                    {
                        adminPanelBtn.Visible = true;
                        adminNotice.Visible = true;
                    }
                    else
                    {
                        adminPanelBtn.Visible = false;
                        adminNotice.Visible = false;
                    }
                }
                else
                {
                    // Nếu chưa đăng nhập...
                    ////string script = "if(confirm('Bạn chưa đăng nhập. Bạn có muốn chuyển đến trang đăng nhập không?')) "
                    ////            + "{ window.location='Login.aspx'; }";
                    //ClientScript.RegisterStartupScript(this.GetType(), "LoginAlert", script, true);
                    txtTTND.Visible = false;
                    tk.Visible = false;
                    tk1.Visible = false;
                    btnLogout.Visible = false;
                    actionSection.Visible = false;
                }
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("WebForm1.aspx");
        }
    }
}