using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;

namespace DAN_FB
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            ScriptManager.ScriptResourceMapping.AddDefinition(
                "jquery", // Tên của ScriptResourceMapping (phải là "jquery" và phân biệt chữ hoa chữ thường)
                new ScriptResourceDefinition
                {
                    Path = "~/Scripts/jquery-1.10.2.min.js", // Đường dẫn tới file jQuery của bạn (điều chỉnh phiên bản)
                    DebugPath = "~/Scripts/jquery-1.10.2.js",
                    CdnPath = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.10.2.min.js",
                    CdnDebugPath = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.10.2.js"
                });
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}