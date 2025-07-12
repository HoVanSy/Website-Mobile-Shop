<%@ Page Title="Giỏ Hàng Của Bạn" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="GioHang.aspx.cs" Inherits="DAN_FB.GioHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        /* CSS của bạn đã rất tốt, giữ nguyên */
        :root {
            --primary-color: #4A90E2; /* Màu xanh dương chính */
            --primary-hover: #3A7BCD; /* Màu xanh dương khi hover */
            --accent-color: #F5A623; /* Màu nhấn (vàng cam) */
            --accent-hover: #D88F1E; /* Màu nhấn khi hover */
            --success-color: #50E3C2; /* Màu xanh lá cây (thành công) */
            --danger-color: #E74C3C; /* Màu đỏ (lỗi, xóa) */
            --text-primary: #333333;
            --text-secondary: #666666;
            --background-white: #FFFFFF;
            --background-light: #F8F9FA;
            --border-color: #E0E0E0;
            --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 10px rgba(0, 0, 0, 0.08);
            --border-radius-sm: 5px;
            --border-radius-md: 10px;
            --transition: all 0.2s ease-in-out;
            --header-text-light: #FFFFFF;
        }

        body {
            background-color: var(--background-light); /* Nền nhẹ nhàng hơn */
        }

        .cart-container {
            max-width: 1000px; /* Giữ độ rộng vừa phải trên desktop */
            margin: 30px auto; /* Căn giữa, khoảng cách trên dưới */
            padding: 30px;
            background: var(--background-white);
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow-md);
            display: flex;
            flex-direction: column;
            gap: 25px; /* Khoảng cách lớn hơn giữa các phần */
        }

        .cart-header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color); /* Viền phân cách */
        }

        .cart-header h2 {
            font-size: 2.2rem; /* Kích thước lớn hơn */
            margin: 0;
            color: var(--primary-color);
            font-weight: 700;
        }

        .cart-header .cart-count {
            font-size: 1.1rem;
            color: var(--text-secondary);
            margin-top: 5px;
        }

        .cart-content {
            background: var(--background-white);
            border-radius: var(--border-radius-md);
            overflow: hidden; /* Dành cho GridView */
            max-height: 500px; /* Chiều cao tối đa cho danh sách sản phẩm để cuộn */
            overflow-y: auto; /* Thêm thanh cuộn */
            -webkit-overflow-scrolling: touch;
            border: 1px solid var(--border-color); /* Thêm viền nhẹ */
        }

        /* Tùy chỉnh thanh cuộn */
        .cart-content::-webkit-scrollbar {
            width: 8px;
        }
        .cart-content::-webkit-scrollbar-track {
            background: var(--background-light);
            border-radius: var(--border-radius-md);
        }
        .cart-content::-webkit-scrollbar-thumb {
            background: var(--border-color);
            border-radius: var(--border-radius-md);
        }
        .cart-content::-webkit-scrollbar-thumb:hover {
            background: var(--text-secondary);
        }

        .cart-grid {
            width: 100%;
            border-collapse: collapse;
        }

        .cart-grid th {
            background-color: var(--primary-color); /* Màu header từ Master Page */
            color: var(--header-text-light); /* Chữ trắng */
            padding: 15px 20px;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .cart-grid td {
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            font-size: 0.95rem;
            color: var(--text-primary);
        }

        .cart-grid tr:last-child td {
            border-bottom: none;
        }

        .cart-grid tr:hover {
            background-color: var(--background-light); /* Nền sáng hơn khi hover */
            transition: var(--transition);
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 15px; /* Khoảng cách lớn hơn */
        }

        .product-image { /* Style cho ảnh sản phẩm nếu có */
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: var(--border-radius-sm);
            border: 1px solid var(--border-color);
        }

        .product-name {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1rem;
            max-width: 250px; /* Giới hạn chiều rộng tên sản phẩm */
        }

        .product-price {
            font-weight: 700;
            color: var(--accent-color); /* Màu nhấn */
            font-size: 1rem;
        }

        .quantity-display {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .qty-btn {
            background-color: var(--background-light);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 5px 10px;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            font-size: 0.9rem;
        }

        .qty-btn:hover {
            background-color: var(--primary-color);
            color: var(--header-text-light);
            border-color: var(--primary-color);
        }

        .quantity-input {
            width: 50px;
            text-align: center;
            padding: 5px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            font-size: 0.9rem;
            color: var(--text-primary);
            outline: none;
            -moz-appearance: textfield; /* Hide arrows on Firefox */
        }
        /* Hide arrows on Chrome, Safari, Edge */
        .quantity-input::-webkit-outer-spin-button,
        .quantity-input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .subtotal-price { /* Đổi tên từ .total-price để phân biệt với tổng cuối cùng */
            font-weight: 700;
            color: var(--danger-color); /* Màu đỏ cho tổng từng sản phẩm */
            font-size: 1rem;
        }

        .delete-btn {
            background-color: var(--danger-color); /* Màu đỏ */
            color: var(--header-text-light);
            border: none;
            padding: 8px 15px;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: var(--transition);
            font-size: 0.85rem;
        }

        .delete-btn:hover {
            background-color: #CC3322; /* Đỏ sẫm hơn khi hover */
            box-shadow: var(--shadow-sm);
        }

        /* --- Mã khuyến mãi và tổng tiền --- */
        .coupon-summary-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 20px;
            border-top: 1px solid var(--border-color);
            background: var(--background-white);
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow-sm);
        }

        .coupon-code-input {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .coupon-code-input label {
            font-weight: 600;
            color: var(--text-primary);
            flex-shrink: 0; /* Ngăn label co lại */
        }

        .coupon-code-input input[type="text"] {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            font-size: 0.95rem;
            color: var(--text-primary);
            outline: none;
            transition: border-color var(--transition);
        }

        .coupon-code-input input[type="text"]:focus {
            border-color: var(--primary-color);
        }

        .btn-apply-coupon {
            background-color: var(--success-color); /* Màu xanh lá cây */
            color: var(--header-text-light);
            border: none;
            padding: 10px 20px;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            font-size: 0.95rem;
            flex-shrink: 0; /* Ngăn nút co lại */
        }

        .btn-apply-coupon:hover {
            background-color: #3BB898; /* Xanh lá sẫm hơn */
            box-shadow: var(--shadow-sm);
        }

        .coupon-message {
            margin-top: 10px;
            font-size: 0.9rem;
            color: #28a745; /* Màu xanh lá cây cho thông báo thành công */
            font-weight: 500;
        }
        .coupon-message.error {
            color: var(--danger-color); /* Màu đỏ cho lỗi */
        }

        .cart-summary-details {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 1rem;
            color: var(--text-primary);
        }

        .summary-row.total {
            font-size: 1.3rem; /* Tổng cuối cùng lớn hơn */
            font-weight: 700;
            color: var(--primary-color);
            border-top: 1px dashed var(--border-color); /* Đường gạch đứt */
            padding-top: 10px;
            margin-top: 10px;
        }

        .summary-row span:last-child {
            font-weight: 600;
        }

        .cart-actions {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding-top: 15px;
            border-top: 1px solid var(--border-color); /* Viền phân cách */
        }

        .btn { /* Cập nhật lại style chung cho nút */
            padding: 12px 25px;
            border: none;
            border-radius: var(--border-radius-sm);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
            transition: var(--transition);
            min-width: 180px; /* Giữ min-width để nút không quá nhỏ */
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
            text-decoration: none; /* Đảm bảo không có gạch chân khi hover */
            color: var(--header-text-light); /* Đảm bảo chữ trắng khi hover */
        }

        .btn-continue {
            background-color: var(--primary-color);
            color: var(--header-text-light);
        }

        .btn-continue:hover {
            background-color: var(--primary-hover);
        }

        .btn-checkout {
            background-color: var(--accent-color);
            color: var(--header-text-light);
        }

        .btn-checkout:hover {
            background-color: var(--accent-hover);
        }

        .empty-cart {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-secondary);
            background-color: var(--background-light);
            border-radius: var(--border-radius-md);
            margin: 20px; /* Khoảng cách với container */
        }

        .empty-cart-icon {
            font-size: 4em;
            margin-bottom: 15px;
            color: var(--primary-color); /* Icon giỏ hàng màu chính */
        }

        .empty-cart h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--text-primary);
        }

        .empty-cart p {
            font-size: 1rem;
            margin-bottom: 25px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .cart-container {
                margin: 15px auto;
                padding: 15px;
                gap: 15px;
            }

            .cart-header h2 {
                font-size: 1.8rem;
            }

            .cart-grid th,
            .cart-grid td {
                padding: 10px;
                font-size: 0.85rem;
            }

            .product-info {
                flex-direction: column; /* Xếp chồng ảnh và tên sản phẩm */
                align-items: flex-start;
                gap: 5px;
            }
            .product-image {
                width: 50px;
                height: 50px;
            }
            .product-name {
                max-width: none; /* Bỏ giới hạn chiều rộng trên mobile */
            }

            /* Ẩn bớt cột trên mobile */
            /* Thêm class 'd-none-mobile' vào HeaderStyle và ItemStyle của cột bạn muốn ẩn trên mobile */
            /* Ví dụ: <HeaderStyle CssClass="d-none-mobile" /> <ItemStyle CssClass="d-none-mobile" /> */
            /* Thay vì dùng nth-child, dùng class để dễ quản lý hơn */
            .d-none-mobile { display: none !important; }


            .coupon-code-input {
                flex-direction: column;
                align-items: stretch;
                gap: 15px;
            }
            .btn-apply-coupon {
                width: 100%;
            }

            .cart-summary-details {
                font-size: 0.9rem;
            }
            .summary-row.total {
                font-size: 1.1rem;
            }

            .cart-actions {
                flex-direction: column;
                gap: 10px;
            }
            .btn {
                width: 100%;
                max-width: none;
            }
        }

        @media (max-width: 480px) {
            .cart-container {
                padding: 10px;
                border-radius: 0;
                box-shadow: none;
            }
            .cart-header h2 {
                font-size: 1.5rem;
            }
            .cart-grid th,
            .cart-grid td {
                padding: 8px 5px;
                font-size: 0.8rem;
            }
            .product-image {
                width: 40px;
                height: 40px;
            }
            .product-name {
                font-size: 0.9rem;
            }
            .product-price, .subtotal-price {
                font-size: 0.9rem;
            }
            .delete-btn {
                padding: 6px 10px;
                font-size: 0.8rem;
            }
            .empty-cart {
                padding: 30px 10px;
            }
            .empty-cart-icon {
                font-size: 3em;
            }
            .empty-cart h3 {
                font-size: 1.3rem;
            }
            .empty-cart p {
                font-size: 0.9rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cart-container">
        <div class="cart-header">
            <h2>🛒 Giỏ Hàng Của Bạn</h2>
            <div class="cart-count">Quản lý sản phẩm dễ dàng</div>
        </div>

        <div class="cart-content">
            <asp:GridView ID="GridView1" runat="server"
                AutoGenerateColumns="False"
                AllowSorting="True"
                Width="100%"
                DataKeyNames="idSP"
                CssClass="cart-grid"
                GridLines="None"
                EmptyDataText="<div class='empty-cart'><div class='empty-cart-icon'>🛍️</div><h3>Giỏ hàng trống</h3><p>Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy thêm sản phẩm vào giỏ để tiếp tục mua sắm!</p><asp:Button ID='btnEmptyCartContinue' runat='server' Text='🛒 Bắt đầu mua sắm' CssClass='btn btn-continue' OnClick='Button2_Click' /></div>"
                OnRowDeleting="GridView1_RowDeleting"
                OnRowEditing="GridView1_RowEditing"
                OnRowUpdating="GridView1_RowUpdating"
                OnRowCancelingEdit="GridView1_RowCancelingEdit"
                OnRowCommand="GridView1_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="#" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px" HeaderStyle-CssClass="d-none-mobile" ItemStyle-CssClass="d-none-mobile">
                        <ItemTemplate>
                            <span style="font-weight: 600; color: var(--text-secondary);"><%# Container.DataItemIndex + 1 %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Sản Phẩm" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <div class="product-info">
                                <%-- <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("AnhSP") %>' CssClass="product-image" AlternateText='<%# Eval("TenSP") %>' /> --%>
                                <div class="product-name"><%# Eval("TenSP") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Giá Bán" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="100px">
                        <ItemTemplate>
                            <span class="product-price"><%# String.Format("{0:N0} VNĐ", Convert.ToDecimal(Eval("Gia"))) %></span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="lblGiaEdit" runat="server" Text='<%# String.Format("{0:N0} VNĐ", Eval("Gia")) %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Số Lượng" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px">
                        <ItemTemplate>
                            <div class="quantity-display">
                                <asp:LinkButton ID="btnDecreaseQty" runat="server" Text="-" CssClass="qty-btn" 
                                    CommandName="DecreaseQty" CommandArgument='<%# Eval("idSP") %>' />
                                <span class="quantity-text-display"><%# Eval("SoLuong") %></span>
                                <asp:LinkButton ID="btnIncreaseQty" runat="server" Text="+" CssClass="qty-btn" 
                                    CommandName="IncreaseQty" CommandArgument='<%# Eval("idSP") %>' />
                            </div>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <div class="quantity-display">
                                <asp:LinkButton ID="btnDecreaseQtyEdit" runat="server" Text="-" CssClass="qty-btn" 
                                    CommandName="DecreaseQtyEdit" CommandArgument='<%# Eval("idSP") %>' />
                                <asp:TextBox ID="txtEditQuantity" runat="server" Text='<%# Eval("SoLuong") %>' 
                                    CssClass="quantity-input" TextMode="Number" min="1"></asp:TextBox>
                                <asp:LinkButton ID="btnIncreaseQtyEdit" runat="server" Text="+" CssClass="qty-btn" 
                                    CommandName="IncreaseQtyEdit" CommandArgument='<%# Eval("idSP") %>' />
                            </div>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Thành Tiền" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="120px">
                        <ItemTemplate>
                            <span class="subtotal-price"><%# String.Format("{0:N0} VNĐ", Eval("TongTien")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Thao Tác" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px">
                        <ItemTemplate>
                             <asp:LinkButton ID="lbEditProduct" runat="server" Text="✏️ Sửa" CssClass="btn btn-info btn-sm" CommandName="Edit" />
                            <asp:LinkButton ID="lbXoaSanpham"
                                Text="🗑️ Xóa"
                                runat="server"
                                CssClass="delete-btn"
                                OnClientClick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?');"
                                CommandName="Delete" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="btnUpdate" runat="server" Text="✔️ Lưu" CssClass="btn-apply-coupon" CommandName="Update" />
                            <asp:LinkButton ID="btnCancel" runat="server" Text="✖️ Hủy" CssClass="delete-btn" CommandName="Cancel" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="cart-grid-header" />
                <RowStyle CssClass="cart-grid-row" />
                <AlternatingRowStyle CssClass="cart-grid-alt-row" />
            </asp:GridView>
        </div>

        <div class="coupon-summary-section" id="coupon_summary_section" runat="server">
            <%-- Phần mã khuyến mãi --%>
            <div class="coupon-code-input">
                <label for="<%= txtCouponCode.ClientID %>">Mã khuyến mãi:</label>
                <asp:TextBox ID="txtCouponCode" runat="server" CssClass="form-control" placeholder="Nhập mã khuyến mãi"></asp:TextBox>
                <asp:Button ID="btnApplyCoupon" runat="server" Text="Áp dụng" CssClass="btn-apply-coupon" OnClick="btnApplyCoupon_Click" />
            </div>
            <asp:Label ID="lblCouponMessage" runat="server" CssClass="coupon-message" EnableViewState="false"></asp:Label>

            <%-- Phần tổng tiền chi tiết --%>
            <div class="cart-summary-details">
                <div class="summary-row">
                    <span>Tổng tiền hàng:</span>
                    <span><asp:Label ID="lblSubtotal" runat="server" Text="0 VNĐ"></asp:Label></span>
                </div>
                <div class="summary-row">
                    <span>Mã giảm giá:</span>
                    <span><asp:Label ID="lblDiscount" runat="server" Text="0 VNĐ"></asp:Label></span>
                </div>
                <div class="summary-row total">
                    <span>Tổng Thanh Toán:</span>
                    <span><asp:Label ID="lblGrandTotal" runat="server" Text="0 VNĐ"></asp:Label></span>
                </div>
                <%-- Label Tongtien cũ, có runat="server", giữ lại nếu cần dùng trong code-behind --%>
                <p style="display: none;">
                    Tổng tiền (old style): <asp:Label ID="Tongtien" runat="server" Text="0 VNĐ"></asp:Label>
                </p>
            </div>
        </div>
        
        <div class="cart-actions" id="cart_actions" runat="server">
            <asp:Button ID="btnContinueShopping" runat="server" 
                OnClick="Button2_Click"  
                Text="🛍️ Tiếp tục mua sắm"
                CssClass="btn btn-continue" />
            <asp:Button ID="btnDatHang" runat="server"
                Text="💳 Đặt hàng ngay"
                CssClass="btn btn-checkout"
                OnClick="btnDatHang_Click"/>
        </div>
    </div>

    <%-- JavaScript cho nút tăng/giảm số lượng --%>
    <script type="text/javascript">
        // Hàm này sẽ trigger postback thủ công cho các nút tăng/giảm số lượng
        // để code-behind có thể xử lý cập nhật dữ liệu.
        // Đây là cách đơn giản, bạn có thể cân nhắc dùng UpdatePanel để AJAX hóa.
        function handleQuantityButtonClick(event) {
            event.preventDefault(); // Ngăn chặn hành động mặc định của LinkButton

            const button = event.target;
            const commandName = button.getAttribute('CommandName');
            const commandArgument = button.getAttribute('CommandArgument');

            // Cập nhật giá trị hiển thị trước để có phản hồi nhanh cho người dùng (optional)
            let quantityElement;
            if (commandName.includes('Edit')) {
                // Trong EditItemTemplate, số lượng là TextBox
                quantityElement = button.closest('.quantity-display').querySelector('input[type="number"]');
            } else {
                // Trong ItemTemplate, số lượng là Span
                quantityElement = button.closest('.quantity-display').querySelector('.quantity-text-display');
            }

            if (quantityElement) {
                let currentQty = parseInt(quantityElement.innerText || quantityElement.value);
                if (isNaN(currentQty)) currentQty = 1; // Đảm bảo là số

                if (commandName.includes('Decrease')) {
                    if (currentQty > 1) {
                        currentQty--;
                    }
                } else if (commandName.includes('Increase')) {
                    currentQty++;
                }

                if (commandName.includes('Edit')) {
                    quantityElement.value = currentQty;
                } else {
                    quantityElement.innerText = currentQty;
                }
            }

            // Thực hiện PostBack để ASP.NET xử lý CommandName và CommandArgument
            __doPostBack(button.name, '');
        }

        // Lắng nghe sự kiện thay đổi trên input số lượng khi ở chế độ chỉnh sửa
        function handleQuantityInputChange(event) {
            let value = parseInt(this.value);
            if (isNaN(value) || value < 1) {
                this.value = 1; // Mặc định là 1 nếu không hợp lệ
            }
        }

        // Gắn sự kiện cho các nút tăng/giảm số lượng và input quantity
        function setupQuantityButtons() {
            document.querySelectorAll('.qty-btn').forEach(button => {
                // Đảm bảo không gắn nhiều lần sự kiện
                button.removeEventListener('click', handleQuantityButtonClick);
                button.addEventListener('click', handleQuantityButtonClick);
            });

            document.querySelectorAll('.quantity-input[type="number"]').forEach(input => {
                input.removeEventListener('change', handleQuantityInputChange);
                input.addEventListener('change', handleQuantityInputChange);
            });
        }

        // Gọi hàm setup khi trang tải và sau mỗi lần UpdatePanel cập nhật
        document.addEventListener('DOMContentLoaded', setupQuantityButtons);

        // Nếu bạn sử dụng UpdatePanel, hãy thêm dòng này để thiết lập lại sự kiện sau AJAX update
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(setupQuantityButtons);
        }
    </script>
</asp:Content>