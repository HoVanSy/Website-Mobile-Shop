<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="QuanLyDienThoai.aspx.cs" Inherits="DAN_FB.Admin.QuanLyDienThoai" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Quản Lý Điện Thoại
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    
    <title>Quản Lý Điện Thoại - Hệ Thống Quản Lý</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <%-- Content Block to wrap header, toolbar, and grid --%>
        <div class="content-block">
            <%-- Page Header --%>
            <div class="page-header">
                <div>
                    <h2>Quản Lý Điện Thoại</h2>
                    <p>Quản lý danh sách sản phẩm điện thoại</p>
                </div>
            </div>

            <%-- Toolbar (Search and Add) --%>
            <div class="toolbar">
                <div class="search-section">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Tìm kiếm theo tên sản phẩm..."></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary" OnClick="btnSearch_Click">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </asp:LinkButton>
                </div>
                <asp:LinkButton ID="btnAddProduct" runat="server" CssClass="btn btn-success" OnClick="btnAddProduct_Click">
                    <i class="fas fa-plus"></i> Thêm mới
                </asp:LinkButton>
            </div>

            <%-- GridView Container --%>
            <div class="table-wrapper">
                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False"
                    CssClass="data-table" HeaderStyle-CssClass="gv-header" RowStyle-CssClass="gv-row"
                    AlternatingRowStyle-CssClass="gv-alt-row" PagerStyle-CssClass="pgr"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvProducts_PageIndexChanging"
                    OnRowCommand="gvProducts_RowCommand" DataKeyNames="MaSP">
                    <Columns>
                        <asp:BoundField DataField="MaSP" HeaderText="Mã SP" SortExpression="MaSP" />
                        <asp:TemplateField HeaderText="Hình Ảnh">
                            <ItemTemplate>
                                <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("HinhAnh") %>'
                                    CssClass="gv-image" AlternateText='<%# Eval("TenSP") %>'
                                    OnError="this.onerror=null;this.src='https://placehold.co/60x60/cccccc/333333?text=No+Image';" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="TenSP" HeaderText="Tên Sản Phẩm" SortExpression="TenSP" />
                        <asp:BoundField DataField="TenLoai" HeaderText="Loại Sản Phẩm" SortExpression="TenLoai" />
                        <asp:BoundField DataField="Gia" HeaderText="Giá" SortExpression="Gia" DataFormatString="{0:N0} VNĐ" />
                        <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("MaSP") %>'
                                    CssClass="btn btn-warning"><i class="fas fa-edit"></i> Sửa</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("MaSP") %>'
                                    CssClass="btn btn-danger"><i class="fas fa-trash-alt"></i> Xóa</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pgr" />
                    <HeaderStyle CssClass="gv-header" />
                    <RowStyle CssClass="gv-row" />
                    <AlternatingRowStyle CssClass="gv-alt-row" />
                </asp:GridView>
            </div>

            <%-- No Data Message (if needed) --%>
            <asp:Panel ID="pnlNoProducts" runat="server" CssClass="no-data" Visible="false">
                <p><i class="fas fa-info-circle"></i> Không có sản phẩm nào được tìm thấy.</p>
            </asp:Panel>
        </div>
    </div>

    <%-- Modals remain the same as previous version --%>
    <%-- Add/Edit Product Modal --%>
    <div id="productModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle" runat="server">Thêm Mới Điện Thoại</h3>
                <button type="button" class="modal-close" onclick="hideProductModal()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="<%= txtTenSP.ClientID %>">Tên Sản Phẩm:</label>
                    <asp:TextBox ID="txtTenSP" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= ddlMaLoai.ClientID %>">Loại Sản Phẩm:</label>
                    <asp:DropDownList ID="ddlMaLoai" runat="server" CssClass="form-control" DataTextField="TenLoai" DataValueField="MaLoai" required="true"></asp:DropDownList>
                </div>
                <div class="form-group">
                    <label for="<%= txtGia.ClientID %>">Giá (VNĐ):</label>
                    <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtHinhAnh.ClientID %>">URL Hình Ảnh:</label>
                    <asp:TextBox ID="txtHinhAnh" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-actions">
                    <asp:LinkButton ID="btnSaveProduct" runat="server" CssClass="btn btn-success" OnClick="btnSaveProduct_Click">
                        <i class="fas fa-save"></i> Lưu
                    </asp:LinkButton>
                    <button type="button" class="btn btn-secondary" onclick="hideProductModal()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
                <asp:HiddenField ID="hfMaSP" runat="server" Value="" />
            </div>
        </div>
    </div>

    <%-- Delete Confirmation Modal --%>
    <div id="deleteConfirmModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Xác nhận xóa</h3>
                <button type="button" class="modal-close" onclick="hideDeleteConfirmModal()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa sản phẩm này không? Thao tác này không thể hoàn tác.</p>
                <div class="modal-buttons">
                    <asp:LinkButton ID="btnConfirmDelete" runat="server" CssClass="btn-confirm" OnClick="btnConfirmDelete_Click">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </asp:LinkButton>
                    <button type="button" class="btn-cancel" onclick="hideDeleteConfirmModal()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
                <asp:HiddenField ID="hfDeleteMaSP" runat="server" />
            </div>
        </div>
    </div>

    <%-- Custom Logout Confirmation Modal --%>
    <div id="logoutModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Xác nhận đăng xuất</h3>
                <button type="button" class="modal-close" onclick="hideLogoutModal()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn đăng xuất khỏi hệ thống không?</p>
                <div class="modal-buttons">
                    <asp:LinkButton ID="confirmLogoutLinkBtn" runat="server" CssClass="btn-confirm" OnClick="confirmLogoutLinkBtn_Click">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </asp:LinkButton>
                    <button class="btn-cancel" onclick="hideLogoutModal()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // JavaScript for modal handling
        document.addEventListener('DOMContentLoaded', function () {
            // Attach event to the "Add New" button to show modal
            const addProductBtn = document.getElementById('<%= btnAddProduct.ClientID %>');
            if (addProductBtn) {
                addProductBtn.addEventListener('click', function (e) {
                    // ASP.NET LinkButton will automatically postback.
                    // Form reset and title setting logic will be in code-behind (btnAddProduct_Click)
                    // and then call showProductModal from code-behind.
                    // Therefore, no e.preventDefault() is needed here if you want postback.
                });
            }

            // Attach event to the Logout button (if present in MasterPage or a standalone button here)
            const logoutTriggerBtn = document.getElementById('logoutBtn'); // Assuming there's a button/link with this ID to open the logout modal
            if (logoutTriggerBtn) {
                logoutTriggerBtn.addEventListener('click', function (e) {
                    e.preventDefault(); // Prevent default link behavior
                    showLogoutModal();
                });
            }

            // Close modal when clicking outside the modal content
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

        // Function to show product modal (called from Code-behind)
        function showProductModal(maSP, tenSP, maLoai, gia, hinhAnh) {
            const productModal = document.getElementById('productModal');
            document.getElementById('<%= modalTitle.ClientID %>').textContent = (maSP === '') ? 'Thêm Mới Điện Thoại' : 'Chỉnh Sửa Điện Thoại';
            document.getElementById('<%= hfMaSP.ClientID %>').value = maSP;
            document.getElementById('<%= txtTenSP.ClientID %>').value = tenSP;
            document.getElementById('<%= ddlMaLoai.ClientID %>').value = maLoai;
            document.getElementById('<%= txtGia.ClientID %>').value = gia;
            document.getElementById('<%= txtHinhAnh.ClientID %>').value = hinhAnh;
            
            productModal.style.display = 'flex';
            void productModal.offsetWidth; // Trigger reflow
            productModal.classList.add('is-visible');
        }

        // Function to hide product modal
        function hideProductModal() {
            const productModal = document.getElementById('productModal');
            productModal.classList.remove('is-visible');
            setTimeout(() => productModal.style.display = 'none', 300);
        }

        // Function to show delete confirmation modal (called from Code-behind)
        function showDeleteConfirmModal(maSP) {
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            document.getElementById('<%= hfDeleteMaSP.ClientID %>').value = maSP;
            deleteConfirmModal.style.display = 'flex';
            void deleteConfirmModal.offsetWidth; // Trigger reflow
            deleteConfirmModal.classList.add('is-visible');
        }

        // Function to hide delete confirmation modal
        function hideDeleteConfirmModal() {
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            deleteConfirmModal.classList.remove('is-visible');
            setTimeout(() => deleteConfirmModal.style.display = 'none', 300);
        }

        // Function to show logout modal
        function showLogoutModal() {
            const logoutModal = document.getElementById('logoutModal');
            logoutModal.style.display = 'flex';
            void logoutModal.offsetWidth; // Trigger reflow
            logoutModal.classList.add('is-visible');
        }

        // Function to hide logout modal
        function hideLogoutModal() {
            const logoutModal = document.getElementById('logoutModal');
            logoutModal.classList.remove('is-visible');
            setTimeout(() => logoutModal.style.display = 'none', 300);
        }

        // Ensure show/hide modal functions are re-called after each AJAX postback
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                // You can add specific logic here if modals need to be re-displayed after postback
                // For example: check a hidden field to know which modal needs to be displayed
            });
        }
    </script>
</asp:Content>