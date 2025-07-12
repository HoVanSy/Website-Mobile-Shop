<%@ Page Title="Đăng nhập" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="DAN_FB.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .main-content {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 16px;
        }

        .login-box {
            background: #e0f7fa; /* Khung nổi bật */
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            padding: 40px 30px;
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            font-weight: 500;
            display: block;
            margin-bottom: 6px;
            color: #444;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            background: #f9fafb;
            transition: all 0.3s ease;
            outline: none;
            display: block;
        }

        .form-control:focus {
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.15);
        }

        .btn-login {
            width: 100%;
            background: linear-gradient(to right, #4facfe, #00f2fe);
            color: white;
            font-weight: bold;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-login:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .message {
            margin-top: 16px;
            padding: 10px;
            border-radius: 6px;
            display: none;
        }

        .message.show {
            display: block;
        }

        .message.error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .login-links {
            text-align: center;
            margin-top: 20px;
        }

        .login-links a {
            color: #4facfe;
            margin: 0 8px;
            text-decoration: none;
            font-size: 14px;
        }

        .login-links a:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-box">
        <h2>Đăng nhập</h2>

        <div class="form-group">
            <label for="txtTaiKhoan">Tài khoản</label>
            <asp:TextBox ID="txtTaiKhoan" runat="server" CssClass="form-control" placeholder="Nhập tên tài khoản"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtMatKhau">Mật khẩu</label>
            <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="form-control" placeholder="Nhập mật khẩu"></asp:TextBox>
        </div>

        <asp:Button ID="BtnDangnhap" runat="server" Text="Đăng nhập" CssClass="btn-login" OnClick="BtnDangnhap_Click" />

        <asp:Label runat="server" ID="lblMessage" CssClass="message error"></asp:Label>

        <div class="login-links">
            <a href="Register.aspx">Tạo tài khoản</a> | 
            <a href="Quenmatkhau.aspx">Quên mật khẩu?</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const errorMsg = document.getElementById('<%= lblMessage.ClientID %>');
            if (errorMsg && errorMsg.textContent.trim() !== '') {
                errorMsg.classList.add('show');
            }
        });
    </script>
</asp:Content>
