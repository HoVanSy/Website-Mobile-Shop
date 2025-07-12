<%@ Page Title="" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="ViewSP.aspx.cs" Inherits="DAN_FB.ViewSP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* Loại bỏ .auto-style1 nếu không còn sử dụng */
        /* .auto-style1 { height: 25px; } */

        /* Sử dụng biến từ Master Page để nhất quán */
        .product-detail-container {
            display: flex;
            gap: 40px; /* Tăng khoảng cách để thoáng hơn */
            padding: 40px;
            background: var(--background-white); /* Nền trắng từ Master Page */
            border-radius: var(--border-radius-md); /* Bo góc từ Master Page */
            box-shadow: var(--shadow-md); /* Bóng đổ từ Master Page */
            max-width: 1200px; /* Giới hạn chiều rộng để không quá rộng trên màn hình lớn */
            margin: 30px auto; /* Căn giữa và có khoảng cách với body */
            align-items: flex-start; /* Căn trên cùng */
        }

        .product-image-section {
            flex: 0 0 400px; /* Cố định chiều rộng ảnh lớn hơn */
            max-width: 400px;
            border-radius: var(--border-radius-md);
            overflow: hidden; /* Đảm bảo ảnh không tràn ra khỏi bo góc */
        }

        .product-detail-image {
            width: 100%;
            height: auto;
            display: block; /* Loại bỏ khoảng trắng dưới ảnh */
            object-fit: cover; /* Đảm bảo ảnh đầy đủ khung mà không bị méo */
            transition: transform var(--transition); /* Thêm hiệu ứng hover */
        }
        
        .product-detail-image:hover {
            transform: scale(1.03); /* Phóng to nhẹ khi hover */
        }

        .product-info-section {
            flex: 1;
            padding-top: 10px; /* Căn chỉnh với ảnh */
        }

        .product-title {
            font-size: 2.2rem; /* Tăng kích thước tiêu đề */
            margin-bottom: 15px;
            color: var(--text-primary); /* Màu chữ chính từ Master Page */
            font-weight: 700;
        }

        .product-info p {
            font-size: 1rem;
            color: var(--text-secondary); /* Màu chữ phụ từ Master Page */
            margin-bottom: 8px;
        }
        
        .product-info strong {
            color: var(--text-primary);
        }

        .product-price-section {
            margin-top: 20px;
            font-size: 1.8rem; /* Tăng kích thước giá */
            color: var(--accent-color); /* Màu nhấn từ Master Page (vàng cam) */
            font-weight: bold;
            display: flex;
            align-items: baseline;
            gap: 10px;
        }
        .product-price-section .price-label {
            font-size: 1rem;
            color: var(--text-secondary);
            font-weight: normal;
        }

        .product-quantity-section {
            margin-top: 30px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .quantity-label {
            font-size: 1rem;
            color: var(--text-primary);
            font-weight: 500;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            border: 1px solid var(--border-color); /* Border từ Master Page */
            border-radius: var(--border-radius-sm);
            width: fit-content; /* Điều chỉnh chiều rộng vừa đủ */
            overflow: hidden;
        }

        .quantity-input {
            width: 70px; /* Tăng chiều rộng input số lượng */
            text-align: center;
            padding: 8px 0;
            font-size: 1.1rem;
            border: none; /* Bỏ border riêng của input */
            outline: none;
            background-color: var(--background-white);
            color: var(--text-primary);
        }

        .qty-btn {
            background-color: var(--background-light); /* Nền nút từ Master Page */
            color: var(--text-primary);
            border: none;
            padding: 8px 15px;
            font-size: 1.2rem;
            cursor: pointer;
            transition: var(--transition);
            flex-shrink: 0; /* Ngăn nút co lại */
        }

        .qty-btn:hover {
            background-color: var(--primary-color); /* Hover màu chính */
            color: var(--header-text-light); /* Chữ trắng */
        }
        .qty-btn:active {
            transform: scale(0.95); /* Hiệu ứng click */
        }

        .product-actions {
            margin-top: 40px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap; /* Cho phép các nút xuống dòng trên mobile */
        }

        .btn-base {
            padding: 12px 25px;
            border: none;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
        }

        .btn-base:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .btn-add-to-cart {
            background-color: var(--primary-color); /* Màu chính từ Master Page */
            color: var(--header-text-light);
        }

        .btn-buy-now {
            background-color: var(--accent-color); /* Màu nhấn từ Master Page */
            color: var(--header-text-light);
        }

        /* Responsive Design cho trang chi tiết sản phẩm */
        @media (max-width: 992px) {
            .product-detail-container {
                flex-direction: column; /* Xếp chồng ảnh và thông tin */
                gap: 30px;
                padding: 30px;
                margin: 20px auto;
            }

            .product-image-section {
                flex: none;
                width: 100%;
                max-width: 500px; /* Giới hạn chiều rộng ảnh trên tablet */
                margin: 0 auto;
            }

            .product-title {
                font-size: 2rem;
            }

            .product-price-section {
                font-size: 1.6rem;
            }
            .product-actions {
                flex-direction: column; /* Xếp chồng nút trên mobile nhỏ */
            }
            .btn-base {
                width: 100%; /* Nút chiếm toàn bộ chiều rộng */
            }
        }

        @media (max-width: 576px) {
            .product-detail-container {
                padding: 20px;
                gap: 20px;
                margin: 15px auto;
            }
            .product-image-section {
                max-width: 100%; /* Ảnh chiếm toàn bộ chiều rộng trên mobile nhỏ */
            }
            .product-title {
                font-size: 1.8rem;
                margin-bottom: 10px;
            }
            .product-price-section {
                font-size: 1.4rem;
                margin-top: 15px;
            }
            .product-info p {
                font-size: 0.95rem;
            }
            .qty-btn {
                padding: 6px 12px;
                font-size: 1.1rem;
            }
            .quantity-input {
                width: 60px;
                font-size: 1rem;
            }
            .btn-base {
                padding: 10px 20px;
                font-size: 0.9rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="product-detail-container">
        <div class="product-image-section">
            <asp:Image ID="Image1" runat="server" CssClass="product-detail-image" AlternateText="Ảnh sản phẩm" />
        </div>
        
        <div class="product-info-section">
            <%-- Hidden Label for Product ID (Good for passing data, Visible=false makes it accessible only programmatically) --%>
            <asp:Label ID="Label4" runat="server" Text="" Visible="false"></asp:Label>
            
            <h1 class="product-title">
                <asp:Label ID="Label1" runat="server" Text="Tên Sản Phẩm"></asp:Label>
            </h1>
            
            <div class="product-info">
                <p><strong>Đơn vị tính:</strong> <asp:Label ID="Label2" runat="server" Text="Cái"></asp:Label></p>
                <%-- Thêm mô tả sản phẩm nếu có --%>
                <p><strong>Mô tả:</strong> <asp:Label ID="lblDescription" runat="server" Text="Mô tả chi tiết sản phẩm sẽ được hiển thị ở đây."></asp:Label></p>
            </div>
            
            <div class="product-price-section">
                <span class="price-label">Giá bán:</span>
                <span class="price-amount">
                    <asp:Label ID="Label3" runat="server" Text="0.000.000"></asp:Label> ₫
                </span>
            </div>

            <div class="product-quantity-section">
                <label for="<%= txtSL.ClientID %>" class="quantity-label">Số lượng:</label>
                <div class="quantity-controls">
                    <button type="button" class="qty-btn" onclick="decreaseQty('<%= txtSL.ClientID %>')" aria-label="Giảm số lượng">-</button>
                    <asp:TextBox ID="txtSL" runat="server" Text="1" CssClass="quantity-input" TextMode="Number" min="1"></asp:TextBox>
                    <button type="button" class="qty-btn" onclick="increaseQty('<%= txtSL.ClientID %>')" aria-label="Tăng số lượng">+</button>
                </div>
            </div>

            <div class="product-actions">
                <asp:Button ID="btnAddToCart" runat="server" 
                    Text="Thêm vào giỏ hàng" 
                    CssClass="btn-add-to-cart btn-base"
                    OnClick="btnAddToCart_Click"
                    OnClientClick="return showAddToCartMessage();" />
                <asp:Button ID="btnBuyNow" runat="server" 
                    Text="Mua ngay" 
                    CssClass="btn-buy-now btn-base"
                    OnClick="btnBuyNow_Click" />
            </div>
        </div>
    </div>

    <%-- JavaScript cho nút tăng/giảm số lượng và thông báo --%>
    <script type="text/javascript">
        function decreaseQty(txtId) {
            var txtSL = document.getElementById(txtId);
            var qty = parseInt(txtSL.value) || 1; // Đảm bảo là số, mặc định là 1
            if (qty > 1) {
                txtSL.value = qty - 1;
            }
        }

        function increaseQty(txtId) {
            var txtSL = document.getElementById(txtId);
            var qty = parseInt(txtSL.value) || 1;
            // Có thể thêm giới hạn max nếu có tồn kho
            txtSL.value = qty + 1;
        }

        // Tùy chọn: Thêm thông báo khi thêm vào giỏ hàng
        function showAddToCartMessage() {
            // Thay thế bằng thư viện toast/modal chuyên nghiệp hơn nếu cần
            alert('Sản phẩm đã được thêm vào giỏ hàng!');
            return true; // Trả về true để ASP.NET vẫn xử lý sự kiện server-side
        }

        // Đảm bảo input số lượng luôn là số nguyên dương và không nhỏ hơn 1
        document.addEventListener('DOMContentLoaded', function() {
            const quantityInput = document.getElementById('<%= txtSL.ClientID %>');
            if (quantityInput) {
                quantityInput.addEventListener('change', function () {
                    let value = parseInt(this.value);
                    if (isNaN(value) || value < 1) {
                        this.value = 1; // Mặc định là 1 nếu không hợp lệ
                    }
                });
            }
        });
    </script>
</asp:Content>