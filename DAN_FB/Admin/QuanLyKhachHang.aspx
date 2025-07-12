<%@ Page Title="Quản Lý Khách Hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="QuanLyKhachHang.aspx.cs" Inherits="DAN_FB.Admin.QuanLyKhachHang" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Quản Lý Khách Hàng
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    
    <title>Quản Lý Khách Hàng - Hệ Thống Quản Lý</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="content-block">
            <%-- Page Header --%>
            <div class="page-header">
                <div>
                    <h2>Quản Lý Khách Hàng</h2>
                    <p>Quản lý danh sách tài khoản người dùng và quản trị viên</p>
                </div>
            </div>

            <%-- Toolbar (Search and Add) --%>
            <div class="toolbar">
                <div class="search-section">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Tìm theo tên, email, username..."></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary" OnClick="btnSearch_Click">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </asp:LinkButton>
                </div>
                <asp:LinkButton ID="btnAddCustomer" runat="server" CssClass="btn btn-success" OnClick="btnAddCustomer_Click">
                    <i class="fas fa-plus"></i> Thêm mới
                </asp:LinkButton>
            </div>

            <%-- GridView Container --%>
            <div class="table-wrapper">
                <asp:GridView ID="gvKhachHang" runat="server" AutoGenerateColumns="False" DataKeyNames="UserID"
                    CssClass="data-table" PagerStyle-CssClass="pgr"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvKhachHang_PageIndexChanging"
                    OnRowCommand="gvKhachHang_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="UserID" HeaderText="ID" />
                        <asp:BoundField DataField="hoten" HeaderText="Họ Tên" />
                        <asp:BoundField DataField="Username" HeaderText="Username" />
                        <asp:BoundField DataField="email" HeaderText="Email" />
                        <asp:BoundField DataField="sdt" HeaderText="SĐT" />
                        <asp:BoundField DataField="ngay_tao_tk" HeaderText="Ngày Tạo" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="RoleName" HeaderText="Vai Trò" />
                        <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCustomer" CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="btn btn-warning"><i class="fas fa-edit"></i> Sửa</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCustomer" CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="btn btn-danger"><i class="fas fa-trash-alt"></i> Xóa</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pgr" />
                </asp:GridView>
            </div>

            <%-- No Data Message --%>
            <asp:Panel ID="pnlNoCustomers" runat="server" CssClass="no-data" Visible="false">
                <p><i class="fas fa-info-circle"></i> Không có khách hàng nào được tìm thấy.</p>
            </asp:Panel>
        </div>
    </div>

    <%-- Add/Edit Customer Modal --%>
    <div id="customerModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitleCustomer" runat="server">Thêm Mới Khách Hàng</h3>
                <button type="button" class="modal-close" onclick="hideCustomerModal()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="<%= txtHoTen.ClientID %>">Họ Tên:</label>
                    <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtUsername.ClientID %>">Username:</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtEmail.ClientID %>">Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtPassword.ClientID %>">Mật khẩu:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    <p id="passwordNote" class="password-note" style="display:none;"><i class="fas fa-info-circle"></i> Để trống nếu không muốn thay đổi mật khẩu.</p>
                </div>
                <div class="form-group">
                    <label for="<%= txtSDT.ClientID %>">Số Điện Thoại:</label>
                    <asp:TextBox ID="txtSDT" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtNgaySinh.ClientID %>">Ngày Sinh:</label>
                    <asp:TextBox ID="txtNgaySinh" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
                 <div class="form-group">
                    <label for="<%= ddlRole.ClientID %>">Vai trò:</label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" required="true"></asp:DropDownList>
                </div>
                <div class="form-actions">
                    <asp:LinkButton ID="btnSaveChanges" runat="server" CssClass="btn btn-success" OnClick="btnSaveChanges_Click">
                        <i class="fas fa-save"></i> Lưu
                    </asp:LinkButton>
                    <button type="button" class="btn btn-secondary" onclick="hideCustomerModal()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
                <asp:HiddenField ID="hfUserID" runat="server" Value="0" />
            </div>
        </div>
    </div>

    <%-- Delete Confirmation Modal --%>
    <div id="deleteConfirmModalCustomer" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Xác nhận xóa</h3>
                <button type="button" class="modal-close" onclick="hideDeleteConfirmModalCustomer()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa người dùng này không? Thao tác này không thể hoàn tác.</p>
                <div class="modal-buttons">
                    <asp:LinkButton ID="btnConfirmDelete" runat="server" CssClass="btn-confirm" OnClick="btnConfirmDelete_Click">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </asp:LinkButton>
                    <button type="button" class="btn-cancel" onclick="hideDeleteConfirmModalCustomer()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
                <asp:HiddenField ID="hfDeleteUserID" runat="server" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // JavaScript for modal handling, consistent with QuanLyKhuyenMai
        document.addEventListener('DOMContentLoaded', function () {
            const modals = document.querySelectorAll('.modal-overlay');
            modals.forEach(modal => {
                modal.addEventListener('click', function (event) {
                    if (event.target === modal) {
                        modal.classList.remove('is-visible');
                        setTimeout(() => modal.style.display = 'none', 300);
                    }
                });
            });
        });

        // Function to show Add/Edit customer modal (called from Code-behind)
        function showCustomerModal(userID, hoTen, username, email, sdt, ngaySinh, roleID, isNew) {
            const modal = document.getElementById('customerModal');
            document.getElementById('<%= modalTitleCustomer.ClientID %>').textContent = (isNew === 'true') ? 'Thêm Mới Người Dùng' : 'Chỉnh Sửa Người Dùng';
            document.getElementById('<%= hfUserID.ClientID %>').value = userID;

            const txtUsername = document.getElementById('<%= txtUsername.ClientID %>');
            txtUsername.value = username;
            txtUsername.disabled = (isNew === 'false'); // Disable username for edits

            document.getElementById('<%= txtHoTen.ClientID %>').value = hoTen;
            document.getElementById('<%= txtEmail.ClientID %>').value = email;
            document.getElementById('<%= txtSDT.ClientID %>').value = sdt;
            document.getElementById('<%= txtNgaySinh.ClientID %>').value = ngaySinh;
            document.getElementById('<%= ddlRole.ClientID %>').value = roleID;

            // Clear password and show/hide note
            document.getElementById('<%= txtPassword.ClientID %>').value = '';
            document.getElementById('passwordNote').style.display = (isNew === 'true') ? 'none' : 'block';

            modal.style.display = 'flex';
            void modal.offsetWidth; // Trigger reflow
            modal.classList.add('is-visible');
        }

        // Function to hide Add/Edit customer modal
        function hideCustomerModal() {
            const modal = document.getElementById('customerModal');
            modal.classList.remove('is-visible');
            setTimeout(() => modal.style.display = 'none', 300);
        }

        // Function to show delete confirmation modal (called from Code-behind)
        function showDeleteConfirmModalCustomer(userID) {
            const modal = document.getElementById('deleteConfirmModalCustomer');
            document.getElementById('<%= hfDeleteUserID.ClientID %>').value = userID;
            modal.style.display = 'flex';
            void modal.offsetWidth; // Trigger reflow
            modal.classList.add('is-visible');
        }

        // Function to hide delete confirmation modal
        function hideDeleteConfirmModalCustomer() {
            const modal = document.getElementById('deleteConfirmModalCustomer');
            modal.classList.remove('is-visible');
            setTimeout(() => modal.style.display = 'none', 300);
        }
    </script>
</asp:Content>