<%@ Page Title="Quản lý Đơn hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="QuanLyDonHang.aspx.cs" Inherits="DAN_FB.Admin.QuanLyDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Quản lý Đơn hàng
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    
    <title>Quản Lý Đơn Hàng - Hệ Thống Quản Lý</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="content-block">
            <%-- Page Header --%>
            <div class="page-header">
                <h2>Quản lý Đơn hàng</h2>
            </div>

            <%-- Search Panel --%>
            <%-- Search Panel --%>
            <div class="search-panel">
                <div class="row">
                    <%-- Phần tìm kiếm theo text và trạng thái --%>
                    <div class="col-md-6">
                        <div class="search-group">
                            <label>Tìm kiếm</label>
                            <div class="input-group">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Tìm kiếm đơn hàng..."></asp:TextBox>
                                <div class="input-group-append">
                                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary" OnClick="btnSearch_Click">
                                        <i class="fas fa-search"></i> Tìm
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="search-group">
                            <label>Trạng thái</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                                <asp:ListItem Text="Tất cả" Value=""></asp:ListItem>
                                <asp:ListItem Text="Đang chờ xử lý" Value="Pending"></asp:ListItem>
                                <asp:ListItem Text="Đã xác nhận" Value="Confirmed"></asp:ListItem>
                                <asp:ListItem Text="Đang giao hàng" Value="Shipping"></asp:ListItem>
                                <asp:ListItem Text="Đã giao hàng" Value="Delivered"></asp:ListItem>
                                <asp:ListItem Text="Đã hủy" Value="Cancelled"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                    <%-- Phần lọc ngày xuống hàng khác --%>
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="search-group">
                                    <label>Từ ngày</label>
                                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="search-group">
                                    <label>Đến ngày</label>
                                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 date-filter-button"> <%-- Thêm class "date-filter-button" vào đây --%>
                                <asp:LinkButton ID="btnFilterDate" runat="server" CssClass="btn btn-secondary w-100" OnClick="btnFilterDate_Click">
                                    <i class="fas fa-filter"></i> Lọc
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- GridView container --%>
            <div class="gridview-container">
                <asp:GridView ID="gvOrders" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table"
                    AllowPaging="True"
                    PageSize="10"
                    OnPageIndexChanging="gvOrders_PageIndexChanging"
                    OnRowCommand="gvOrders_RowCommand"
                    DataKeyNames="MaDH">
                    <Columns>
                        <asp:BoundField DataField="MaDH" HeaderText="Mã ĐH" SortExpression="MaDH" />
                        <asp:BoundField DataField="TenKH" HeaderText="Khách Hàng" SortExpression="TenKH" />
                        <asp:BoundField DataField="NgayDat" HeaderText="Ngày Đặt" DataFormatString="{0:dd/MM/yyyy}" SortExpression="NgayDat" />
                        <asp:BoundField DataField="TongTien" HeaderText="Tổng Tiền" DataFormatString="{0:N0} VNĐ" SortExpression="TongTien" />
                        <asp:BoundField DataField="SDT" HeaderText="SĐT" SortExpression="SDT" />
                        <asp:BoundField DataField="DiaChi" HeaderText="Địa Chỉ" SortExpression="DiaChi" />
                        <asp:BoundField DataField="PTThanhToan" HeaderText="Thanh Toán" SortExpression="PTThanhToan" />

                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditOrder" CommandArgument='<%# Eval("MaDH") %>' CssClass="btn btn-warning btn-sm">
                                    <i class="fas fa-edit"></i> Sửa
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteOrder" CommandArgument='<%# Eval("MaDH") %>' OnClientClick="return confirm('Bạn có chắc chắn muốn xóa đơn hàng này?');" CssClass="btn btn-danger btn-sm">
                                    <i class="fas fa-trash-alt"></i> Xóa
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pgr" />
                    <HeaderStyle CssClass="gv-header" />
                    <RowStyle CssClass="gv-row" />
                    <AlternatingRowStyle CssClass="gv-alt-row" />
                </asp:GridView>
            </div>
            <%-- Empty data template --%>
            <asp:Panel ID="pnlNoOrders" runat="server" CssClass="alert alert-warning" Visible="false">
                <p><i class="fas fa-info-circle"></i> Không có đơn hàng nào được tìm thấy.</p>
            </asp:Panel>
        </div>
    </div>
</asp:Content>