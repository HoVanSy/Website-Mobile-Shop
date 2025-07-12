<%@ Page Title="Quản Lý Khuyến Mãi" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="QuanLyKhuyenMai.aspx.cs" Inherits="DAN_FB.Admin.QuanLyKhuyenMai" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Quản Lý Khuyến Mãi
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
   
    <title>Quản Lý Khuyến Mãi - Hệ Thống Quản Lý</title>
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
                    <h2>Quản Lý Khuyến Mãi</h2>
                    <p>Quản lý các chương trình khuyến mãi hiện có</p>
                </div>
            </div>

            <%-- Toolbar (Search and Add) --%>
            <div class="toolbar">
                <div class="search-section">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Tìm kiếm theo mã hoặc tên khuyến mãi..."></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary" OnClick="btnSearch_Click">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </asp:LinkButton>
                </div>
                <asp:LinkButton ID="btnAddPromotion" runat="server" CssClass="btn btn-success" OnClick="btnAddPromotion_Click">
                    <i class="fas fa-plus"></i> Thêm mới
                </asp:LinkButton>
            </div>

            <%-- GridView Container --%>
            <div class="table-wrapper">
                <asp:GridView ID="gvKhuyenMai" runat="server" AutoGenerateColumns="False" DataKeyNames="MaKM"
                    CssClass="data-table" HeaderStyle-CssClass="gv-header" RowStyle-CssClass="gv-row"
                    AlternatingRowStyle-CssClass="gv-alt-row" PagerStyle-CssClass="pgr"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvKhuyenMai_PageIndexChanging"
                    OnRowCommand="gvKhuyenMai_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="MaKM" HeaderText="Mã KM" SortExpression="MaKM" />
                        <asp:BoundField DataField="TenKM" HeaderText="Tên KM" SortExpression="TenKM" />
                        <asp:BoundField DataField="GiaTriGiam" HeaderText="Giá Trị Giảm (VND)" SortExpression="GiaTriGiam" />
                        <asp:BoundField DataField="TrangThai" HeaderText="Trạng Thái" SortExpression="TrangThai" />
                        <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditPromotion" CommandArgument='<%# Eval("MaKM") %>'
                                    CssClass="btn btn-warning"><i class="fas fa-edit"></i> Sửa</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeletePromotion" CommandArgument='<%# Eval("MaKM") %>'
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

            <%-- No Data Message --%>
            <asp:Panel ID="pnlNoPromotions" runat="server" CssClass="no-data" Visible="false">
                <p><i class="fas fa-info-circle"></i> Không có khuyến mãi nào được tìm thấy.</p>
            </asp:Panel>
        </div>
    </div>

    <%-- Add/Edit Promotion Modal --%>
    <div id="promotionModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitlePromotion" runat="server">Thêm Mới Khuyến Mãi</h3>
                <button type="button" class="modal-close" onclick="hidePromotionModal()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="<%= txtMaKM.ClientID %>">Mã KM:</label>
                    <asp:TextBox ID="txtMaKM" runat="server" CssClass="form-control" required="true" Enabled="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtTenKM.ClientID %>">Tên KM:</label>
                    <asp:TextBox ID="txtTenKM" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtGiaTriGiam.ClientID %>">Giá Trị Giảm (VND):</label>
                    <asp:TextBox ID="txtGiaTriGiam" runat="server" CssClass="form-control" TextMode="Number" required="true"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= ddlTrangThai.ClientID %>">Trạng Thái:</label>
                    <asp:DropDownList ID="ddlTrangThai" runat="server" CssClass="form-control" required="true">
                        <asp:ListItem Text="Áp dụng" Value="1" Selected="True" />
                        <asp:ListItem Text="Không áp dụng" Value="0" />
                    </asp:DropDownList>
                </div>
                <div class="form-actions">
                    <asp:LinkButton ID="btnSavePromotion" runat="server" CssClass="btn btn-success" OnClick="btnSavePromotion_Click">
                        <i class="fas fa-save"></i> Lưu
                    </asp:LinkButton>
                    <button type="button" class="btn btn-secondary" onclick="hidePromotionModal()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
                <asp:HiddenField ID="hfMaKM" runat="server" Value="" />
            </div>
        </div>
    </div>

    <%-- Delete Confirmation Modal --%>
    <div id="deleteConfirmModalPromotion" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Xác nhận xóa</h3>
                <button type="button" class="modal-close" onclick="hideDeleteConfirmModalPromotion()" aria-label="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa khuyến mãi này không? Thao tác này không thể hoàn tác.</p>
                <div class="modal-buttons">
                    <asp:LinkButton ID="btnConfirmDeletePromotion" runat="server" CssClass="btn-confirm" OnClick="btnConfirmDeletePromotion_Click">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </asp:LinkButton>
                    <button type="button" class="btn-cancel" onclick="hideDeleteConfirmModalPromotion()">
                        <i class="fas fa-times-circle"></i> Hủy
                    </button>
                </div>
                <asp:HiddenField ID="hfDeleteMaKM" runat="server" />
            </div>
        </div>
    </div>

    <%-- Custom Logout Confirmation Modal (assuming it's in MasterPage or globally handled) --%>
    <%-- Nếu bạn muốn giữ modal đăng xuất riêng ở đây, hãy sao chép từ QuanLyDienThoai.aspx --%>

    <script type="text/javascript">
        // JavaScript for modal handling
        document.addEventListener('DOMContentLoaded', function () {
            // Attach event to the "Add New" button to show modal
            const addPromotionBtn = document.getElementById('<%= btnAddPromotion.ClientID %>');
            if (addPromotionBtn) {
                addPromotionBtn.addEventListener('click', function (e) {
                    // This click will trigger a postback, and the code-behind will call showPromotionModal
                    // No need for e.preventDefault() here.
                });
            }

            // Close modal when clicking outside the modal content
            const modals = document.querySelectorAll('.modal-overlay');
            modals.forEach(modal => {
                modal.addEventListener('click', function (event) {
                    if (event.target === modal) {
                        modal.classList.remove('is-visible');
                        // Use a small timeout to allow the transition to complete before hiding fully
                        setTimeout(() => modal.style.display = 'none', 300);
                    }
                });
            });
        });

        // Function to show promotion modal (called from Code-behind)
        function showPromotionModal(maKM, tenKM, giaTriGiam, trangThai, isNew) {
            const promotionModal = document.getElementById('promotionModal');
            document.getElementById('<%= modalTitlePromotion.ClientID %>').textContent = (isNew === 'true') ? 'Thêm Mới Khuyến Mãi' : 'Chỉnh Sửa Khuyến Mãi';
            document.getElementById('<%= hfMaKM.ClientID %>').value = maKM;

            // Enable or disable MaKM textbox based on whether it's a new entry or edit
            const txtMaKM = document.getElementById('<%= txtMaKM.ClientID %>');
            txtMaKM.value = maKM;
            txtMaKM.disabled = (isNew === 'false'); // Disable MaKM for edits

            document.getElementById('<%= txtTenKM.ClientID %>').value = tenKM;
            document.getElementById('<%= txtGiaTriGiam.ClientID %>').value = giaTriGiam;
            document.getElementById('<%= ddlTrangThai.ClientID %>').value = trangThai;

            promotionModal.style.display = 'flex';
            void promotionModal.offsetWidth; // Trigger reflow
            promotionModal.classList.add('is-visible');
        }

        // Function to hide promotion modal
        function hidePromotionModal() {
            const promotionModal = document.getElementById('promotionModal');
            promotionModal.classList.remove('is-visible');
            setTimeout(() => promotionModal.style.display = 'none', 300);
        }

        // Function to show delete confirmation modal (called from Code-behind)
        function showDeleteConfirmModalPromotion(maKM) {
            const deleteConfirmModal = document.getElementById('deleteConfirmModalPromotion');
            document.getElementById('<%= hfDeleteMaKM.ClientID %>').value = maKM;
            deleteConfirmModal.style.display = 'flex';
            void deleteConfirmModal.offsetWidth; // Trigger reflow
            deleteConfirmModal.classList.add('is-visible');
        }

        // Function to hide delete confirmation modal
        function hideDeleteConfirmModalPromotion() {
            const deleteConfirmModal = document.getElementById('deleteConfirmModalPromotion');
            deleteConfirmModal.classList.remove('is-visible');
            setTimeout(() => deleteConfirmModal.style.display = 'none', 300);
        }

        // Ensure show/hide modal functions are re-called after each AJAX postback
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                
            });
        }
    </script>
</asp:Content>