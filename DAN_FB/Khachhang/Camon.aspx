<%@ Page Title="" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="Camon.aspx.cs" Inherits="DAN_FB.Camon" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            padding-top: 100px;
        }
        .thank-you-box {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            display: inline-block;
        }
        h1 {
            color: #27ae60;
        }
        p {
            font-size: 18px;
            color: #555;
        }
        .back-home {
            margin-top: 20px;
            display: inline-block;
            background-color: #3498db;
            color: #fff;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
        }
        .back-home:hover {
            background-color: #2980b9;
        }
    </style>
    <div class="thank-you-box">
        <h1>🎉 Cảm ơn bạn đã đặt hàng!</h1>
        <p>Chúng tôi đã nhận được đơn hàng của bạn và sẽ xử lý trong thời gian sớm nhất.</p>
        <a href="Webform1.aspx" class="back-home">Quay về trang chủ</a>
    </div>
    <h1 id="lblDSdamua" runat="server"> Những người đã mua hôm nay:</h1>
        <asp:GridView ID="gvDanhSachMuaHang" runat="server" AutoGenerateColumns="False" 
                      CellPadding="4" ForeColor="#333333" GridLines="None" 
                      Width="100%" AllowPaging="True">
            <Columns>
                <asp:BoundField DataField="MaDH" HeaderText="Mã Đơn Hàng" SortExpression="MaDH" />
                <asp:BoundField DataField="TenKH" HeaderText="Tên Khách Hàng" SortExpression="TenKH" />
                <asp:BoundField DataField="NgayDat" HeaderText="Ngày Đặt" SortExpression="NgayDat" 
                                DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="TongTien" HeaderText="Tổng Tiền" SortExpression="TongTien" 
                                DataFormatString="{0:#,0 VND}" />
            </Columns>
        </asp:GridView>
</asp:Content>
