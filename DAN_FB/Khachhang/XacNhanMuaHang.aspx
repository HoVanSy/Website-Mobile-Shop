<%@ Page Title="Xác nhận & Đặt hàng" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="XacNhanMuaHang.aspx.cs" Inherits="DAN_FB.XacNhanMuaHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Be Vietnam Pro', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
            line-height: 1.6;
        }

        .order-confirmation-container {
            max-width: 800px;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            border: 1px solid #e9ecef;
        }

        .page-title {
            color: #212529;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 700;
            font-size: 28px;
        }

        .section-title {
            color: #0056b3;
            margin-top: 25px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f1f3f5;
            font-weight: 600;
            font-size: 18px;
        }

        .error-summary-box {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        .error-summary-box ul {
            margin: 0;
            padding-left: 20px;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
        }

        .input-field {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            box-sizing: border-box;
        }

        .input-field:invalid {
            border-color: #dc3545;
        }

        .input-field:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 4px rgba(0, 123, 255, 0.15);
            outline: none;
        }

        .order-details-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            overflow: hidden;
        }
        .order-details-grid th, .order-details-grid td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .order-details-grid tr:last-child td {
            border-bottom: none;
        }
        .order-details-grid th {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
            font-size: 14px;
        }
        .order-details-grid td {
            font-size: 15px;
        }

        .order-summary {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f1f3f5;
            text-align: right;
            font-size: 22px;
            font-weight: 700;
            color: #28a745;
        }
        .order-summary-label {
            font-weight: 500;
            color: #343a40;
            margin-right: 15px;
        }

        .btn-confirm {
            display: block;
            width: 100%;
            margin-top: 30px;
            padding: 16px 25px;
            background: linear-gradient(90deg, #28a745, #218838);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
        }
        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="order-confirmation-container">
        <h2 class="page-title">Xác Nhận & Đặt Hàng</h2>

        <asp:Literal ID="litErrorMessages" runat="server" EnableViewState="false"></asp:Literal>

        <h4 class="section-title">1. Thông tin giao hàng</h4>

        <div class="form-group">
            <label for="<%= txtHoTen.ClientID %>">Họ và tên</label>
            <asp:TextBox ID="txtHoTen" runat="server" CssClass="input-field" placeholder="Ví dụ: Nguyễn Văn An" required="required"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="<%= txtSdt.ClientID %>">Số điện thoại</label>
            <asp:TextBox ID="txtSdt" runat="server" CssClass="input-field" TextMode="SingleLine" placeholder="Ví dụ: 0912345678"
                         required="required" pattern="0\d{9}" title="Số điện thoại gồm 10 chữ số, bắt đầu bằng 0."></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="<%= txtDiaChi.ClientID %>">Địa chỉ nhận hàng chi tiết</label>
            <asp:TextBox ID="txtDiaChi" runat="server" CssClass="input-field" TextMode="MultiLine" Rows="3"
                         placeholder="Ghi rõ số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố" required="required"></asp:TextBox>
        </div>

        <h4 class="section-title">2. Phương thức thanh toán</h4>
        <div class="form-group">
            <asp:RadioButtonList ID="rblPhuongThucThanhToan" runat="server" RepeatLayout="Flow" CssClass="radio-list-style">
                <asp:ListItem Value="COD" Selected="True">Thanh toán khi nhận hàng (COD)</asp:ListItem>
            </asp:RadioButtonList>
        </div>

        <h4 class="section-title">3. Kiểm tra lại đơn hàng</h4>
        <asp:GridView ID="GridViewXacNhan" runat="server" AutoGenerateColumns="False" CssClass="order-details-grid" GridLines="None">
            <Columns>
                <asp:BoundField DataField="TenSP" HeaderText="Sản phẩm" />
                <asp:BoundField DataField="Gia" HeaderText="Đơn giá" DataFormatString="{0:N0}đ" ItemStyle-Width="120px" />
                <asp:BoundField DataField="SoLuong" HeaderText="Số lượng" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="TongTien" HeaderText="Thành tiền" DataFormatString="{0:N0}đ" ItemStyle-Width="140px" ItemStyle-HorizontalAlign="Right" />
            </Columns>
        </asp:GridView>

        <div class="order-summary">
            <span class="order-summary-label">Tổng thanh toán:</span>
            <asp:Label ID="lblTongTien" runat="server" Text="0đ" />
        </div>

        <asp:Button ID="btnDatHang" runat="server" Text="Hoàn Tất Đặt Hàng" CssClass="btn-confirm" OnClick="btnDatHang_Click" />
    </div>
</asp:Content>
