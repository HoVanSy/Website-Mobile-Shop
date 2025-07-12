<%@ Page Title="Đăng ký" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="DAN_FB.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .main-content {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 16px;
        }

        .register-box {
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

        .btn-register {
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

        .btn-register:hover {
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

        .message.success {
            background: #dcfce7;
            color: #166534;
        }

        .register-links {
            text-align: center;
            margin-top: 20px;
        }

        .register-links a {
            color: #4facfe;
            margin: 0 8px;
            text-decoration: none;
            font-size: 14px;
        }

        .register-links a:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-box">
        <h2>Đăng ký tài khoản</h2>

        <div class="form-group">
            <label for="txtTaiKhoan">Tài khoản</label>
            <asp:TextBox ID="txtTaiKhoan" runat="server" CssClass="form-control" placeholder="Nhập tên đăng nhập"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtemail">Email</label>
            <asp:TextBox ID="txtemail" runat="server" CssClass="form-control" placeholder="Nhập email"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txthoten">Họ tên</label>
            <asp:TextBox ID="txthoten" runat="server" CssClass="form-control" placeholder="Nhập họ tên"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtngaysinh">Ngày Sinh</label>
            <asp:TextBox ID="txtngaysinh" runat="server" placeholder="dd/MM/yyyy" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label for="txtsdt">SDT</label>
            <asp:TextBox ID="txtsdt" runat="server" CssClass="form-control" placeholder="Nhập số điện thoại"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtMatKhau">Mật khẩu</label>
            <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="form-control" placeholder="Nhập mật khẩu"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtConfirm">Nhập lại mật khẩu</label>
            <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" CssClass="form-control" placeholder="Xác nhận mật khẩu"></asp:TextBox>
        </div>

        <asp:Button ID="btnDangky" runat="server" Text="Tạo tài khoản" CssClass="btn-register" OnClick="btnDangky_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="message error"></asp:Label>

        <div class="register-links">
            <a href="Login.aspx">Đã có tài khoản?</a> | <a href="Quenmatkhau.aspx">Quên mật khẩu?</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const message = document.getElementById('<%= lblMessage.ClientID %>');
            if (message && message.textContent.trim() !== '') {
                message.classList.add('show');
            }
        });
    </script>
</asp:Content>
